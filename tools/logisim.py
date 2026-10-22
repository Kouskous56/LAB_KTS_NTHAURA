#!/usr/bin/env python3
"""Build Logisim Evolution .circ files and run them headless.

Logisim can be driven from the terminal:
    java -jar logisim-evolution.jar -tty table --toplevel-circuit main file.circ
    java -jar logisim-evolution.jar -w main vectors.txt file.circ   (test vectors)

Note: Logisim loops forever (OutOfMemory) when two wires overlap on the same
line, so the builder removes overlapping parts of the wires it writes.
"""
import subprocess
from pathlib import Path

LOGISIM = r"C:\Program Files\logisim-evolution\app\logisim-evolution-5.0.0-all.jar"

HEADER = """<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<project source="5.0.0" version="1.0">
This file is intended to be loaded by Logisim-evolution v5.0.0(https://github.com/logisim-evolution/)
<lib desc="#Wiring" name="0"/>
<lib desc="#Gates" name="1"/>
<main name="main"/>
<options>
  <option name="gateUndefined" value="ignore"/>
  <option name="simlimit" value="1000"/>
  <option name="simrand" value="0"/>
</options>
<circuit name="main">
  <a name="appearance" val="logisim_evolution"/>
  <a name="circuit" val="main"/>
"""

FOOTER = """</circuit>
</project>
"""


def _overlap(a, b):
    """True if two axis aligned segments share more than one point."""
    (x1, y1, x2, y2), (x3, y3, x4, y4) = a, b
    if y1 == y2 == y3 == y4:
        lo1, hi1 = sorted((x1, x2))
        lo2, hi2 = sorted((x3, x4))
        return hi1 > lo2 and hi2 > lo1
    if x1 == x2 == x3 == x4:
        lo1, hi1 = sorted((y1, y2))
        lo2, hi2 = sorted((y3, y4))
        return hi1 > lo2 and hi2 > lo1
    return False


class Circ:
    """Build a Logisim .circ file."""

    def __init__(self):
        self.comps = []          # xml chunks of the components
        self.wires = []          # (x1, y1, x2, y2)

    # ---- components -------------------------------------------------
    def pin(self, x, y, label, output=False, facing="east"):
        out = '    <comp lib="0" loc="(%d,%d)" name="Pin">\n' % (x, y)
        out += '      <a name="facing" val="%s"/>\n' % facing
        out += '      <a name="label" val="%s"/>\n' % label
        if output:
            out += '      <a name="output" val="true"/>\n'
        out += "    </comp>\n"
        self.comps.append(out)

    def tunnel(self, x, y, label, facing="east"):
        out = '    <comp lib="0" loc="(%d,%d)" name="Tunnel">\n' % (x, y)
        out += '      <a name="facing" val="%s"/>\n' % facing
        out += '      <a name="label" val="%s"/>\n' % label
        out += "    </comp>\n"
        self.comps.append(out)

    def gate(self, x, y, kind, size=50, inputs=2, label=None, negate_out=False):
        name = {"AND": "AND Gate", "OR": "OR Gate", "XOR": "XOR Gate",
                "NAND": "NAND Gate", "NOR": "NOR Gate", "NOT": "NOT Gate"}[kind]
        out = '    <comp lib="1" loc="(%d,%d)" name="%s">\n' % (x, y, name)
        out += '      <a name="size" val="%d"/>\n' % size
        if kind != "NOT":
            out += '      <a name="inputs" val="%d"/>\n' % inputs
        if negate_out:
            out += '      <a name="out" val="1"/>\n'
        if label:
            out += '      <a name="label" val="%s"/>\n' % label
        out += "    </comp>\n"
        self.comps.append(out)

    def text(self, x, y, s, size=12):
        out = '    <comp lib="0" loc="(%d,%d)" name="Text">\n' % (x, y)
        out += '      <a name="text" val="%s"/>\n' % s
        out += '      <a name="font" val="SansSerif plain %d"/>\n' % size
        out += '      <a name="halign" val="center"/>\n'
        out += '      <a name="valign" val="center"/>\n'
        out += "    </comp>\n"
        self.comps.append(out)

    # Logisim gate geometry (measured with Logisim 5.0.0):
    #   input pins are at (x - size, y +/- off), off = 10 for size 30, 20 for 50/70
    #   the XOR gate is 10 px wider (extra curve), so its inputs are at x - size - 10
    @staticmethod
    def gate_dx(kind, size):
        return size + (10 if kind in ("XOR", "XNOR") else 0)

    @staticmethod
    def gate_offset(size):
        return 10 if size == 30 else 20

    def gate_inputs(self, x, y, kind, size=50, inputs=2):
        dx = self.gate_dx(kind, size)
        off = self.gate_offset(size)
        if inputs == 1:
            return [(x - dx, y)]
        step = 2 * off / (inputs - 1)
        return [(x - dx, y - off + i * step) for i in range(inputs)]

    # ---- wires ------------------------------------------------------
    def wire(self, x1, y1, x2, y2):
        """Add a wire. Diagonal segments are split into two orthogonal ones and
        overlapping parts are removed, because Logisim loops forever on both."""
        if x1 == x2 and y1 == y2:
            return
        if x1 != x2 and y1 != y2:
            self.wire(x1, y1, x2, y1)
            self.wire(x2, y1, x2, y2)
            return
        keep = []
        for w in self.wires:
            if not _overlap(w, (x1, y1, x2, y2)):
                keep.append(w)
                continue
            # cut the overlapping part out of the old wire
            (ax1, ay1, ax2, ay2) = w
            if ay1 == ay2:                      # horizontal
                lo, hi = sorted((x1, x2))
                wlo, whi = sorted((ax1, ax2))
                if lo < wlo and wlo != ax1:
                    keep.append((ax1, ay1, wlo, ay1))
                if hi > whi and whi != ax2:
                    keep.append((whi, ay1, ax2, ay1))
            else:                               # vertical
                lo, hi = sorted((y1, y2))
                wlo, whi = sorted((ay1, ay2))
                if lo < wlo and wlo != ay1:
                    keep.append((ax1, ay1, ax1, wlo))
                if hi > whi and whi != ay2:
                    keep.append((ax1, whi, ax2, ay2))
        keep.append((x1, y1, x2, y2))
        self.wires = keep

    # ---- output -----------------------------------------------------
    def save(self, path):
        body = "".join(self.comps)
        for (x1, y1, x2, y2) in self.wires:
            body += '    <wire from="(%d,%d)" to="(%d,%d)"/>\n' % (x1, y1, x2, y2)
        Path(path).write_text(HEADER + body + FOOTER, encoding="utf-8")
        return path


def run_tty(circ_path, circuit="main", fmt="table"):
    """Run Logisim headless and return its stdout."""
    cmd = ["java", "-jar", LOGISIM, "-tty", fmt, "--toplevel-circuit", circuit, str(circ_path)]
    r = subprocess.run(cmd, capture_output=True, text=True)
    return r.stdout + r.stderr


def run_vectors(circ_path, vec_path, circuit="main"):
    cmd = ["java", "-jar", LOGISIM, "-w", circuit, str(vec_path), str(circ_path)]
    r = subprocess.run(cmd, capture_output=True, text=True)
    return r.stdout + r.stderr
