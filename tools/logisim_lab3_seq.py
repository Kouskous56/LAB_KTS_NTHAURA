#!/usr/bin/env python3
"""Dựng các mạch tuần tự của Lab 3 trong Logisim bằng **IC thật** của thư viện TTL.

    python tools/logisim_lab3_seq.py

IC dùng (thư viện TTL, lib "A" của Logisim Evolution):
    74LS74  hai flip-flop D, preset/clear bất đồng bộ mức thấp
    74LS08  4 cổng AND 2 vào   (dùng cho cổng AND của FSM và cổng điều khiển clock)
    74LS32  4 cổng OR 2 vào    (dùng cho cổng OR của FSM)

Kết quả trong mỗi thư mục bài: <ten>.circ, logisim_table.txt, logisim_vectors.txt

Lưu ý: chế độ `-tty table` của Logisim chỉ phân tích được mạch tổ hợp, còn chế độ
`-w` (test vector) **khởi tạo lại trạng thái mạch ở mỗi dòng vector** nên chỉ kiểm
được các dòng có cạnh clock hoặc có preset/clear tác động. Hành vi đầy đủ của ba
mạch tuần tự được kiểm bằng mô phỏng SPICE (tools/spice_lab3_seq.py) và testbench
iverilog.
"""
import subprocess
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from logisim import Circ, LOGISIM

ROOT = Path(__file__).resolve().parent.parent
JAVA = r"C:\Program Files\Eclipse Adoptium\jre-25.0.4.101-hotspot\bin\java.exe"


def inputs(c, names, x=60, y0=120, step=40):
    """Input pins (nhãn là tên tín hiệu trong testbench)."""
    for k, name in enumerate(names):
        c.input_net(x, y0 + step * k, name)


def outputs(c, names, x=900, y0=120, step=40):
    for k, name in enumerate(names):
        c.output_net(x, y0 + step * k, name)


# ---------------------------------------------------------------------------
# EXP_3: một flip-flop D 74LS74 (bảng chức năng Table 3.5)
def exp_3(c):
    inputs(c, ["D", "CLK", "PRE", "CLR"])
    # U1: flip-flop thu nhất dùng, flip-flop thu hai để dự phòng
    c.ttl(400, 400, "7474", {0: "CLR", 1: "D", 2: "CLK", 3: "PRE",
                            4: "Q", 5: "QN", 12: "0", 13: "1"}, label="U1")
    outputs(c, ["Q", "QN"])


# ---------------------------------------------------------------------------
# Bộ đếm 0 đến 7 dùng 74LS74 (PRELAB) hoặc có thêm cổng cho phép A, B (LAB 3)
def counter(c, enable=False):
    clk0, clk1 = "clk", "nQ0"
    if enable:
        inputs(c, ["clk", "clr", "A", "B"])
        # 74LS08: clock0 = clk.A , clock1 = nQ0.B
        c.ttl(300, 700, "7408", {0: "clk", 1: "A", 2: "clk0", 12: "0", 13: "1"},
              label="U4")
        c.ttl(300, 900, "7408", {0: "nQ0", 1: "B", 2: "clk1", 12: "0", 13: "1"},
              label="U5")
        clk0, clk1 = "clk0", "clk1"
    else:
        inputs(c, ["clk", "clr"])

    # U1: tang 0  (D = ~Q, clock = clk)
    c.ttl(400, 400, "7474", {0: "clr", 1: "nQ0", 2: clk0, 3: "1",
                            4: "Q0", 5: "nQ0", 12: "0", 13: "1"}, label="U1")
    # U2: tang 1 va tang 2
    c.ttl(700, 400, "7474", {0: "clr", 1: "nQ1", 2: "nQ0", 3: "1",
                            4: "Q1", 5: "nQ1",
                            6: "nQ2", 7: "Q2", 8: "1", 9: "nQ1", 10: "nQ2",
                            11: "clr", 12: "0", 13: "1"}, label="U2")
    outputs(c, ["Q2", "Q1", "Q0"], x=1000, y0=120, step=40)


