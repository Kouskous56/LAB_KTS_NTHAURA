#!/usr/bin/env python3
"""Compile, simulate and render the waveform PNG of every Lab 3 project.

    python tools/render_all.py            # run all projects
    python tools/render_all.py EXP_3_1   # run one project (by name)
"""
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
IVERILOG = "iverilog"
VVP = "vvp"
TOOL = ROOT / "tools" / "vcd2png.py"

# folder -> (title, signals for the waveform)
PROJECTS = {
    "PRELAB_3/EXP_3_1": ("EXP_3_1 - Full Adder (Table 3.1)", "A,B,Ci,S,Co"),
    "PRELAB_3/EXP_3_2": ("EXP_3_2 - 4-bit Adder/Subtractor (Table 3.4)", "Sel,A,B,S_ic,Cout_ic"),
    "PRELAB_3/EXP_3_3": ("EXP_3_3 - 0 to 7 up counter", "clk,clr,Q"),
    "PRELAB_3/EXP_3_4": ("EXP_3_4 - State machine (Figure 3.4)", "clk,clr,X,S"),
    "LAB_3/EXP_1_full_adder": ("LAB3 EXP_1 - Full Adder (Table 3.3)", "A,B,Ci,S,Co"),
    "LAB_3/EXP_2_addsub_4bit": ("LAB3 EXP_2 - 4-bit Adder/Subtractor (Table 3.4)", "Sel,A,B,S_ic,Cout_ic"),
    "LAB_3/EXP_3_dff_74ls74": ("LAB3 EXP_3 - D flip-flop 74LS74 (Table 3.5)", "PRE,CLR,D,CLK,Q,QN"),
    "LAB_3/EXP_4_counter_0_7": ("LAB3 EXP_4 - 0 to 7 up counter", "clk,clr,A,B,Q"),
    "LAB_3/EXP_5_state_machine": ("LAB3 EXP_5 - State machine (Figure 3.6)", "clk,clr,X,S"),
}


def run(cmd, cwd):
    return subprocess.run(cmd, cwd=cwd, shell=True, capture_output=True, text=True)


def main():
    only = sys.argv[1] if len(sys.argv) > 1 else None
    for rel, (title, signals) in PROJECTS.items():
        if only and only not in rel:
            continue
        d = ROOT / rel
        srcs = sorted(p.name for p in d.glob("*.sv"))
        r = run(f"{IVERILOG} -g2012 -o tb.vvp {' '.join(srcs)}", d)
        if r.returncode != 0:
            print(f"{rel}: COMPILE FAIL\n{r.stderr}")
            continue
        r = run(f"{VVP} tb.vvp", d)
        ok = "PASS" in r.stdout
        r2 = run(f'python "{TOOL}" wave.vcd -o wave.png --signals "{signals}" --title "{title}"', d)
        print(f"{rel}: {'TESTS PASS' if ok else 'TESTS FAIL'} | {r2.stdout.strip()} {r2.stderr.strip()}")


if __name__ == "__main__":
    main()
