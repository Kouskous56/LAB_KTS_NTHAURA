#!/usr/bin/env python3
"""Mô phỏng SPICE cho các mạch tuần tự của Lab 3 (LTspice và ngspice, headless).

    python tools/spice_lab3_seq.py

Flip-flop 74LS74 được mô hình bằng một công tắc switch + tụ giữ (mẫu lấy mẫu theo
xung dây dương), nên cùng một netlist chạy được ở cả LTspice lẫn ngspice:

    - EXP_3 : D flip-flop 74LS74, đúng bảng chức năng Table 3.5
    - EXP_4 : bộ đếm 0 đến 7 (ripple, 3 tầng 74LS74)
    - EXP_5 : máy trạng thái Figure 3.4 (2 tầng 74LS74 + 74LS08/74LS32)
"""
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from spice import simulate

ROOT = Path(__file__).resolve().parent.parent
VCC = 5.0

# ---------------------------------------------------------------------------
# Mô hình flip-flop: lấy mẫu D trong xung hẹp ở cạnh dây dương, giữ bằng tụ.
# PRE / CLR tích cực mức thấp, PRE ưu tiên khi cả hai cùng tác động (nonstable).
DFF_SUBCKT = """
.model swl SW(Ron=1 Roff=1e12 Vt=2.5 Vh=0.1)
.subckt dff d clk pre clr q qn
* xung hep rong o canh day duong cua clock
RCL  clk  clk_d 1
CCL  clk_d 0 1n
B_EDGE edge 0 V = ((V(clk) > 2.5) * (V(clk_d) <= 2.5)) ? 5 : 0
* lay mau D trong xung hep, giu bang tu
S1 qs d edge 0 swl
C1 qs 0 5p IC=0
R1 qs 0 1e12
* preset / clear bat dong, muc thap, PRE uu tien khi ca hai cung tac dong
B_PRESW presw 0 V = (5 - V(pre)) * V(clr) / 5
B_CLRSW clrsw 0 V = (5 - V(clr)) * V(pre) / 5
S2 qs v5 presw 0 swl
S3 qs 0 clrsw 0 swl
V5 v5 0 5
B_Q  q  0 V = (V(pre) < 2.5) ? 5 : ((V(clr) < 2.5) ? 0 : V(qs))
B_QN qn 0 V = ((V(pre) < 2.5) * (V(clr) < 2.5)) ? 5 : ((V(pre) < 2.5) ? 0 : ((V(clr) < 2.5) ? 5 : (V(qs) > 2.5 ? 0 : 5)))
.ends dff
"""


def pwl(points):
    """points: list of (time_ns, level) -> PWL string with 2 ns edges."""
    parts = []
    for i, (t, v) in enumerate(points):
        if i:
            parts.append("%dn %g" % (t - 1, points[i - 1][1]))
        parts.append("%dn %g" % (t, v))
    return "PWL(" + " ".join(parts) + ")"


def level_at(points, t):
    """Logic level (0/1) of a PWL point list at time t."""
    val = points[0][1]
    for pt, v in points:
        if pt <= t:
            val = v
        else:
            break
    return "1" if val > 2.5 else "0"


def netlist(title, body, tstop):
    lines = ["* %s" % title, "* behavioural model, runs in LTspice and ngspice"]
    lines.append(DFF_SUBCKT.strip())
    lines += body
    lines.append(".tran 0.2n %dn" % tstop)
    lines.append(".end")
    return "\n".join(lines) + "\n"


