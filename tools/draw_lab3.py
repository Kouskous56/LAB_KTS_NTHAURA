#!/usr/bin/env python3
"""Draw the logic diagram and the application circuit of every Lab 3 circuit.

    python tools/draw_lab3.py
"""
from pathlib import Path
import sys

sys.path.insert(0, str(Path(__file__).resolve().parent))
from schematic import Sheet

ROOT = Path(__file__).resolve().parent.parent


def full_adder_logic(path):
    s = Sheet(11, 5.6, "Full Adder - logic diagram")
    s.label(4, 42, "A")
    s.label(4, 30, "B")
    s.label(4, 14, "Ci")
    # T1 = A xor B
    s.gate("XOR", 18, 36, label="T1")
    s.wire(6, 42, 12, 42, mode="vh")
    s.wire(12, 42, 12, 38)
    s.wire(12, 38, 18, 38)
    s.wire(6, 30, 12, 30, mode="vh")
    s.wire(12, 30, 12, 34)
    s.wire(12, 34, 18, 34)
    # S = T1 xor Ci
    s.gate("XOR", 46, 30, label="S")
    s.wire(26, 36, 32, 36, mode="vh")
    s.wire(32, 36, 32, 32)
    s.wire(32, 32, 46, 32)
    s.wire(6, 14, 46, 26, mode="hv")
    # C1 = A and B
    s.gate("AND", 18, 52, label="C1")
    s.wire(6, 42, 8, 42, mode="vh")
    s.wire(8, 42, 8, 54)
    s.wire(8, 54, 18, 54)
    s.wire(6, 30, 14, 30, mode="vh")
    s.wire(14, 30, 14, 50)
    s.wire(14, 50, 18, 50)
    # C2 = T1 and Ci
    s.gate("AND", 46, 52, label="C2")
    s.wire(26, 36, 40, 36, mode="vh")
    s.wire(40, 36, 40, 54)
    s.wire(40, 54, 46, 54)
    s.wire(6, 14, 42, 14, mode="vh")
    s.wire(42, 14, 42, 50)
    s.wire(42, 50, 46, 50)
    # Co = C1 or C2
    s.gate("OR", 70, 52, label="Co")
    s.wire(26, 52, 70, 54, mode="hv")
    s.wire(54, 52, 70, 50, mode="hv")
    # outputs
    s.wire(54, 30, 90, 30)
    s.label(91, 30, "S")
    s.wire(78, 52, 90, 52)
    s.label(91, 52, "Co")
    s.text(50, 8, "S = A ^ B ^ Ci        Co = A·B + A·Ci + B·Ci", size=9.5)
    s.save(path)


