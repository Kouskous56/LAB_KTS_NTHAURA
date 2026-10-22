#!/usr/bin/env python3
"""Draw logic diagrams and application circuits as PNG (terminal only, no GUI).

Two drawing styles are supported:

  logisim  - Logisim Evolution look: cream canvas, dark blue wires, black
             component outlines, small square pins
  vivado   - Vivado RTL Viewer look: white canvas, light blue cells with
             blue border, dark blue wires, rounded boxes
"""
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from matplotlib.patches import Polygon, Rectangle, Circle, Arc, FancyBboxPatch

STYLES = {
    "logisim": {
        "bg": "#f7f7f0", "wire": "#00008b", "ink": "#000000",
        "gate_fill": "#ffffff", "box_fill": "#ffffff", "box_line": "#000000",
        "pin": "#00008b", "dot": "#00008b", "title": "#00008b",
    },
    "vivado": {
        "bg": "#ffffff", "wire": "#1f4e79", "ink": "#000000",
        "gate_fill": "#dce6f1", "box_fill": "#dce6f1", "box_line": "#1f4e79",
        "pin": "#1f4e79", "dot": "#1f4e79", "title": "#1f4e79",
    },
}


class Sheet:
    """A schematic sheet."""

    def __init__(self, width=12.0, height=6.0, title="", style="vivado"):
        self.c = STYLES[style]
        self.style = style
        self.fig, self.ax = plt.subplots(figsize=(width, height))
        self.ax.set_xlim(0, 100)
        self.ax.set_ylim(0, 60)
        self.ax.set_aspect("equal")
        self.ax.axis("off")
        self.fig.patch.set_facecolor(self.c["bg"])
        self.ax.set_facecolor(self.c["bg"])
        if title:
            self.ax.set_title(title, fontsize=11, color=self.c["title"], pad=8)

    # ---- primitives -------------------------------------------------
    def wire(self, x1, y1, x2, y2, dot=False, mode="vh"):
        """Orthogonal wire. mode 'vh' = vertical first, 'hv' = horizontal first."""
        col = self.c["wire"]
        if abs(x1 - x2) > 1e-9 and abs(y1 - y2) > 1e-9:
            if mode == "vh":
                self.ax.plot([x1, x1], [y1, y2], color=col, lw=1.3, solid_capstyle="round")
                self.ax.plot([x1, x2], [y2, y2], color=col, lw=1.3, solid_capstyle="round")
            else:
                self.ax.plot([x1, x2], [y1, y1], color=col, lw=1.3, solid_capstyle="round")
                self.ax.plot([x2, x2], [y1, y2], color=col, lw=1.3, solid_capstyle="round")
        else:
            self.ax.plot([x1, x2], [y1, y2], color=col, lw=1.3, solid_capstyle="round")
        if dot:
            self.dot(x2, y2)

    def poly(self, pts, fill=None, lw=1.3):
        self.ax.add_patch(Polygon(pts, closed=True, facecolor=fill or self.c["gate_fill"],
                                  edgecolor=self.c["ink"], lw=lw))

    def text(self, x, y, s, size=8, ha="center", va="center", weight="normal", style="normal"):
        self.ax.text(x, y, s, fontsize=size, ha=ha, va=va, color=self.c["ink"],
                     fontweight=weight, fontstyle=style)

    def label(self, x, y, s, size=8, ha="left", va="center"):
        self.ax.text(x, y, s, fontsize=size, ha=ha, va=va, color=self.c["ink"], family="monospace")

    def dot(self, x, y):
        """Junction: square in Logisim, filled dot in Vivado."""
        if self.style == "logisim":
            self.ax.add_patch(Rectangle((x - 0.7, y - 0.7), 1.4, 1.4, color=self.c["dot"]))
        else:
            self.ax.add_patch(Circle((x, y), 0.6, color=self.c["dot"]))

    def pin(self, x, y, name, side="right"):
        """A pin on a component: small square (Logisim) or short stub (Vivado)."""
        if self.style == "logisim":
            self.ax.add_patch(Rectangle((x - 0.7, y - 0.7), 1.4, 1.4,
                                         facecolor=self.c["pin"], edgecolor="none"))
        self.label(x + (1.2 if side == "right" else -1.2), y, name, size=7,
                   ha="left" if side == "right" else "right")

    def box(self, x, y, w, h, title, lines=(), fill=None, tsize=9, radius=0.0):
        fc = fill or self.c["box_fill"]
        if self.style == "vivado" and radius:
            self.ax.add_patch(FancyBboxPatch((x + radius, y + radius), w - 2 * radius, h - 2 * radius,
                                             boxstyle=f"round,pad={radius}",
                                             facecolor=fc, edgecolor=self.c["box_line"], lw=1.3))
        else:
            self.ax.add_patch(Rectangle((x, y), w, h, facecolor=fc, edgecolor=self.c["box_line"], lw=1.4))
        self.text(x + w / 2, y + h - 1.8, title, size=tsize, weight="bold")
        for i, ln in enumerate(lines):
            self.text(x + w / 2, y + h - 3.6 - i * 2.2, ln, size=7.5)

    # ---- logic gates -------------------------------------------------
    def gate(self, kind, x, y, w=6.0, h=8.0, invert=False, label=None):
        """Draw a gate with the output at (x+w, y). Inputs on the left."""
        fill = self.c["gate_fill"]
        if kind in ("AND", "NAND"):
            body = [(x, y - h / 2), (x, y + h / 2), (x + w * 0.55, y + h / 2),
                    (x + w, y), (x + w * 0.55, y - h / 2)]
            self.poly(body, fill)
        elif kind in ("OR", "NOR"):
            body = [(x, y - h / 2), (x + w * 0.25, y - h / 2), (x + w, y),
                    (x + w * 0.25, y + h / 2), (x, y + h / 2), (x + w * 0.25, y)]
            self.poly(body, fill)
        elif kind in ("XOR", "XNOR"):
            body = [(x + 0.9, y - h / 2), (x + 0.9, y + h / 2), (x + w * 0.25 + 0.9, y + h / 2),
                    (x + w + 0.9, y), (x + w * 0.25 + 0.9, y - h / 2)]
            self.poly(body, fill)
            self.ax.add_patch(Arc((x + 0.6, y), 3.0, h, theta1=80, theta2=280,
                                  color=self.c["ink"], lw=1.3))
        elif kind == "NOT":
            body = [(x, y - h / 2), (x, y + h / 2), (x + w, y)]
            self.poly(body, fill)
        else:
            raise ValueError(kind)
        if invert:
            self.ax.add_patch(Circle((x + w + 1.0, y), 0.85, facecolor=self.c["bg"],
                                     edgecolor=self.c["ink"], lw=1.3))
        if label:
            self.text(x + w * 0.45, y + h / 2 + 2.4, label, size=7)

    def bubble(self, x, y, label=None):
        self.ax.add_patch(Circle((x, y), 0.85, facecolor=self.c["bg"],
                                 edgecolor=self.c["ink"], lw=1.3))
        if label:
            self.text(x, y - 3.0, label, size=7)

    def switch(self, x, y, name):
        """Input switch / knob."""
        self.ax.add_patch(Circle((x, y), 1.3, facecolor=self.c["bg"],
                                 edgecolor=self.c["ink"], lw=1.2))
        self.wire(x, y - 1.3, x, y - 4.0)
        self.label(x + 2.0, y, name, size=8, ha="left")

    def led(self, x, y, name):
        self.ax.add_patch(Circle((x, y), 1.4, facecolor=self.c["bg"],
                                 edgecolor=self.c["ink"], lw=1.2))
        self.wire(x, y + 1.4, x, y + 4.0)
        self.label(x + 2.0, y, name, size=8, ha="left")

    def dff(self, x, y, w=9.0, h=11.0, name="", inputs=("D", "CLK"), outputs=("Q", "Q'")):
        """D flip-flop block."""
        if self.style == "vivado":
            self.ax.add_patch(FancyBboxPatch((x + 0.8, y + 0.8), w - 1.6, h - 1.6,
                                             boxstyle="round,pad=0.8",
                                             facecolor=self.c["box_fill"],
                                             edgecolor=self.c["box_line"], lw=1.3))
        else:
            self.ax.add_patch(Rectangle((x, y), w, h, facecolor=self.c["box_fill"],
                                        edgecolor=self.c["box_line"], lw=1.4))
        self.text(x + w / 2, y + h - 2.4, name or "D-FF", size=8.5, weight="bold")
        for i, nm in enumerate(inputs):
            yy = y + h - 5.6 - i * 3.0
            self.wire(x - 3.0, yy, x, yy)
            self.label(x - 3.4, yy, nm, size=7.5, ha="right")
        for i, nm in enumerate(outputs):
            yy = y + h - 5.6 - i * 3.0
            self.wire(x + w, yy, x + w + 3.0, yy)
            self.label(x + w + 3.4, yy, nm, size=7.5, ha="left")

    def state(self, x, y, r=3.2, name="A", code=""):
        self.ax.add_patch(Circle((x, y), r, facecolor=self.c["bg"],
                                 edgecolor=self.c["ink"], lw=1.4))
        self.text(x, y + 0.9, name, size=9, weight="bold")
        if code:
            self.text(x, y - 1.3, code, size=7)

    def arrow(self, x1, y1, x2, y2, text=None, rad=0.0, side="above"):
        self.ax.annotate("", xy=(x2, y2), xytext=(x1, y1),
                         arrowprops=dict(arrowstyle="-|>", color=self.c["ink"], lw=1.3,
                                         shrinkA=0, shrinkB=0,
                                         connectionstyle=f"arc3,rad={rad}"))
        if text:
            mx, my = (x1 + x2) / 2, (y1 + y2) / 2
            if rad:
                mx += rad * 6
                my += rad * 6
            self.text(mx, my + (1.6 if side == "above" else -1.6), text, size=7.5)

    def save(self, path, dpi=200):
        self.fig.subplots_adjust(left=0.02, right=0.98, top=0.90, bottom=0.04)
        self.fig.savefig(path, dpi=dpi, facecolor=self.c["bg"])
        plt.close(self.fig)
        print("wrote", path)