# ---------------------------------------------------------------------------
# EXP_3: D flip-flop 74LS74 (Table 3.5)
def exp_3():
    pre = [(0, 0), (10, 5), (20, 0), (30, 5), (100, 5)]
    clr = [(0, 0), (10, 0), (20, 5), (30, 5), (100, 5)]
    dat = [(0, 0), (40, 5), (50, 0), (60, 5), (70, 0), (80, 5), (90, 0), (100, 5), (105, 5)]
    clk = [(0, 0), (50, 5), (70, 0), (90, 5), (100, 0), (105, 5), (120, 5)]
    body = [
        "V_PRE pre 0 %s" % pwl(pre),
        "V_CLR clr 0 %s" % pwl(clr),
        "V_D   d   0 %s" % pwl(dat),
        "V_CLK clk 0 %s" % pwl(clk),
        "X1 d clk pre clr q qn dff",
    ]
    # thời điểm lấy mẫu và giá trị mong đợi (Table 3.5)
    samples = [5, 15, 25, 35, 45, 55, 65, 75, 85, 95, 110]
    outputs = [
        ["1", "1"],   # PRE=0 CLR=0 -> nonstable
        ["0", "1"],   # CLR = 0
        ["1", "0"],   # PRE = 0
        ["1", "0"],   # D=0 CLK=0, giữ nguyên
        ["1", "0"],   # D=1 CLK=0, giữ nguyên
        ["0", "1"],   # cạnh dây dương, D=0
        ["0", "1"],   # không có cạnh mới
        ["0", "1"],   # cạnh âm, không đổi
        ["0", "1"],   # D=1, không có cạnh
        ["0", "1"],   # cạnh dây dương, D=0
        ["1", "0"],   # cạnh dây dương, D=1
    ]
    rows = []
    for t, out in zip(samples, outputs):
        row = [level_at(pre, t), level_at(clr, t), level_at(dat, t), level_at(clk, t)]
        rows.append(row + out)
    return body, samples, rows, 130


# ---------------------------------------------------------------------------
# EXP_4: bộ đếm 0 đến 7 (ripple, 3 tầng 74LS74)
def exp_4():
    period = 20
    ticks = [20 + period * k for k in range(16)]
    clk = [(0, 0)]
    for t in ticks:
        clk.append((t, 5))
        clk.append((t + 10, 0))
    # A, B va clr theo thu tu thi nghiem cua manual
    a_pts = [(0, 0), (90, 5)]
    b_pts = [(0, 5), (90, 0), (155, 5)]
    clr_pts = [(0, 5), (2, 0), (8, 5), (92, 5), (94, 0), (98, 5),
               (164, 5), (166, 0), (170, 5)]
    body = [
        "V_CLK clk 0 %s" % pwl(clk),
        "V_A   a   0 %s" % pwl(a_pts),
        "V_B   b   0 %s" % pwl(b_pts),
        "V_CLR clr 0 %s" % pwl(clr_pts),
        # ban sao tre thoa cho vong phan hoi D = ~Q (tranh vo hinh hoc)
        "RDL0 q0 q0d 5",
        "CDL0 q0d 0 1n",
        "RDL1 q1 q1d 5",
        "CDL1 q1d 0 1n",
        "RDL2 q2 q2d 5",
        "CDL2 q2d 0 1n",
        # D cua tung tang: giu nguyen hoac doi pha
        "B_D0 d0 0 V = (V(a) > 2.5) ? ((V(q0d) > 2.5) ? 0 : 5) : V(q0d)",
        "B_D1 d1 0 V = (V(b) > 2.5) ? ((V(q1d) > 2.5) ? 0 : 5) : V(q1d)",
        "B_D2 d2 0 V = (V(q2d) > 2.5) ? 0 : 5",
        "X0 d0 clk pre0 clr q0 q0n dff",
        "X1 d1 q0n pre0 clr q1 q1n dff",
        "X2 d2 q1n pre0 clr q2 q2n dff",
        "R_DUMMY q2n 0 1e12",
        "V_PRE0 pre0 0 5",
    ]
    # cac moc thoi gian lay mau va gia tri mong doi
    plan = ([(8, 0)] + [(t + 8, 0) for t in ticks[:4]] +          # A=0, B=1: dong bang
            [(108, 1), (128, 0), (148, 1)] +                     # A=1, B=0: chi LSB doi
            [(t + 8, (k + 1) % 8) for k, t in enumerate(ticks[8:16])])  # A=B=1: dem 0..7
    samples, expected = [], []
    for t, value in plan:
        samples.append(t)
        expected.append([level_at(a_pts, t), level_at(b_pts, t),
                         str((value >> 2) & 1), str((value >> 1) & 1), str(value & 1)])
    return body, samples, expected, 350



