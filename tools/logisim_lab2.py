#!/usr/bin/env python3
"""Sinh file .circ cho 5 bài Lab 2 và chạy Logisim headless.

    python tools/logisim_lab2.py

Mỗi mạch dùng Tunnel cho mọi net nên không có dây cắt chéo (Logisim sẽ nối
các dây cắt nhau và làm chập mạch).

Kết quả: <project>/<ten>.circ và <project>/logisim_table.txt
"""
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from logisim import Circ, run_tty

ROOT = Path(__file__).resolve().parent.parent
SIZE = 50


def inputs(c, names, x=100, y0=80, step=40):
    """Input pins with tunnels."""
    for k, name in enumerate(names):
        c.input_net(x, y0 + step * k, name)


def inverters(c, x, y0, nets, step=60):
    """Place NOT gates for the given nets. Returns the new net names."""
    out = []
    for k, net in enumerate(nets):
        name = "n" + net
        c.gate_net(x, y0 + step * k, "NOT", [net], name)
        out.append(name)
    return out


def minterms(c, x, y0, bits, step=60):
    """8 minterm AND gates. bits = (netx, nety, netz) already inverted."""
    bx, by, bz = bits
    nets = []
    for m in range(8):
        name = "m%d" % m
        # a minterm needs the plain variable when its bit is 1, the inverted
        # one when its bit is 0
        ins = [bx if not (m >> 2) & 1 else bx[1:],
               by if not (m >> 1) & 1 else by[1:],
               bz if not m & 1 else bz[1:]]
        c.gate_net(x, y0 + step * m, "AND", ins, name, inputs=3)
        nets.append(name)
    return nets


def exp_2_1(c):
    """f = x'yz + (xy)'z + xy"""
    inputs(c, ["x", "y", "z"])
    nx = inverters(c, 250, 100, ["x"])[0]
    c.gate_net(450, 200, "AND", ["x", "y"], "xy")
    c.gate_net(450, 300, "NOT", ["xy"], "nxy")
    c.gate_net(650, 120, "AND", [nx, "y", "z"], "t1", inputs=3)
    c.gate_net(650, 320, "AND", ["nxy", "z"], "t2")
    c.gate_net(850, 220, "OR", ["t1", "t2", "xy"], "f", inputs=3)
    c.output_net(950, 220, "f")


def exp_2_2(c):
    """F = (Y&Z) | (~X&~Y) | (~Y&~Z)"""
    inputs(c, ["X", "Y", "Z"])
    nx, ny, nz = inverters(c, 250, 100, ["X", "Y", "Z"])
    c.gate_net(450, 140, "AND", ["Y", "Z"], "a1")
    c.gate_net(450, 260, "AND", [nx, ny], "a2")
    c.gate_net(450, 380, "AND", [ny, nz], "a3")
    c.gate_net(650, 260, "OR", ["a1", "a2", "a3"], "F", inputs=3)
    c.output_net(750, 260, "F")


def exp_2_3(c):
    """F = NOR(NOR(x, yz), NAND(~y, x)), Fs = x&~y (equivalent simplified form)"""
    inputs(c, ["x", "y", "z"])
    ny = inverters(c, 250, 100, ["y"])[0]
    c.gate_net(450, 200, "AND", ["y", "z"], "yz")
    c.gate_net(650, 140, "NOR", ["x", "yz"], "A")
    c.gate_net(650, 320, "NAND", [ny, "x"], "B")
    c.gate_net(850, 230, "NOR", ["A", "B"], "F")
    c.gate_net(850, 400, "AND", ["x", ny], "Fs")
    c.output_net(950, 230, "F")
    c.probe(890, 400)


def mux_74ls151(c):
    """74LS151 (8:1 mux): Y = Sigma(1,2,4,7), W = ~Y"""
    inputs(c, ["x", "y", "z"])
    # I = 8'b10010110 (I7..I0)  ->  D0=0 D1=1 D2=1 D3=0 D4=1 D5=0 D6=0 D7=1
    # select S = {x,y,z} -> C = x, B = y, A = z ; enable nG = 0
    c.ttl(400, 400, "74151", {
        0: "0", 1: "1", 2: "1", 3: "0",        # D3 D2 D1 D0
        4: "f", 5: "fbar", 6: "0",            # Y W nG
        7: "x", 8: "y", 9: "z",                # C B A
        10: "1", 11: "0", 12: "0", 13: "1",    # D7 D6 D5 D4
        14: "0", 15: "1"}, label="U1")         # GND VCC
    c.output_net(700, 200, "f")
    c.probe(760, 200)


def dec_74ls138(c):
    """74LS138 (3:8 decoder): outputs Y0..Y7 active low, f = Sigma(0,2,5,7)"""
    inputs(c, ["x", "y", "z"])
    # select A = {x,y,z} -> C = x, B = y, A = z
    # enable: nEN2A = 0, nEN2B = 0, EN1 = 1
    c.ttl(400, 400, "74138", {
        0: "z", 1: "y", 2: "x",                # A B C
        3: "0", 4: "0", 5: "1",                # nEN2A nEN2B EN1
        6: "nY7",
        7: "nY6", 8: "nY5", 9: "nY4", 10: "nY3", 11: "nY2", 12: "nY1", 13: "nY0",
        14: "0", 15: "1"}, label="U1")
    # f = ~(nY0 . nY2 . nY5 . nY7) : 2 x AND (74LS08) + 1 x NAND (74LS00)
    c.ttl(700, 600, "7408", {0: "nY0", 1: "nY2", 2: "t1",
                             3: "nY5", 4: "nY7", 5: "t2",
                             12: "0", 13: "1"}, label="U2")
    c.ttl(900, 600, "7400", {0: "t1", 1: "t2", 2: "f",
                             12: "0", 13: "1"}, label="U3")
    c.output_net(1100, 200, "f")
    for k in range(8):
        c.probe(460, 380 + 20 * k)


JOBS = [
    ("LAB_2/EXP_2_1", "exp_2_1", "exp_2_1.circ"),
    ("LAB_2/EXP_2_2", "exp_2_2", "exp_2_2.circ"),
    ("LAB_2/EXP_2_3", "exp_2_3", "exp_2_3.circ"),
    ("LAB_2/EXP_2_4", "mux_74ls151", "mux_74ls151.circ"),
    ("LAB_2/EXP_2_5", "dec_74ls138", "dec_74ls138.circ"),
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
        print("\n".join(rows))


if __name__ == "__main__":
    main()
