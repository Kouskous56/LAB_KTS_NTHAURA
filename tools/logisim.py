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
<lib desc="#Memory" name="4"/>
<lib desc="#TTL" name="A"/>
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

# ---------------------------------------------------------------------------
# Thu vien TTL cua Logisim (lib "A"). Vi tri cong lay tu ma nguon
# AbstractTtlGate.updatePorts(): khop DIP 14/16 chan, huong EAST mac dinh.
#   pin 1..N/2 o canh duoi (dy = +30), pin N/2+1..N o canh tren (dy = -30)
#   dx = 20*i + 10 (nua duoi) hoac width - 20*(i - N/2) - 10 (nua tren)
TTL_PINS = {
    "7474": {  # 74LS74 - hai flip-flop D co preset/clear bat dong muc thap
        0: (10, 30, "nCLR1", False), 1: (30, 30, "D1", False),
        2: (50, 30, "CLK1", False), 3: (70, 30, "nPRE1", False),
        4: (90, 30, "Q1", True), 5: (110, 30, "nQ1", True),
        6: (130, -30, "nQ2", True), 7: (110, -30, "Q2", True),
        8: (90, -30, "nPRE2", False), 9: (70, -30, "CLK2", False),
        10: (50, -30, "D2", False), 11: (30, -30, "nCLR2", False),
        12: (130, 30, "GND", False), 13: (10, -30, "VCC", False),
    },
    "7408": {  # 74LS08 - 4 cong AND 2 vao
        0: (10, 30, "1A", False), 1: (30, 30, "1B", False), 2: (50, 30, "1Y", True),
        3: (70, 30, "2A", False), 4: (90, 30, "2B", False), 5: (110, 30, "2Y", True),
        6: (130, -30, "3Y", True), 7: (110, -30, "3A", False), 8: (90, -30, "3B", False),
        9: (70, -30, "4Y", True), 10: (50, -30, "4A", False), 11: (30, -30, "4B", False),
        12: (130, 30, "GND", False), 13: (10, -30, "VCC", False),
    },
    "7432": {  # 74LS32 - 4 cong OR 2 vao (cung chan 74LS08)
        0: (10, 30, "1A", False), 1: (30, 30, "1B", False), 2: (50, 30, "1Y", True),
        3: (70, 30, "2A", False), 4: (90, 30, "2B", False), 5: (110, 30, "2Y", True),
        6: (130, -30, "3Y", True), 7: (110, -30, "3A", False), 8: (90, -30, "3B", False),
        9: (70, -30, "4Y", True), 10: (50, -30, "4A", False), 11: (30, -30, "4B", False),
        12: (130, 30, "GND", False), 13: (10, -30, "VCC", False),
    },
    "7400": {  # 74LS00 - 4 cong NAND 2 vao (cung chan 74LS08)
        0: (10, 30, "1A", False), 1: (30, 30, "1B", False), 2: (50, 30, "1Y", True),
        3: (70, 30, "2A", False), 4: (90, 30, "2B", False), 5: (110, 30, "2Y", True),
        6: (130, -30, "3Y", True), 7: (110, -30, "3A", False), 8: (90, -30, "3B", False),
        9: (70, -30, "4Y", True), 10: (50, -30, "4A", False), 11: (30, -30, "4B", False),
        12: (130, 30, "GND", False), 13: (10, -30, "VCC", False),
    },
    "74151": {  # 74LS151 - bo chon 8:1, chan 16
        0: (10, 30, "D3", False), 1: (30, 30, "D2", False), 2: (50, 30, "D1", False),
        3: (70, 30, "D0", False), 4: (90, 30, "Y", True), 5: (110, 30, "W", True),
        6: (130, 30, "nG", False),
        7: (150, -30, "C", False), 8: (130, -30, "B", False), 9: (110, -30, "A", False),
        10: (90, -30, "D7", False), 11: (70, -30, "D6", False), 12: (50, -30, "D5", False),
        13: (30, -30, "D4", False),
        14: (150, 30, "GND", False), 15: (10, -30, "VCC", False),
    },
    "74138": {  # 74LS138 - bo giai ma 3:8, chan 16, ngõ ra muc thap
        0: (10, 30, "A", False), 1: (30, 30, "B", False), 2: (50, 30, "C", False),
        3: (70, 30, "nEN2A", False), 4: (90, 30, "nEN2B", False), 5: (110, 30, "EN1", False),
        6: (130, 30, "nY7", True),
        7: (150, -30, "nY6", True), 8: (130, -30, "nY5", True), 9: (110, -30, "nY4", True),
        10: (90, -30, "nY3", True), 11: (70, -30, "nY2", True), 12: (50, -30, "nY1", True),
        13: (30, -30, "nY0", True),
        14: (150, 30, "GND", False), 15: (10, -30, "VCC", False),
    },
}


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
        if kind != "NOT":                    # the NOT gate has no size attribute
            out += '      <a name="size" val="%d"/>\n' % size
        if kind != "NOT":
            out += '      <a name="inputs" val="%d"/>\n' % inputs
        if negate_out:
            out += '      <a name="out" val="1"/>\n'
        if label:
            out += '      <a name="label" val="%s"/>\n' % label
        out += "    </comp>\n"
        self.comps.append(out)

    # ---- nets made with tunnels --------------------------------------
    def input_net(self, x, y, label):
        """Input pin wired to a tunnel of the same name."""
        self.pin(x, y, label)
        self.wire(x, y, x + 40, y)
        self.tunnel(x + 40, y, label, "west")

    def output_net(self, x, y, label):
        """Tunnel of the given name wired to an output pin."""
        self.wire(x, y, x + 40, y)
        self.tunnel(x, y, label, "east")
        self.pin(x + 40, y, label, output=True, facing="west")

    def constant(self, x, y, value=1):
        """Constant logic level (0 or 1)."""
        out = '    <comp lib="0" loc="(%d,%d)" name="Constant">\n' % (x, y)
        out += '      <a name="value" val="0x%x"/>\n' % (1 if value else 0)
        out += "    </comp>\n"
        self.comps.append(out)

    def ttl(self, x, y, ic, nets, label=None):
        """Place a real IC of the TTL library and connect the given nets.

        ic:   key of TTL_PINS ("7474", "7408", "7432", ...)
        nets: {port_index: net_name}
        """
        info = TTL_PINS[ic]
        out = '    <comp lib="A" loc="(%d,%d)" name="%s">\n' % (x, y, ic)
        if label:
            out += '      <a name="label" val="%s"/>\n' % label
        out += '      <a name="VccGndPorts" val="true"/>\n'
        out += "    </comp>\n"
        self.comps.append(out)
        for port, net in nets.items():
            dx, dy, _name, is_out = info[port]
            px, py = x + dx, y + dy
            # day ra duoi len, day vao len tren (theo hinh ve cua Logisim)
            stub = 20 if dy > 0 else -20
            self.wire(px, py, px, py + stub)
            if net in ("0", "1"):
                # hang so truc tiep: noi chan cua IC voi nguon hang
                self.constant(px, py + stub, 1 if net == "1" else 0)
            else:
                self.tunnel(px, py + stub, net, "south" if stub > 0 else "north")

    def probe(self, x, y):
        """Probe on a net: shows its value in the schematic but does not
        appear in the truth table (only output pins do)."""
        out = '    <comp lib="0" loc="(%d,%d)" name="Probe">\n' % (x, y)
        out += "    </comp>\n"
        self.comps.append(out)

    def dff(self, x, y, label=None, d="d", clk="clk", pre=None, clr=None,
            q="q", qn=None):
        """D flip-flop (Memory library, lib 4).

        Port positions of Logisim 5 (evolution appearance), measured from the
        source of AbstractFlipFlop:
            D      (x - 10, y + 10)
            CLK    (x - 10, y + 50)
            Q      (x + 50, y + 10)
            Q'     (x + 50, y + 50)
            RESET  (x + 20, y + 60)   active low
            PRESET (x + 20, y)        active low
        """
        out = '    <comp lib="4" loc="(%d,%d)" name="D Flip-Flop">\n' % (x, y)
        if label:
            out += '      <a name="label" val="%s"/>\n' % label
        out += "    </comp>\n"
        self.comps.append(out)
        for net, (px, py) in ((d, (x - 10, y + 10)), (clk, (x - 10, y + 50))):
            if net:
                self.tunnel(px, py, net, "east")
        for net, (px, py) in ((pre, (x + 20, y)), (clr, (x + 20, y + 60))):
            if net:
                self.tunnel(px, py, net, "west")
        for net, (px, py) in ((q, (x + 50, y + 10)), (qn, (x + 50, y + 50))):
            if net:
                self.wire(px, py, px + 40, py)
                self.tunnel(px + 40, py, net, "east")

    def gate_net(self, x, y, kind, ins, out, size=50, inputs=None):
        """Place a gate and connect its inputs/outputs with tunnels.

        ins: list of net names (empty string = left open), out: output net.
        """
        n = inputs if inputs is not None else len(ins)
        self.gate(x, y, kind, size=size, inputs=n)
        for (px, py), net in zip(self.gate_inputs(x, y, kind, size, n), ins):
            if net:
                self.tunnel(px, py, net, "east")
        if out:
            self.wire(x, y, x + 40, y)
            self.tunnel(x + 40, y, out, "west")

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
    #   XOR has an extra curve (10 px) and NAND/NOR an output bubble (10 px),
    #   so their inputs are 10 px further to the left
    @staticmethod
    def gate_dx(kind, size):
        if kind == "NOT":
            return 30                      # the NOT gate is always 30 px wide
        return size + (10 if kind in ("XOR", "XNOR", "NAND", "NOR") else 0)

    @staticmethod
    def gate_offset(size):
        return 10 if size == 30 else 20

    def gate_inputs(self, x, y, kind, size=50, inputs=2):
        """Input port positions of a gate, following the Logisim algorithm."""
        dx = self.gate_dx(kind, size)
        if inputs <= 3:
            if size < 40:
                skip_start, skip_dist, skip_lower = -5, 10, 10
            elif size < 60 or inputs <= 2:
                skip_start, skip_dist, skip_lower = -10, 20, 20
            else:
                skip_start, skip_dist, skip_lower = -15, 30, 30
        elif inputs == 4 and size >= 60:
            skip_start, skip_dist, skip_lower = -5, 20, 0
        else:
            skip_start, skip_dist, skip_lower = -5, 10, 10

        offs = []
        for index in range(inputs):
            if inputs % 2 == 1:
                dy = skip_start * (inputs - 1) + skip_dist * index
            else:
                dy = skip_start * inputs + skip_dist * index
                if index >= inputs // 2:
                    dy += skip_lower
                if inputs == 4 and size >= 60:
                    dy -= 10
            offs.append((x - dx, y + dy))
        return offs

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