def fsm_body():
    """Máy trạng thái Figure 3.4 (dùng chung cho LAB_3 và PRELAB_3)."""
    period = 20
    ticks = [20 + period * k for k in range(7)]
    clk = [(0, 0)]
    for t in ticks:
        clk.append((t, 5))
        clk.append((t + 10, 0))
    seq = [0, 1, 1, 0, 0, 0, 1]
    x_pts = [(0, 0)]
    for t, v in zip(ticks, seq):
        x_pts.append((t - 4, 5 if v else 0))
    clr_pts = [(0, 5), (2, 0), (6, 5)]
    body = [
        "V_CLK clk 0 %s" % pwl(clk),
        "V_X   x   0 %s" % pwl(x_pts),
        "V_CLR clr 0 %s" % pwl(clr_pts),
        # ban sao tre thoa cho vong phan hoi cua logic trang thai toi
        "RDL0 q0 q0d 5",
        "CDL0 q0d 0 1n",
        "RDL1 q1 q1d 5",
        "CDL1 q1d 0 1n",
        # S1+ = X.S0 ; S0+ = X.(~S1 + ~S0)
        "B_S1P s1p 0 V = (V(x)*V(q0d) > 12.5) ? 5 : 0",
        "B_S0P s0p 0 V = (V(x)*(5 - V(q1d))*(5 - V(q0d)) > 12.5) ? 5 : 0",
        "X1 s1p clk pre0 clr q1 q1n dff",
        "X0 s0p clk pre0 clr q0 q0n dff",
        "V_PRE0 pre0 0 5",
    ]
    # chuoi trang thai: A,A,B,D,A,A,A,B  (00,00,01,11,00,00,00,01)
    states = [0, 0, 1, 3, 0, 0, 0, 1]
    samples = [5] + [t + 8 for t in ticks]
    expected = [["0", "0", "0"]]                 # sau reset -> A
    for k, t in enumerate(ticks):
        st = states[k + 1]
        expected.append([str(seq[k]), str((st >> 1) & 1), str(st & 1)])
    return body, samples, expected, 180


def exp_5():
    return fsm_body()


def exp_3_4():
    """PRELAB_3: cung may trang thai Figure 3.4"""
    return fsm_body()


def exp_3_3():
    """PRELAB_3: bo dem 0 den 7 (3 tang 74LS74, khong co Enable)"""
    period = 20
    ticks = [20 + period * k for k in range(9)]
    clk = [(0, 0)]
    for t in ticks:
        clk.append((t, 5))
        clk.append((t + 10, 0))
    clr_pts = [(0, 5), (2, 0), (8, 5)]
    body = [
        "V_CLK clk 0 %s" % pwl(clk),
        "V_CLR clr 0 %s" % pwl(clr_pts),
        # ban sao tre thoa cho vong phan hoi D = ~Q
        "RDL0 q0 q0d 5",
        "CDL0 q0d 0 1n",
        "RDL1 q1 q1d 5",
        "CDL1 q1d 0 1n",
        "RDL2 q2 q2d 5",
        "CDL2 q2d 0 1n",
        "B_D0 d0 0 V = (V(q0d) > 2.5) ? 0 : 5",
        "B_D1 d1 0 V = (V(q1d) > 2.5) ? 0 : 5",
        "B_D2 d2 0 V = (V(q2d) > 2.5) ? 0 : 5",
        "X0 d0 clk pre0 clr q0 q0n dff",
        "X1 d1 q0n pre0 clr q1 q1n dff",
        "X2 d2 q1n pre0 clr q2 q2n dff",
        "R_DUMMY q2n 0 1e12",
        "V_PRE0 pre0 0 5",
    ]
    samples = [8] + [t + 8 for t in ticks]
    expected = [["0", "0", "0"]]                 # sau reset -> 000
    for k, t in enumerate(ticks):
        value = (k + 1) % 8
        expected.append([str((value >> 2) & 1), str((value >> 1) & 1), str(value & 1)])
    return body, samples, expected, 220