# ---------------------------------------------------------------------------
# Máy trạng thái Figure 3.4: 2 FF (74LS74) + 2 AND (74LS08) + 1 OR (74LS32)
def fsm(c):
    inputs(c, ["clk", "clr", "X"])
    # U1: hai flip-flop trang thai
    c.ttl(400, 400, "7474", {0: "clr", 1: "S1p", 2: "clk", 3: "1",
                            4: "S1", 5: "nS1",
                            6: "nS0", 7: "S0", 8: "1", 9: "clk", 10: "S0p",
                            11: "clr", 12: "0", 13: "1"}, label="U1")
    # U2: S1p = X.S0 ; S0p = X.(nS1 + nS0)
    c.ttl(700, 700, "7408", {0: "X", 1: "S0", 2: "S1p", 12: "0", 13: "1"},
          label="U2")
    c.ttl(700, 900, "7408", {0: "X", 1: "SUM", 2: "S0p", 12: "0", 13: "1"},
          label="U3")
    c.ttl(950, 800, "7432", {0: "nS1", 1: "nS0", 2: "SUM", 12: "0", 13: "1"},
          label="U4")
    outputs(c, ["S1", "S0"], x=1100, y0=120, step=40)


# ---------------------------------------------------------------------------
# Vector kiểm tra (chỉ các dòng mà Logisim TTY kiểm được)
VECTORS = {
    "dff74ls74": (["D", "CLK", "PRE", "CLR", "Q", "QN"], [
        # D CLK PRE CLR   Q  QN
        ["0", "1", "1", "1", "0", "1"],   # canh duong, D=0 -> Q=0
        ["1", "1", "1", "1", "1", "0"],   # canh duong, D=1 -> Q=1
        ["0", "1", "1", "1", "0", "1"],   # canh duong, D=0 -> Q=0
        ["0", "0", "0", "1", "1", "0"],   # preset (bat dong) -> Q=1
        ["0", "0", "1", "0", "0", "1"],   # clear (bat dong) -> Q=0
    ]),
    "counter_0_7": (["clk", "clr", "Q2", "Q1", "Q0"], [
        ["0", "0", "0", "0", "0"],
        ["0", "1", "0", "0", "0"],   # clear -> 000
    ]),
    "fsm_fig34": (["clk", "clr", "X", "S1", "S0"], [
        ["0", "0", "0", "0", "0"],
        ["0", "1", "0", "0", "0"],   # clear -> trang thai A (00)
    ]),
}


def write_vectors(folder, name):
    header, rows = VECTORS[name]
    path = folder / "logisim_vectors.txt"
    path.write_text(" ".join(header) + "\n" + "\n".join(" ".join(r) for r in rows) + "\n",
                    encoding="utf-8")
    return path


def run_vectors(circ, vec):
    """Chay che do test vector cua Logisim, tra ve (so dong, so dong loi)."""
    proc = subprocess.run([JAVA, "-jar", LOGISIM, "-w", "main", str(vec), str(circ)],
                          capture_output=True, text=True, encoding="utf-8",
                          errors="replace", timeout=300)
    out = (proc.stdout or "") + (proc.stderr or "")
    total = len(vec.read_text(encoding="utf-8").strip().splitlines()) - 1
    errors = out.count("Error on test vector")
    return total, errors, out


JOBS = [
    ("LAB_3/EXP_3_dff_74ls74", "dff74ls74.circ", "dff74ls74", exp_3),
    ("LAB_3/EXP_4_counter_0_7", "counter_0_7.circ", "counter_0_7",
     lambda c: counter(c, enable=True)),
    ("LAB_3/EXP_5_state_machine", "fsm_fig34.circ", "fsm_fig34", fsm),
    ("PRELAB_3/EXP_3_3", "counter_0_7.circ", "counter_0_7",
     lambda c: counter(c, enable=False)),
    ("PRELAB_3/EXP_3_4", "fsm_fig34.circ", "fsm_fig34", fsm),
]


def main():
    for rel, circ_name, vec_name, builder in JOBS:
        folder = ROOT / rel
        c = Circ()
        builder(c)
        circ = folder / circ_name
        c.save(circ)
        vec = write_vectors(folder, vec_name)
        total, errors, out = run_vectors(circ, vec)
        (folder / "logisim_table.txt").write_text(out, encoding="utf-8")
        status = "PASS" if errors == 0 else "FAIL"
        print("--- %s (%s) ---" % (rel, circ_name))
        print("test vector: %d/%d dong dung  [%s]" % (total - errors, total, status))
        if errors:
            print(out)


if __name__ == "__main__":
    main()
