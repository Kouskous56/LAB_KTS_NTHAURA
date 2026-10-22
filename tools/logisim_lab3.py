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


JOBS = [
    ("PRELAB_3/EXP_3_1", "full_adder"),
    ("LAB_3/EXP_1_full_adder", "full_adder"),
]


def main():
    for rel, kind in JOBS:
        d = ROOT / rel
        c = Circ()
        globals()[kind](c)
        circ = d / "full_adder.circ"
        c.save(circ)
        out = run_tty(circ)
        (d / "logisim_table.txt").write_text(out, encoding="utf-8")
        print(f"--- {rel} ---")
        print(out.strip())


if __name__ == "__main__":
    main()