JOBS = [
    ("LAB_3/EXP_3_dff_74ls74", "dff74ls74.cir", exp_3,
     "EXP_3 - D flip-flop 74LS74 (Table 3.5)"),
    ("LAB_3/EXP_4_counter_0_7", "counter_0_7.cir", exp_4,
     "EXP_4 - 0 to 7 up counter (74LS74)"),
    ("LAB_3/EXP_5_state_machine", "fsm_fig34.cir", exp_5,
     "EXP_5 - state machine (Figure 3.4)"),
    ("PRELAB_3/EXP_3_3", "counter_0_7.cir", exp_3_3,
     "PRELAB_3 EXP_3_3 - 0 to 7 up counter (74LS74)"),
    ("PRELAB_3/EXP_3_4", "fsm_fig34.cir", exp_3_4,
     "PRELAB_3 EXP_3_4 - state machine (Figure 3.4)"),
]

SIGNALS = {
    "LAB_3/EXP_3_dff_74ls74": [("PRE", "V(pre)"), ("CLR", "V(clr)"), ("D", "V(d)"),
                                ("CLK", "V(clk)"), ("Q", "V(q)"), ("Q'", "V(qn)")],
    "LAB_3/EXP_4_counter_0_7": [("clk", "V(clk)"), ("A", "V(a)"), ("B", "V(b)"),
                                ("clr", "V(clr)"), ("Q2", "V(q2)"), ("Q1", "V(q1)"),
                                ("Q0", "V(q0)")],
    "LAB_3/EXP_5_state_machine": [("clk", "V(clk)"), ("X", "V(x)"), ("clr", "V(clr)"),
                                  ("S1", "V(q1)"), ("S0", "V(q0)")],
    "PRELAB_3/EXP_3_3": [("clk", "V(clk)"), ("clr", "V(clr)"), ("Q2", "V(q2)"),
                          ("Q1", "V(q1)"), ("Q0", "V(q0)")],
    "PRELAB_3/EXP_3_4": [("clk", "V(clk)"), ("X", "V(x)"), ("clr", "V(clr)"),
                         ("S1", "V(q1)"), ("S0", "V(q0)")],
}

INPUTS = {
    "LAB_3/EXP_3_dff_74ls74": ["V(pre)", "V(clr)", "V(d)", "V(clk)"],
    "LAB_3/EXP_4_counter_0_7": ["V(a)", "V(b)"],
    "LAB_3/EXP_5_state_machine": ["V(x)"],
    "PRELAB_3/EXP_3_3": [],
    "PRELAB_3/EXP_3_4": ["V(x)"],
}

OUTPUTS = {
    "LAB_3/EXP_3_dff_74ls74": ["V(q)", "V(qn)"],
    "LAB_3/EXP_4_counter_0_7": ["V(q2)", "V(q1)", "V(q0)"],
    "LAB_3/EXP_5_state_machine": ["V(q1)", "V(q0)"],
    "PRELAB_3/EXP_3_3": ["V(q2)", "V(q1)", "V(q0)"],
    "PRELAB_3/EXP_3_4": ["V(q1)", "V(q0)"],
}


def main():
    for rel, net_name, builder, title in JOBS:
        body, samples, expected, tstop = builder()
        simulate(ROOT / rel, net_name, netlist(title, body, tstop),
                 INPUTS[rel], OUTPUTS[rel], SIGNALS[rel], title,
                 expected=expected, sample_times=samples)


if __name__ == "__main__":
    main()