def full_adder_app(path):
    s = Sheet(11, 5.6, "Full Adder - application circuit (74LS86, 74LS08, 74LS32)")
    # inputs
    s.dot(6, 50); s.label(3, 50, "A", size=8, ha="right")
    s.dot(6, 42); s.label(3, 42, "B", size=8, ha="right")
    s.dot(6, 34); s.label(3, 34, "Ci", size=8, ha="right")
    # 74LS86
    s.box(20, 30, 20, 26, "74LS86", ["1/4: T1 = A xor B", "2/4: S = T1 xor Ci"])
    s.wire(6, 50, 20, 50)
    s.wire(6, 42, 12, 42, mode="vh")
    s.wire(12, 42, 12, 46)
    s.wire(12, 46, 20, 46)
    s.wire(6, 34, 14, 34, mode="vh")
    s.wire(14, 34, 14, 38)
    s.wire(14, 38, 20, 38)
    s.label(20.5, 50, "A", size=7, ha="left")
    s.label(20.5, 46, "B", size=7, ha="left")
    s.label(20.5, 38, "Ci", size=7, ha="left")
    s.dot(40, 48); s.label(40.5, 48, "T1", size=7, ha="left")
    s.dot(40, 52); s.label(40.5, 52, "S", size=7, ha="left")
    # 74LS08
    s.box(54, 30, 20, 26, "74LS08", ["1/4: C1 = A·B", "2/4: C2 = T1·Ci"])
    s.wire(40, 48, 44, 48, mode="vh")
    s.wire(44, 48, 44, 44)
    s.wire(44, 44, 54, 44)
    s.label(54.5, 44, "T1", size=7, ha="left")
    s.wire(6, 50, 14, 50, mode="vh")
    s.wire(14, 50, 14, 58)
    s.wire(14, 58, 48, 58)
    s.wire(48, 58, 48, 40)
    s.wire(48, 40, 54, 40)
    s.label(54.5, 40, "A", size=7, ha="left")
    s.wire(6, 42, 12, 42, mode="vh")
    s.wire(12, 42, 12, 24)
    s.wire(12, 24, 50, 24)
    s.wire(50, 24, 50, 36)
    s.wire(50, 36, 54, 36)
    s.label(54.5, 36, "B", size=7, ha="left")
    s.wire(6, 34, 14, 34, mode="vh")
    s.wire(14, 34, 14, 20)
    s.wire(14, 20, 52, 20)
    s.wire(52, 20, 52, 32)
    s.wire(52, 32, 54, 32)
    s.label(54.5, 32, "Ci", size=7, ha="left")
    s.dot(74, 48); s.label(74.5, 48, "C1", size=7, ha="left")
    s.dot(74, 36); s.label(74.5, 36, "C2", size=7, ha="left")
    # 74LS32
    s.box(54, 4, 20, 22, "74LS32", ["1/4: Co = C1 + C2"])
    s.wire(74, 48, 80, 48, mode="vh")
    s.wire(80, 48, 80, 18)
    s.wire(80, 18, 74, 18)
    s.label(74.5, 18, "C1", size=7, ha="left")
    s.wire(74, 36, 82, 36, mode="vh")
    s.wire(82, 36, 82, 12)
    s.wire(82, 12, 74, 12)
    s.label(74.5, 12, "C2", size=7, ha="left")
    # outputs
    s.wire(40, 52, 90, 52)
    s.dot(92, 52); s.label(94, 52, "S", size=8, ha="left")
    s.wire(74, 15, 90, 15)
    s.dot(92, 15); s.label(94, 15, "Co", size=8, ha="left")
    s.text(50, 0, "IC list: 74LS86 (XOR), 74LS08 (AND), 74LS32 (OR)     -     VCC = +5V, GND = 0V", size=8.5)
    s.save(path)


def addsub_logic(path):
    s = Sheet(11, 4.6, "4-bit parallel adder (Figure 3.1) - ripple carry")
    y = 40
    for i in range(4):
        x = 8 + i * 22
        s.box(x, y - 10, 17, 20, "FULL ADDER",
              [f"A[{i}] , B[{i}]", f"Ci -> Co", f"S[{i}]"])
    # carry chain along the top
    s.wire(4, y + 13, 4, y + 13)
    s.label(3.6, y + 13, "Cin", size=8, ha="right")
    for i in range(4):
        x = 8 + i * 22
        s.wire(x + 8.5, y + 10, x + 8.5, y + 13)
        if i < 3:
            s.wire(x + 8.5, y + 13, x + 22 + 8.5, y + 13)
            s.label(x + 15.5, y + 14, f"Co{i} -> Ci{i+1}", size=7)
    s.wire(8 + 3 * 22 + 8.5, y + 13, 96, y + 13)
    s.label(96.5, y + 13, "Cout", size=8, ha="left")
    s.text(50, 12, "carry chain:  Cin -> Ci(FA1) -> Co(FA1) -> Ci(FA2) -> ... -> Cout", size=9)
    s.text(50, 6, "Sel = 0 : S = A + B        Sel = 1 : S = A - B   (B inverted, Cin = 1)", size=9)
    s.save(path)


