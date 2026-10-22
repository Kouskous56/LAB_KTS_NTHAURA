#!/usr/bin/env python3
"""Generate Logisim .circ files for the Lab 3 circuits and run them headless.

    python tools/logisim_lab3.py

Logisim is driven from the terminal:
    java -jar logisim-evolution.jar -tty table --toplevel-circuit main file.circ
The printed truth table is saved next to the circuit as logisim_table.txt.

Every net is made with a Logisim tunnel, so no wire ever crosses another wire
(Logisim joins crossing wires, which would short the circuit).
"""
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from logisim import Circ, run_tty

ROOT = Path(__file__).resolve().parent.parent
SIZE = 50        # medium gate


def full_adder(c):
    """Full adder from 2 XOR, 2 AND, 1 OR (logic diagram of the lab manual)."""
    def tun(x, y, label, facing):
        c.tunnel(x, y, label, facing)

    def gate(c, x, y, kind, ins, out_label):
        """Place a gate and connect its inputs/outputs with tunnels."""
        c.gate(x, y, kind, size=SIZE)
        for (px, py), net in zip(c.gate_inputs(x, y, kind, SIZE), ins):
            tun(px, py, net, "east")
        c.wire(x, y, x + 40, y)
        tun(x + 40, y, out_label, "west")

    # input pins -> tunnel
    for y, name in ((80, "A"), (120, "B"), (160, "Ci")):
        c.pin(100, y, name)
        c.wire(100, y, 140, y)
        tun(140, y, name, "west")

    # T1 = A xor B
    gate(c, 250, 100, "XOR", ["A", "B"], "T1")
    # S = T1 xor Ci
    gate(c, 450, 100, "XOR", ["T1", "Ci"], "S")
    # C1 = A and B
    gate(c, 250, 300, "AND", ["A", "B"], "C1")
    # C2 = T1 and Ci
    gate(c, 650, 300, "AND", ["T1", "Ci"], "C2")
    # Co = C1 or C2
    gate(c, 850, 300, "OR", ["C1", "C2"], "Co")

    # output pins
    c.wire(700, 100, 740, 100)
    tun(700, 100, "S", "east")
    c.pin(740, 100, "S", output=True, facing="west")
    c.wire(700, 300, 740, 300)
    tun(700, 300, "Co", "east")
    c.pin(740, 300, "Co", output=True, facing="west")


def fa_block(c, ox, oy, ain, bin_, cin, sout, cout):
    """One full adder built from 2 XOR, 2 AND, 1 OR, connected with tunnels."""
    def tun(x, y, label, facing="east"):
        c.tunnel(x, y, label, facing)

    # T1 = ain xor bin_
    c.gate(ox, oy, "XOR", size=SIZE)
    tun(ox - 60, oy - 20, ain)
    tun(ox - 60, oy + 20, bin_)
    c.wire(ox, oy, ox + 40, oy)
    tun(ox + 40, oy, sout + "_t", "west")

    # S = T1 xor cin
    c.gate(ox + 200, oy, "XOR", size=SIZE)
    tun(ox + 140, oy - 20, sout + "_t")
    tun(ox + 140, oy + 20, cin)
    c.wire(ox + 200, oy, ox + 240, oy)
    tun(ox + 240, oy, sout, "west")

    # x = ain and bin_
    c.gate(ox, oy + 200, "AND", size=SIZE)
    tun(ox - 50, oy + 180, ain)
    tun(ox - 50, oy + 220, bin_)
    c.wire(ox, oy + 200, ox + 40, oy + 200)
    tun(ox + 40, oy + 200, sout + "_x", "west")

    # y = T1 and cin
    c.gate(ox + 200, oy + 200, "AND", size=SIZE)
    tun(ox + 150, oy + 180, sout + "_t")
    tun(ox + 150, oy + 220, cin)
    c.wire(ox + 200, oy + 200, ox + 240, oy + 200)
    tun(ox + 240, oy + 200, sout + "_y", "west")

    # cout = x + y
    c.gate(ox + 400, oy + 200, "OR", size=SIZE)
    tun(ox + 350, oy + 180, sout + "_x")
    tun(ox + 350, oy + 220, sout + "_y")
    c.wire(ox + 400, oy + 200, ox + 440, oy + 200)
    tun(ox + 440, oy + 200, cout, "west")


def adder4(c):
    """4 bit ripple adder (Figure 3.1): four full adders in series."""
    for k, name in enumerate(["A0", "A1", "A2", "A3", "B0", "B1", "B2", "B3", "Ci"]):
        y = 60 + 40 * k
        c.pin(100, y, name)
        c.wire(100, y, 140, y)
        c.tunnel(140, y, name, "west")

    carry = "Ci"
    for i in range(4):
        fa_block(c, 250 + 500 * i, 100, "A%d" % i, "B%d" % i, carry,
                 "S%d" % i, "C%d" % (i + 1))
        carry = "C%d" % (i + 1)

    for k, name in enumerate(["S3", "S2", "S1", "S0"]):
        y = 80 + 40 * k
        c.wire(2200, y, 2240, y)
        c.tunnel(2200, y, name, "east")
        c.pin(2240, y, name, output=True, facing="west")
    c.wire(2200, 300, 2240, 300)
    c.tunnel(2200, 300, "C4", "east")
    c.pin(2240, 300, "C4", output=True, facing="west")


JOBS = [
    ("PRELAB_3/EXP_3_1", "full_adder", "full_adder.circ"),
    ("LAB_3/EXP_1_full_adder", "full_adder", "full_adder.circ"),
    ("PRELAB_3/EXP_3_2", "adder4", "adder4.circ"),
    ("LAB_3/EXP_2_addsub_4bit", "adder4", "adder4.circ"),
]


def main():
    for rel, kind, circ_name in JOBS:
        d = ROOT / rel
        c = Circ()
        globals()[kind](c)
        circ = d / circ_name
        c.save(circ)
        out = run_tty(circ)
        (d / "logisim_table.txt").write_text(out, encoding="utf-8")
        rows = out.strip().splitlines()
        print(f"--- {rel} ({circ_name}) ---")
        print("\n".join(rows[:6]))
        if len(rows) > 6:
            print("... %d rows total" % (len(rows) - 1))


if __name__ == "__main__":
    main()
