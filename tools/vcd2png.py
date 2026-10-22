#!/usr/bin/env python3
"""Render a VCD file to a waveform PNG, styled after GTKWave (dark theme).

    python tools/vcd2png.py wave.vcd -o wave.png
    python tools/vcd2png.py wave.vcd -o wave.png --signals "A,B,Ci,S,Co" --cursor 3000
"""
import argparse
import re
from pathlib import Path

import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from matplotlib.patches import Polygon, Rectangle

BG = "#000000"
PANEL = "#000000"
GRID = "#3a3a3a"
TRACE = "#00ff00"
BUS_FILL = "#007a00"
BUS_EDGE = "#00ff00"
HIGH_FILL = "#0e5c0e"     # shaded area under a logic 1
HIGH_EDGE = "#00ff00"
NAME = "#d7d7d7"
VALUE = "#e8e8e8"
CURSOR = "#ffff00"
RULER = "#cfcfcf"


def parse_vcd(path):
    """Return (ns_per_tick, {name: [(t, value), ...]})."""
    ids, changes = {}, {}
    scope = []
    time = 0
    in_defs = True
    timescale = "1ns"
    want_ts = False

    with open(path, encoding="utf-8", errors="ignore") as f:
        for raw in f:
            line = raw.strip()
            if not line:
                continue
            if in_defs:
                if line.startswith("$scope"):
                    scope.append(line.split()[2])
                elif line.startswith("$upscope"):
                    if scope:
                        scope.pop()
                elif line.startswith("$timescale"):
                    parts = line.split()
                    if len(parts) >= 3:
                        timescale = parts[1] + parts[2]
                    else:
                        want_ts = True
                elif want_ts:
                    timescale = line
                    want_ts = False
                elif line.startswith("$var"):
                    p = line.split()
                    vid = p[3]
                    name = " ".join(p[4:-1])
                    if vid not in ids:
                        ids[vid] = ".".join(scope + [name])
                elif line.startswith("$enddefinitions"):
                    in_defs = False
                continue
            if line[0] == "#":
                time = int(line[1:])
                continue
            if line[0] in "01xzXZ" and len(line) > 1:
                value, vid = line[0], line[1:]
            elif line[0] in "bB":
                parts = line.split()
                if len(parts) < 2:
                    continue
                value, vid = parts[0][1:], parts[1]
            else:
                continue
            name = ids.get(vid)
            if name is not None:
                changes.setdefault(name, []).append((time, value))

    m = re.match(r"(\d+)([munp]?s)", timescale)
    if m:
        val, unit = int(m.group(1)), m.group(2)
        factor = {"s": 1e9, "ms": 1e6, "us": 1e3, "ns": 1.0, "ps": 1e-3}[unit]
        return val * factor, changes
    return 1.0, changes


def pick(changes, names):
    out = []
    for n in names:
        for full, data in changes.items():
            if full == n or full.endswith("." + n):
                width = 1 if all(v in "01xzXZ" for _, v in data) and len(data[0][1]) == 1 \
                    else max(len(v) for _, v in data)
                out.append((full, data, width))
                break
    return out


def fmt(v):
    if v in "01xzXZ":
        return v
    try:
        return format(int(v, 2), "x")
    except ValueError:
        return v