def addsub_app(path):
    s = Sheet(11, 5.0, "4-bit Adder/Subtractor - application circuit (74LS283 + 74LS86)")
    s.switch(8, 40, "A[3:0]")
    s.switch(8, 28, "B[3:0]")
    s.switch(8, 16, "Sel")
    s.box(26, 28, 20, 26, "74LS86", ["4 x XOR", "B' = B xor Sel"])
    s.wire(10, 28, 26, 34)
    s.wire(10, 16, 26, 44)
    s.box(56, 26, 22, 28, "74LS283", ["A1..A4", "B1..B4", "C0 = Sel", "S1..S4", "C4"])
    s.wire(46, 40, 56, 46)
    s.wire(46, 34, 56, 42)
    s.wire(10, 40, 56, 50)
    s.wire(78, 46, 86, 46)
    s.led(86, 49, "S[3:0]")
    s.wire(78, 30, 86, 30)
    s.led(86, 33, "Cout")
    s.text(50, 10, "74LS283 pins: 1=S2 2=B2 3=A2 4=S1 5=A1 6=B1 7=C0 8=GND 9=C4 10=S4 11=B4 12=A4 13=S3 14=A3 15=B3 16=VCC", size=7.5)
    s.save(path)


def counter_logic(path):
    s = Sheet(11, 4.8, "0 to 7 up counter - logic diagram (asynchronous / ripple)")
    for i in range(3):
        x = 14 + i * 26
        s.dff(x, 26, w=10, h=12, name=f"FF{i}", inputs=("D", "CLK"), outputs=("Q", "Q'"))
        # D = ~Q feedback
        s.wire(x + 10, 32.5, x + 13, 32.5)
        s.wire(x + 13, 32.5, x + 13, 14)
        s.wire(x + 13, 14, x, 14)
        s.label(x + 13.4, 14, f"D{i} = ~Q{i}", size=7, ha="left")
    # clock chain Q' -> CLK of the next stage
    s.wire(24, 26, 24, 18)
    s.wire(24, 18, 40, 18)
    s.wire(40, 18, 40, 26)
    s.wire(50, 26, 50, 12)
    s.wire(50, 12, 66, 12)
    s.wire(66, 12, 66, 26)
    s.switch(4, 44, "CLK")
    s.wire(6, 40, 14, 36)
    s.text(50, 6, "D = ~Q in every stage,  CLK of stage n+1 = Q' of stage n   ->   count 0,1,2,...7,0,...", size=8.5)
    s.save(path)


def counter_app(path):
    s = Sheet(11, 5.0, "0 to 7 up counter - application circuit (2 x 74LS74)")
    s.switch(6, 44, "CLK")
    s.box(22, 34, 20, 22, "74LS74 (1/2)", ["FF0: D0 = ~Q0", "Q0' -> CLK of FF1"])
    s.wire(8, 44, 22, 48)
    s.box(50, 34, 20, 22, "74LS74 (2/2)", ["FF1: D1 = ~Q1", "Q1' -> CLK of FF2"])
    s.wire(42, 40, 50, 48)
    s.box(50, 8, 20, 22, "74LS74 (2/2)", ["FF2: D2 = ~Q2", "Q2 = MSB"])
    s.wire(42, 36, 46, 36)
    s.wire(46, 36, 46, 16)
    s.wire(46, 16, 50, 16)
    s.wire(70, 34, 70, 30)
    s.wire(70, 30, 62, 30)
    s.led(62, 27, "Q2")
    s.wire(62, 12, 56, 12)
    s.led(56, 9, "Q1")
    s.wire(42, 32, 40, 32)
    s.wire(40, 32, 40, 28)
    s.wire(40, 28, 50, 28)
    s.led(50, 25, "Q0")
    s.text(50, 4, "74LS74 pins: 1=1CLR 2=1D 3=1CLK 4=1PRE 5=1Q 6=1Q' 7=GND 8=2Q' 9=2Q 10=2PRE 11=2CLK 12=2D 13=2CLR 14=VCC", size=7.5)
    s.save(path)


