#!/usr/bin/env python3
"""Mô phỏng SPICE cho 5 bài Lab 2 (LTspice và ngspice, headless).

    python tools/spice_lab2.py

Kết quả: <project>/<ten>.cir, spice_table_ltspice.txt, spice_table_ngspice.txt,
spice_wave.png
"""
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from spice import simulate

ROOT = Path(__file__).resolve().parent.parent
VCC = 5.0


def pwl_bit(period_ns, tstop=800):
    """Staircase source: the bit toggles every period_ns."""
    pts, t, level = [], 0, 0
    while t < tstop:
        pts.append("%dn %g" % (t, level))
        pts.append("%dn %g" % (t + period_ns - 1, level))
        level = VCC - level
        t += period_ns
    pts.append("%dn %g" % (tstop, level))
    return "PWL(" + " ".join(pts) + ")"


# x is the most significant bit, z the least (same order as the testbench)
SRC = [
    "V_X x 0 %s" % pwl_bit(400),
    "V_Y y 0 %s" % pwl_bit(200),
    "V_Z z 0 %s" % pwl_bit(100),
]


def not_(x):
    return "(V(%s) > 2.5) ? 0 : %g" % (x, VCC)


def and2(a, b):
    return "V(%s)*V(%s) > 12.5 ? %g : 0" % (a, b, VCC)


def and3(a, b, c):
    return "V(%s)+V(%s)+V(%s) > 12.5 ? %g : 0" % (a, b, c, VCC)


def or_(a, b):
    return "V(%s)+V(%s) > 2.5 ? %g : 0" % (a, b, VCC)


def or4(a, b, c, d):
    return "V(%s)+V(%s)+V(%s)+V(%s) > 2.5 ? %g : 0" % (a, b, c, d, VCC)


def nand2(a, b):
    return "V(%s)*V(%s) > 12.5 ? 0 : %g" % (a, b, VCC)


def nor2(a, b):
    return "V(%s)+V(%s) > 2.5 ? 0 : %g" % (a, b, VCC)


def exp_2_1():
    """f = x'yz + (xy)'z + xy"""
    return SRC + [
        "B_NX  nx  0 V = %s" % not_("x"),
        "B_XY  xy  0 V = %s" % and2("x", "y"),
        "B_NXY nxy 0 V = %s" % not_("xy"),
        "B_T1  t1  0 V = %s" % and3("nx", "y", "z"),
        "B_T2  t2  0 V = %s" % and2("nxy", "z"),
        "B_F   f   0 V = %s" % or_("t1", "t2") if False else
        "B_F   f   0 V = V(t1)+V(t2)+V(xy) > 2.5 ? %g : 0" % VCC,
    ]


def exp_2_2():
    """F = (Y&Z) | (~X&~Y) | (~Y&~Z)"""
    return SRC + [
        "B_NX nx 0 V = %s" % not_("x"),
        "B_NY ny 0 V = %s" % not_("y"),
        "B_NZ nz 0 V = %s" % not_("z"),
        "B_A1 a1 0 V = %s" % and2("y", "z"),
        "B_A2 a2 0 V = %s" % and2("nx", "ny"),
        "B_A3 a3 0 V = %s" % and2("ny", "nz"),
        "B_F  F  0 V = V(a1)+V(a2)+V(a3) > 2.5 ? %g : 0" % VCC,
    ]


def exp_2_3():
    """F = NOR(NOR(x, yz), NAND(~y, x)), Fs = x&~y"""
    return SRC + [
        "B_YZ  yz 0 V = %s" % and2("y", "z"),
        "B_A   A  0 V = %s" % nor2("x", "yz"),
        "B_NY  ny 0 V = %s" % not_("y"),
        "B_B   B  0 V = %s" % nand2("ny", "x"),
        "B_F   F  0 V = %s" % nor2("A", "B"),
        "B_FS  Fs 0 V = %s" % and2("x", "ny"),
    ]