def value_at(data, t_ns, unit_ns):
    val = None
    for t, v in data:
        if t * unit_ns <= t_ns + 1e-9:
            val = v
        else:
            break
    return val


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("vcd")
    ap.add_argument("-o", "--out", default="wave.png")
    ap.add_argument("--signals", default="")
    ap.add_argument("--title", default="")
    ap.add_argument("--cursor", type=float, default=None, help="cursor time in ns")
    ap.add_argument("--dpi", type=int, default=200)
    args = ap.parse_args()

    unit_ns, changes = parse_vcd(args.vcd)
    if not changes:
        raise SystemExit("no signals in VCD")

    wanted = [s for s in re.split(r"[,\s]+", args.signals) if s]
    if not wanted:
        wanted = sorted(changes, key=lambda n: (n.count("."), len(n), n))[:10]
    rows = pick(changes, wanted)
    if not rows:
        raise SystemExit("no matching signals")

    pitch = 1.3
    fig_w = 12.0
    fig_h = 0.42 * len(rows) + 1.3
    fig = plt.figure(figsize=(fig_w, fig_h), facecolor=BG)
    gs = fig.add_gridspec(1, 3, width_ratios=[0.13, 0.05, 0.82], wspace=0.0)
    axn = fig.add_subplot(gs[0, 0])
    axv = fig.add_subplot(gs[0, 1])
    ax = fig.add_subplot(gs[0, 2])

    all_t = [t * unit_ns for _, data, _w in rows for t, _ in data]
    t0, t1 = min(all_t), max(all_t)
    if t1 <= t0:
        t1 = t0 + 1
    cursor_t = args.cursor if args.cursor is not None else t0

    for i, (name, data, width) in enumerate(rows):
        y = (len(rows) - 1 - i) * pitch
        ts = [t * unit_ns for t, _ in data]
        values = [v for _, v in data]
        if width == 1:
            ys = [{"0": 0.0, "1": 1.0}.get(v, 0.5) for v in values]
            ax.step(ts, [v + y for v in ys], where="post", color=TRACE, lw=1.1, zorder=3)
            # shade every segment where the signal is high
            for k, v in enumerate(values):
                if v != "1":
                    continue
                t0_s, t1_s = ts[k], ts[k + 1] if k + 1 < len(ts) else t1
                ax.add_patch(Rectangle((t0_s, y), t1_s - t0_s, 1.0, facecolor=HIGH_FILL,
                                       edgecolor="none", hatch="////", zorder=1))
                # top edge (roof) of the shaded area
                ax.plot([t0_s, t1_s], [y + 1.0, y + 1.0], color=TRACE, lw=1.1,
                        solid_capstyle="butt", zorder=3)
        else:
            ys = []
            for v in values:
                try:
                    ys.append(int(v, 2) / float(2 ** width - 1))
                except ValueError:
                    ys.append(0.5)
            for k in range(len(ts)):
                t_next = ts[k + 1] if k + 1 < len(ts) else ts[k] + 0.1
                yy = y + 0.85 * ys[k]
                w = max((t_next - ts[k]) * 0.15, 0.04)
                ax.add_patch(Polygon([(ts[k], yy), (ts[k] + w, yy + 0.3), (t_next - w, yy + 0.3), (t_next, yy)],
                                     closed=True, facecolor=BUS_FILL, edgecolor=BUS_EDGE, lw=0.8))
                ax.text((ts[k] + t_next) / 2, yy + 0.15, fmt(values[k]), ha="center", va="center",
                        fontsize=5.5, family="monospace", color=VALUE)

        short = name.split(".")[-1]
        axn.text(0.97, y + 0.45, short, ha="right", va="center", fontsize=8.5,
                 family="monospace", color=NAME)
        val = value_at(data, cursor_t, unit_ns)
        axv.text(0.10, y + 0.45, fmt(val) if val is not None else "", ha="left", va="center",
                 fontsize=8.5, family="monospace", color=VALUE)

    top = (len(rows) - 1) * pitch + 1.35
    for a in (ax, axn, axv):
        a.set_ylim(-0.35, top)
        a.set_yticks([])
        a.set_xticks([])
        for s in ("top", "right", "bottom", "left"):
            a.spines[s].set_visible(False)
    ax.set_xlim(t0, t1)
    axn.set_xlim(0, 1)
    axv.set_xlim(0, 1)
    for a in (ax, axn, axv):
        a.set_facecolor(PANEL)

    # time ruler on top, GTKWave style
    span = t1 - t0
    step = next((c for c in (0.5, 1, 2, 5, 10, 20, 25, 50, 100, 200, 250, 500, 1000)
                 if span / c <= 14), span)
    t = t0
    while t <= t1 + 1e-9:
        ax.axvline(t, color=GRID, lw=0.7, zorder=0)
        axn.axvline(t, color=GRID, lw=0.7, zorder=0)
        ax.text(t, top - 0.30, f"{t:g}", ha="center", va="center", fontsize=7,
                family="monospace", color=RULER)
        t += step
    for k in range(int(span / (step / 5)) + 1):
        tt = t0 + k * step / 5
        ax.plot([tt, tt], [top - 0.16, top - 0.04], color="#7a7a7a", lw=0.6)

    # cursor
    ax.axvline(cursor_t, color=CURSOR, lw=1.0, alpha=0.9)
    axn.axvline(cursor_t, color=CURSOR, lw=1.0, alpha=0.9)
    ax.text(cursor_t, top - 0.02, f"{cursor_t:g}", ha="center", va="center", fontsize=7.5,
            family="monospace", color="#000000",
            bbox=dict(boxstyle="square,pad=0.25", fc=CURSOR, ec="none"))

    if args.title:
        fig.text(0.012, 0.975, args.title, fontsize=10, color=RULER, va="top")
    axn.text(0.97, top - 0.02, "Name", ha="right", va="center", fontsize=8,
             family="monospace", color="#9a9a9a")
    axv.text(0.10, top - 0.02, "Value", ha="left", va="center", fontsize=8,
             family="monospace", color="#9a9a9a")
    fig.subplots_adjust(left=0.02, right=0.995, top=0.90, bottom=0.06)
    fig.savefig(args.out, dpi=args.dpi, facecolor=BG)
    print(f"wrote {args.out} ({len(rows)} signals)")


if __name__ == "__main__":
    main()
