#!/usr/bin/env python3
"""SPICE simulation of the Lab 3 circuits (LTspice and ngspice, headless).

    python tools/spice_lab3.py

For every circuit one netlist is written and simulated with both simulators:
    - <circuit>.cir    : the netlist (opens in LTspice and in ngspice)
    - spice_table_*.txt: truth table taken from the SPICE simulation
    - spice_wave.png   : waveform, drawn with the GTKWave look of tools/vcd2png.py

The netlist only uses arithmetic and the ternary operator, so the same file
runs unchanged in LTspice and in ngspice.
"""
import subprocess
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from spice import run_ltspice, run_ngspice, parse_raw, to_vcd, logic_at

ROOT = Path(__file__).resolve().parent.parent
VCC = 5.0


# ---------------------------------------------------------------- gate models
def gate_and(x, y):
    return "V(%s)*V(%s) > 12.5 ? %g : 0" % (x, y, VCC)


def gate_or(x, y):
    return "V(%s)+V(%s) > 2.5 ? %g : 0" % (x, y, VCC)


def gate_xor(x, y):
    # the levels are 0 or 5 V, so x + y = 5 V exactly when the inputs differ
    return "V(%s)+V(%s) > 2.5 ? (V(%s)+V(%s) < 7.5 ? %g : 0) : 0" % (x, y, x, y, VCC)


def counter_bit(period_ns, n_bits=4, tstop_ns=1600):
    """PWL of a counter bit that toggles every period_ns."""
    pts, t = [], 0
    level = 0
    while t < tstop_ns:
        t2 = t + period_ns - 1
        pts.append("%dn %g" % (t, level))
        pts.append("%dn %g" % (t2, level))
        level = 5 - level
        t += period_ns
    pts.append("%dn %g" % (tstop_ns, level))
    return "PWL(" + " ".join(pts) + ")"


# ---------------------------------------------------------------- circuits
def full_adder_body():
    """1 bit full adder: S = A xor B xor Ci, Co = A.B + T1.Ci"""
    return [
        "V_A  a  0 PWL(0 0 99n 0 101n 5 199n 5 201n 0 299n 0 301n 5 399n 5 401n 0 "
        "499n 0 501n 5 599n 5 601n 0 699n 0 701n 5 799n 5 801n 0)",
        "V_B  b  0 PWL(0 0 199n 0 201n 5 399n 5 401n 0 599n 0 601n 5 799n 5 801n 0)",
        "V_CI ci 0 PWL(0 0 399n 0 401n 5 799n 5 801n 0)",
        "B_T1 t1 0 V = %s" % gate_xor("a", "b"),
        "B_S  s  0 V = %s" % gate_xor("t1", "ci"),
        "B_C1 c1 0 V = %s" % gate_and("a", "b"),
        "B_C2 c2 0 V = %s" % gate_and("t1", "ci"),
        "B_CO co 0 V = %s" % gate_or("c1", "c2"),
    ]


def adder4_body():
    """4 bit ripple adder (Figure 3.1): A + B + Ci, B = 0011."""
    body = []
    for i in range(4):
        body.append("V_A%d a%d 0 %s" % (i, i, counter_bit(100 * 2 ** i)))
    for i in range(4):
        level = 5 if i in (0, 1) else 0
        body.append("V_B%d b%d 0 %g" % (i, i, level))
    body.append("V_CI ci 0 0")
    for i in range(4):
        a, b = "a%d" % i, "b%d" % i
        ci = "ci" if i == 0 else "c%d" % i
        body.append("B_T1%d t%d 0 V = %s" % (i, i, gate_xor(a, b)))
        body.append("B_S%d  s%d 0 V = %s" % (i, i, gate_xor("t%d" % i, ci)))
        body.append("B_X%d  x%d 0 V = %s" % (i, i, gate_and(a, b)))
        body.append("B_Y%d  y%d 0 V = %s" % (i, i, gate_and("t%d" % i, ci)))
        body.append("B_C%d  c%d 0 V = %s" % (i + 1, i + 1, gate_or("x%d" % i, "y%d" % i)))
    return body


def netlist(title, body, tstop=800):
    lines = ["* %s" % title, "* gate level behavioural model, runs in LTspice and ngspice"]
    lines += body
    lines.append(".tran 2n %dn" % tstop)
    lines.append(".end")
    return "\n".join(lines) + "\n"


# ---------------------------------------------------------------- checking
def sample_table(times_ns, series, inputs, outputs, windows):
    """Sample the circuit in the middle of every 100 ns window."""
    rows = []
    for k in range(windows):
        t = 50 + 100 * k
        row = [logic_at(series, raw, t, times_ns) for raw in inputs]
        row += [logic_at(series, raw, t, times_ns) for raw in outputs]
        rows.append(row)
    return rows


def render(vcd_path, png_path, signals, title, cursor_ns=250.0):
    cmd = [sys.executable, str(ROOT / "tools" / "vcd2png.py"), str(vcd_path),
           "-o", str(png_path), "--signals", ",".join(signals), "--title", title,
           "--cursor", str(cursor_ns)]
    subprocess.run(cmd, check=True)


