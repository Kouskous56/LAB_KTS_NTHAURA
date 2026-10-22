#!/usr/bin/env python3
"""Draw the logic diagram of every Lab 2 circuit.

    python tools/draw_lab2.py
"""
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from schematic import Sheet

ROOT = Path(__file__).resolve().parent.parent


def route(s, src, dst, lane=None):
    """Draw an orthogonal wire from src to dst (horizontal first)."""
    (sx, sy), (dx, dy) = src, dst
    if sy == dy:
        s.wire(sx, sy, dx, dy)
        return
    lx = lane if lane is not None else (sx + dx) / 2.0
    s.wire(sx, sy, lx, sy)
    s.wire(lx, sy, lx, dy)
    s.wire(lx, dy, dx, dy)


def inputs(s, names, x=6, y0=54, step=6):
    """Input pins on the left. Returns the (x, y) point of every input."""
    out = []
    for k, name in enumerate(names):
        y = y0 - step * k
        s.dot(x, y)
        s.label(x - 3, y, name, size=8, ha="right")
        out.append((x, y))
    return out


def inverters(s, x, points, names, w=4, h=6):
    """NOT gates producing the inverted inputs."""
    out = []
    for (px, py), name in zip(points, names):
        s.gate("NOT", x, py, w=w, h=h)
        s.wire(px, py, x, py)
        s.text(x + w / 2.0, py + h / 2.0 + 2.0, "~" + name, size=7)
        out.append((x + w, py))
    return out


def gate(s, kind, x, y, ins, label=None, w=6, h=8):
    """Gate whose inputs are wired from the given points."""
    s.gate(kind, x, y, w=w, h=h, label=label)
    n = len(ins)
    ys = [y - h / 2.0 + (h / (n + 1.0)) * (i + 1) for i in range(n)]
    for k, (yi, src) in enumerate(zip(ys, ins)):
        route(s, src, (x, yi), lane=src[0] + 2.0 + 4 * k)
    return (x + w, y)


def exp_2_1(path):
    """f = x'yz + (xy)'z + xy"""
    s = Sheet(11, 5.6, "EXP_2_1 - Full Adder: f = x'yz + (xy)'z + xy")
    ax, by, ci = inputs(s, ["x", "y", "z"])
    nx = inverters(s, 13, [ax], ["x"])[0]
    xy = gate(s, "AND", 38, 30, [ax, by], "xy")
    nxy = gate(s, "NOT", 50, 30, [xy], w=4, h=6)
    t1 = gate(s, "AND", 38, 48, [nx, by, ci], "t1")
    t2 = gate(s, "AND", 38, 14, [nxy, ci], "t2")
    f = gate(s, "OR", 74, 30, [t1, t2, xy], "f")
    s.wire(f[0], f[1], 92, f[1])
    s.label(93, f[1], "f", size=8, ha="left")
    s.text(50, 3, "t1 = ~x.y.z      t2 = ~(x.y).z      t3 = x.y      f = t1 + t2 + t3", size=9)
    s.save(path)


def exp_2_2(path):
    """F = (Y&Z) + (~X&~Y) + (~Y&~Z)"""
    s = Sheet(11, 5.6, "EXP_2_2 - F = sum m(0,1,3,4,7)")
    ax, by, ci = inputs(s, ["X", "Y", "Z"])
    nx, ny, nz = inverters(s, 13, [ax, by, ci], ["X", "Y", "Z"])
    a1 = gate(s, "AND", 40, 46, [by, ci], "a1")
    a2 = gate(s, "AND", 40, 30, [nx, ny], "a2")
    a3 = gate(s, "AND", 40, 14, [ny, nz], "a3")
    f = gate(s, "OR", 74, 30, [a1, a2, a3], "F")
    s.wire(f[0], f[1], 92, f[1])
    s.label(93, f[1], "F", size=8, ha="left")
    s.text(50, 3, "a1 = Y.Z        a2 = ~X.~Y        a3 = ~Y.~Z        F = a1 + a2 + a3", size=9)
    s.save(path)


def exp_2_3(path):
    """F = NOR(NOR(x, yz), NAND(~y, x))"""
    s = Sheet(11, 5.6, "EXP_2_3 - Figure 2.4: F = NOR(NOR(x, y.z), NAND(~y, x))")
    ax, by, ci = inputs(s, ["x", "y", "z"])
    ny = inverters(s, 13, [by], ["y"])[0]
    yz = gate(s, "AND", 34, 40, [by, ci], "yz")
    a = gate(s, "NOR", 58, 34, [ax, yz], "A")
    b = gate(s, "NAND", 58, 14, [ny, ax], "B")
    f = gate(s, "NOR", 78, 24, [a, b], "F")
    s.wire(f[0], f[1], 92, f[1])
    s.label(93, f[1], "F", size=8, ha="left")
    s.text(50, 3, "A = NOR(x, y.z)      B = NAND(~y, x)      F = NOR(A, B) = x.~y", size=9)
    s.save(path)


def minterm_diagram(title, formula, keep, path):
    """Drawing of the minterm sum used by EXP_2_4 and EXP_2_5."""
    s = Sheet(11, 5.6, title)
    ax, by, ci = inputs(s, ["x", "y", "z"], y0=52, step=9)
    nx, ny, nz = inverters(s, 14, [ax, by, ci], ["x", "y", "z"], w=3.5, h=5)
    plain = (ax, by, ci)
    inv = (nx, ny, nz)
    names = ("x", "y", "z")
    outs = []
    for k, m in enumerate(keep):
        y = 48 - 11 * k
        bits = ((m >> 2) & 1, (m >> 1) & 1, m & 1)
        ins = [p if bit else n for bit, p, n in zip(bits, plain, inv)]
        expr = ["%s%s" % ("" if bit else "~", names[i]) for i, bit in enumerate(bits)]
        out = gate(s, "AND", 46, y, ins, None, w=5, h=7)
        s.text(48, y - 6.5, "m%d = %s" % (m, ".".join(expr)), size=7.5, ha="left")
        outs.append(out)
    f = gate(s, "OR", 78, 32, outs, "f", w=5.5, h=8)
    s.wire(f[0], f[1], 92, f[1])
    s.label(93, f[1], "f", size=8, ha="left")
    s.text(50, 3, formula, size=9)
    s.save(path)


def exp_2_4(path):
    """74LS151: f = sum m(1,2,4,7)"""
    minterm_diagram("EXP_2_4 - 74LS151 mux: f = sum m(1,2,4,7)",
                    "I = 10010110 (I7..I0)   S = {x,y,z}   f = m1 + m2 + m4 + m7", [1, 2, 4, 7], path)


def exp_2_5(path):
    """74LS138: f = sum m(0,2,5,7)"""
    minterm_diagram("EXP_2_5 - 74LS138 decoder: f = sum m(0,2,5,7)",
                    "E1 = E2 = 0, E3 = 1, outputs active low   f = m0 + m2 + m5 + m7",
                    [0, 2, 5, 7], path)


JOBS = [
    ("LAB_2/EXP_2_1", "logic_diagram.png", exp_2_1),
    ("LAB_2/EXP_2_2", "logic_diagram.png", exp_2_2),
    ("LAB_2/EXP_2_3", "logic_diagram.png", exp_2_3),
    ("LAB_2/EXP_2_4", "logic_diagram.png", exp_2_4),
    ("LAB_2/EXP_2_5", "logic_diagram.png", exp_2_5),
]


def main():
    for rel, name, func in JOBS:
        out = ROOT / rel / name
        func(out)
        print("wrote %s" % out)


if __name__ == "__main__":
    main()