def mux_74ls151():
    """74LS151: Y = Sigma(1,2,4,7), Ybar = ~Y"""
    return SRC + [
        "B_NX nx 0 V = %s" % not_("x"),
        "B_NY ny 0 V = %s" % not_("y"),
        "B_NZ nz 0 V = %s" % not_("z"),
        "B_M1 m1 0 V = %s" % and3("nx", "ny", "z"),
        "B_M2 m2 0 V = %s" % and3("nx", "y", "nz"),
        "B_M4 m4 0 V = %s" % and3("x", "ny", "nz"),
        "B_M7 m7 0 V = %s" % and3("x", "y", "z"),
        "B_F  f  0 V = %s" % or4("m1", "m2", "m4", "m7"),
        "B_FB fb 0 V = (V(f) > 2.5) ? 0 : %g" % VCC,
    ]


def dec_74ls138():
    """74LS138: f = Sigma(0,2,5,7)"""
    return SRC + [
        "B_NX nx 0 V = %s" % not_("x"),
        "B_NY ny 0 V = %s" % not_("y"),
        "B_NZ nz 0 V = %s" % not_("z"),
        "B_M0 m0 0 V = %s" % and3("nx", "ny", "nz"),
        "B_M2 m2 0 V = %s" % and3("nx", "y", "nz"),
        "B_M5 m5 0 V = %s" % and3("x", "ny", "z"),
        "B_M7 m7 0 V = %s" % and3("x", "y", "z"),
        "B_F  f  0 V = %s" % or4("m0", "m2", "m5", "m7"),
    ]


def netlist(title, body, tstop=800):
    lines = ["* %s" % title, "* gate level behavioural model, runs in LTspice and ngspice"]
    lines += body
    lines.append(".tran 2n %dn" % tstop)
    lines.append(".end")
    return "\n".join(lines) + "\n"


EXPECTED = {
    "exp_2_1": ["0", "1", "0", "1", "0", "1", "1", "1"],
    "exp_2_2": ["1", "1", "0", "1", "1", "0", "0", "1"],
    "exp_2_3": ["0", "0", "0", "0", "1", "1", "0", "0"],
    "mux_74ls151": ["0", "1", "1", "0", "1", "0", "0", "1"],
    "dec_74ls138": ["1", "0", "1", "0", "0", "1", "0", "1"],
}

SIG = [("x", "V(x)"), ("y", "V(y)"), ("z", "V(z)")]

JOBS = [
    ("LAB_2/EXP_2_1", "exp_2_1.cir", exp_2_1, ["V(f)"], ["f"],
     "EXP_2_1 - f = x'yz + (xy)'z + xy"),
    ("LAB_2/EXP_2_2", "exp_2_2.cir", exp_2_2, ["V(F)"], ["F"],
     "EXP_2_2 - F = sum m(0,1,3,4,7)"),
    ("LAB_2/EXP_2_3", "exp_2_3.cir", exp_2_3, ["V(F)", "V(Fs)"], ["F", "Fs"],
     "EXP_2_3 - F = NOR(NOR(x,yz), NAND(~y,x))"),
    ("LAB_2/EXP_2_4", "mux_74ls151.cir", mux_74ls151, ["V(f)", "V(fb)"], ["f", "fb"],
     "EXP_2_4 - 74LS151: f = sum m(1,2,4,7)"),
    ("LAB_2/EXP_2_5", "dec_74ls138.cir", dec_74ls138, ["V(f)"], ["f"],
     "EXP_2_5 - 74LS138: f = sum m(0,2,5,7)"),
]


def main():
    for rel, net_name, builder, outs, out_names, title in JOBS:
        exp = EXPECTED[net_name.split(".")[0]]
        expected = []
        for k in range(8):
            x, y, z = (k >> 2) & 1, (k >> 1) & 1, k & 1
            row = [str(x), str(y), str(z)]
            for name in out_names:
                if name in ("fb", "Ybar"):
                    row.append("0" if exp[k] == "1" else "1")
                elif name == "Fs":
                    row.append(exp[k])           # Fs = x&~y, same as F here
                else:
                    row.append(exp[k])
            expected.append(row)
        sigs = SIG + list(zip(out_names, outs))
        simulate(ROOT / rel, net_name, netlist(title, builder()), ["V(x)", "V(y)", "V(z)"],
                 outs, sigs, title, windows=8, expected=expected)


if __name__ == "__main__":
    main()