def run_circuit(folder, net_name, deck, inputs, outputs, vcd_signals, title,
                windows=8, expected=None):
    folder = Path(folder)
    (folder / net_name).write_text(deck, encoding="utf-8")
    # the simulators run on a copy inside sim/ so their raw and log files stay
    # out of the repository
    scratch = folder / "sim"
    scratch.mkdir(exist_ok=True)

    for sim, runner in (("LTspice", run_ltspice), ("ngspice", run_ngspice)):
        deck_run = scratch / ("%s_%s" % (sim.lower(), net_name))
        deck_run.write_text(deck, encoding="utf-8")
        raw, log = runner(deck_run)
        if raw is None:
            print(f"!! {sim} failed in {folder.name}:\n{log[-800:]}")
            continue
        names, times_ns, series = parse_raw(raw)
        rows = sample_table(times_ns, series, inputs, outputs, windows)
        head = " ".join(inputs + outputs)
        text = "SPICE simulation (%s), %s\n%s\n" % (sim, title, head)
        for r in rows:
            text += " ".join(r) + "\n"
        if expected is not None:
            ok = all(r == e for r, e in zip(rows, expected))
            text += "RESULT: %s\n" % ("PASS" if ok else "FAIL")
        (folder / ("spice_table_%s.txt" % sim.lower())).write_text(text, encoding="utf-8")
        if sim == "LTspice":
            vcd = to_vcd(scratch / "spice_wave.vcd", times_ns, series, vcd_signals)
            render(vcd, folder / "spice_wave.png", [s for s, _ in vcd_signals], title)
        print(f"--- {folder.name} [{sim}] ---")
        print(text)


# ---------------------------------------------------------------- jobs
FA_INPUTS = ["V(a)", "V(b)", "V(ci)"]
FA_OUTPUTS = ["V(s)", "V(co)"]
FA_SIGNALS = [("A", "V(a)"), ("B", "V(b)"), ("Ci", "V(ci)"), ("S", "V(s)"), ("Co", "V(co)")]
FA_EXPECTED = [
    ["0", "0", "0", "0", "0"],
    ["1", "0", "0", "1", "0"],
    ["0", "1", "0", "1", "0"],
    ["1", "1", "0", "0", "1"],
    ["0", "0", "1", "1", "0"],
    ["1", "0", "1", "0", "1"],
    ["0", "1", "1", "0", "1"],
    ["1", "1", "1", "1", "1"],
]

ADDER4_INPUTS = ["V(a3)", "V(a2)", "V(a1)", "V(a0)"]
ADDER4_OUTPUTS = ["V(s3)", "V(s2)", "V(s1)", "V(s0)", "V(c4)"]
ADDER4_SIGNALS = ([("A%d" % i, "V(a%d)" % i) for i in range(3, -1, -1)] +
                   [("B%d" % i, "V(b%d)" % i) for i in range(3, -1, -1)] +
                   [("S%d" % i, "V(s%d)" % i) for i in range(3, -1, -1)] +
                   [("Co", "V(c4)")])


def adder4_expected():
    rows = []
    for a in range(16):
        total = a + 3
        bits = [(total >> i) & 1 for i in range(4)]
        rows.append(["%d" % ((a >> i) & 1) for i in range(3, -1, -1)] +
                    ["%d" % b for b in bits[::-1]] +
                    ["1" if total >= 16 else "0"])
    return rows


JOBS = [
    ("PRELAB_3/EXP_3_1", "full_adder.cir", full_adder_body(), FA_INPUTS, FA_OUTPUTS,
     FA_SIGNALS, "Full adder - LTspice / ngspice transient analysis", 8, FA_EXPECTED),
    ("LAB_3/EXP_1_full_adder", "full_adder.cir", full_adder_body(), FA_INPUTS, FA_OUTPUTS,
     FA_SIGNALS, "Full adder - LTspice / ngspice transient analysis", 8, FA_EXPECTED),
    ("PRELAB_3/EXP_3_2", "adder4.cir", adder4_body(), ADDER4_INPUTS, ADDER4_OUTPUTS,
     ADDER4_SIGNALS, "4 bit ripple adder - LTspice / ngspice transient analysis", 16,
     adder4_expected()),
    ("LAB_3/EXP_2_addsub_4bit", "adder4.cir", adder4_body(), ADDER4_INPUTS, ADDER4_OUTPUTS,
     ADDER4_SIGNALS, "4 bit ripple adder - LTspice / ngspice transient analysis", 16,
     adder4_expected()),
]


def main():
    for rel, net_name, body, ins, outs, sigs, title, windows, expected in JOBS:
        tstop = 1600 if windows > 8 else 800
        run_circuit(ROOT / rel, net_name, netlist(title, body, tstop), ins, outs, sigs,
                    title, windows, expected)


if __name__ == "__main__":
    main()