def fsm_state(path):
    s = Sheet(9, 5.6, "State diagram (Figure 3.4 / Figure 3.6)")
    s.state(25, 46, name="A", code="00")
    s.state(68, 46, name="B", code="01")
    s.state(68, 18, name="C", code="10")
    s.state(25, 18, name="D", code="11")
    s.arrow(29, 46, 64, 46, "X = 1")
    s.arrow(64, 42, 29, 42, "X = 0", side="below")
    s.arrow(64, 26, 29, 26, "X = 0", side="below")
    s.arrow(29, 26, 64, 26, "X = 1")
    s.arrow(21, 42, 21, 24, "X = 0")
    s.arrow(72, 24, 72, 42, "X = 1")
    s.arrow(60, 34, 34, 38, "X = 0", rad=0.28, side="below")
    s.arrow(34, 32, 60, 28, "X = 1", rad=0.28, side="above")
    s.text(50, 6, "A: X=0->A, X=1->B    B: X=0->A, X=1->D    C: X=0->A, X=1->B    D: X=0->A, X=1->C", size=8)
    s.save(path)


def fsm_datapath(path):
    s = Sheet(11, 5.0, "State machine - logic diagram (74LS74 + 74LS08 + 74LS32)")
    s.switch(6, 44, "X")
    s.switch(6, 32, "CLK")
    s.switch(6, 20, "CLR")
    s.box(24, 40, 22, 18, "74LS08", ["S1+ = X·S0", "S0+ = X·(S1' + S0')"])
    s.box(54, 40, 20, 18, "74LS32", ["S1' + S0'"])
    s.box(54, 12, 24, 20, "74LS74", ["FF0: S0", "FF1: S1", "Q' outputs used"])
    s.wire(8, 44, 24, 52)
    s.wire(46, 52, 54, 52)
    s.wire(74, 40, 74, 32)
    s.wire(74, 32, 66, 32)
    s.wire(66, 32, 66, 22)
    s.wire(8, 32, 54, 24)
    s.wire(8, 20, 54, 16)
    s.wire(46, 44, 34, 44)
    s.wire(34, 44, 34, 36)
    s.wire(34, 36, 54, 30)
    s.wire(78, 22, 90, 22)
    s.led(90, 25, "S1 S0")
    s.text(50, 6, "async CLR (active low) resets the machine to state A = 00", size=9)
    s.save(path)


JOBS = {
    "PRELAB_3/EXP_3_1": [("logic_diagram.png", full_adder_logic), ("application_circuit.png", full_adder_app)],
    "PRELAB_3/EXP_3_2": [("logic_diagram.png", addsub_logic), ("application_circuit.png", addsub_app)],
    "PRELAB_3/EXP_3_3": [("logic_diagram.png", counter_logic), ("application_circuit.png", counter_app)],
    "PRELAB_3/EXP_3_4": [("logic_diagram.png", fsm_datapath), ("state_diagram.png", fsm_state)],
    "LAB_3/EXP_1_full_adder": [("logic_diagram.png", full_adder_logic), ("application_circuit.png", full_adder_app)],
    "LAB_3/EXP_2_addsub_4bit": [("logic_diagram.png", addsub_logic), ("application_circuit.png", addsub_app)],
    "LAB_3/EXP_3_dff_74ls74": [("logic_diagram.png", fsm_datapath)],
    "LAB_3/EXP_4_counter_0_7": [("logic_diagram.png", counter_logic), ("application_circuit.png", counter_app)],
    "LAB_3/EXP_5_state_machine": [("logic_diagram.png", fsm_datapath), ("state_diagram.png", fsm_state)],
}


def main():
    for rel, items in JOBS.items():
        d = ROOT / rel
        for name, fn in items:
            fn(d / name)


if __name__ == "__main__":
    main()
