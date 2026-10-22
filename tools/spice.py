#!/usr/bin/env python3
"""SPICE helpers: build a netlist, run LTspice / ngspice headless, read results.

LTspice (batch):
    LTspice.exe -b -ascii deck.cir            -> deck.raw (ASCII raw file)

ngspice (batch):
    ngspice.exe -D filetype=ascii -b -o deck.log -r deck.raw deck.cir

Both simulators accept the same netlist (only arithmetic and the ternary
operator are used, no simulator specific functions).

The results are converted to a VCD so that tools/vcd2png.py can draw the
waveform with the GTKWave look used in the report.
"""
import subprocess
from pathlib import Path

LTSPICE = r"C:\Users\ACER\AppData\Local\Programs\ADI\LTspice\LTspice.exe"
NGSPICE = r"D:\megatools\Qucs-S\bin\ngspice.exe"


# ---------------------------------------------------------------- simulators
def run_ltspice(deck, timeout=300):
    """Run LTspice in batch mode. Returns (raw_path, log_text)."""
    deck = Path(deck)
    subprocess.run([LTSPICE, "-b", "-ascii", str(deck)],
                   capture_output=True, text=True, timeout=timeout)
    raw = deck.with_suffix(".raw")
    log = deck.with_suffix(".log")
    return (raw if raw.exists() else None), (log.read_text(errors="ignore") if log.exists() else "")


def run_ngspice(deck, timeout=300):
    """Run ngspice in batch mode. Returns (raw_path, log_text)."""
    deck = Path(deck)
    log = deck.with_suffix(".log")
    subprocess.run([NGSPICE, "-D", "filetype=ascii", "-b", "-o", str(log), "-r",
                    str(deck.with_suffix(".raw")), str(deck)],
                   capture_output=True, text=True, timeout=timeout, cwd=str(deck.parent))
    raw = deck.with_suffix(".raw")
    return (raw if raw.exists() else None), (log.read_text(errors="ignore") if log.exists() else "")


# ---------------------------------------------------------------- raw files
def parse_raw(path):
    """Parse an ASCII .raw file (LTspice and ngspice flavour).

    Returns (names, times_ns, {name: values}).
    """
    lines = Path(path).read_text(errors="ignore").splitlines()
    names, values = [], []
    i = 0
    while i < len(lines):
        line = lines[i]
        if line.startswith("Variables:"):
            i += 1
            while i < len(lines):
                row = lines[i]
                if not row.strip() or row.startswith("Values:") or row.startswith("Binary:"):
                    break
                parts = row.split()
                if len(parts) >= 2:
                    names.append(parts[1])
                i += 1
            continue
        if line.startswith("Values:"):
            i += 1
            for raw in lines[i:]:
                parts = raw.split()
                if not parts:
                    continue
                try:
                    values.append([float(p) for p in parts])
                except ValueError:
                    continue
            break
        i += 1
    if not names or not values:
        raise SystemExit("cannot read raw file %s" % path)

    n = len(names)
    times, series = [], {}
    ltspice_style = len(values) >= 2 and len(values[0]) == 2 and len(values[1]) == 1
    if ltspice_style:
        # LTspice style: one value per line, the first line of a point is
        # "<index>\t<time>"
        flat = [row[-1] for row in values]
        for k in range(0, len(flat) - n + 1, n):
            times.append(flat[k] * 1e9)
            for j in range(1, n):
                series.setdefault(names[j], []).append(flat[k + j])
    else:
        # ngspice style: one line per point -> <index> <time> <values...>
        for row in values:
            times.append(row[1] * 1e9)
            for k in range(1, n):
                series.setdefault(names[k], []).append(row[k] if k < len(row) else 0.0)
    return names, times, series


# ---------------------------------------------------------------- outputs
def to_vcd(path, times_ns, series, signals, threshold=2.5):
    """Write a 1 bit VCD from analog series. signals: [(vcd_name, raw_name)].

    Only value changes are written, like a real VCD file.
    """
    path = Path(path)
    ids = {vname: chr(ord("a") + k) for k, (vname, _raw) in enumerate(signals)}
    out = ["$timescale 1ns $end", "$scope module spice $end"]
    for vname, _ in signals:
        out.append("$var wire 1 %s %s $end" % (ids[vname], vname))
    out.append("$upscope $end")
    out.append("$enddefinitions $end")
    last = {vname: None for vname, _ in signals}
    for k, t in enumerate(times_ns):
        changed = False
        bits = {}
        for vname, raw in signals:
            v = get_series(series, raw)
            bit = "1" if k < len(v) and v[k] > threshold else "0"
            bits[vname] = bit
            if last[vname] != bit:
                changed = True
            last[vname] = bit
        if not changed:
            continue
        out.append("#%d" % int(round(t)))
        for vname, _ in signals:
            out.append("%s%s" % (bits[vname], ids[vname]))
    path.write_text("\n".join(out) + "\n", encoding="utf-8")
    return path


def get_series(series, name):
    """Look a trace up, ignoring the case (ngspice writes v(a), LTspice V(a))."""
    if name in series:
        return series[name]
    low = name.lower()
    for key, vals in series.items():
        if key.lower() == low:
            return vals
    return []


def logic_at(series, raw, t_ns, times_ns, threshold=2.5):
    """Logic value of a signal at a given time (last sample before t_ns)."""
    v = get_series(series, raw)
    val = "0"
    for k, t in enumerate(times_ns):
        if t <= t_ns + 1e-9 and k < len(v):
            val = "1" if v[k] > threshold else "0"
        else:
            break
    return val
