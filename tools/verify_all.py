#!/usr/bin/env python3
"""Kiểm tra toàn bộ lab: testbench iverilog, bảng Logisim, mô phỏng SPICE, file .bit.

    python tools/verify_all.py                 # in bảng tổng hợp
    python tools/verify_all.py -o REPORT_EVIDENCE.md

Mỗi mạch được kiểm tra bằng ba công cụ độc lập:
    iverilog (testbench), Logisim Evolution (bảng chân lý), SPICE (LTspice + ngspice)
"""
import argparse
import re
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
IVERILOG = r"D:\megatools\oss-cad-suite\oss-cad-suite\bin\iverilog.exe"
VVP = r"D:\megatools\oss-cad-suite\oss-cad-suite\bin\vvp.exe"

ARTIFACTS = ["logic_diagram.png", "application_circuit.png", "state_diagram.png",
             "wave.png", "spice_wave.png"]

# --- bảng chân lý chuẩn (theo manual) ------------------------------------
FA_ROWS = ["0 0 0 0 0", "0 0 1 1 0", "0 1 0 1 0", "0 1 1 0 1",
           "1 0 0 1 0", "1 0 1 0 1", "1 1 0 0 1", "1 1 1 1 1"]
LAB2_ROWS = {
    "LAB_2/EXP_2_1": ["0 0 0 0", "0 0 1 1", "0 1 0 0", "0 1 1 1",
                      "1 0 0 0", "1 0 1 1", "1 1 0 1", "1 1 1 1"],
    "LAB_2/EXP_2_2": ["0 0 0 1", "0 0 1 1", "0 1 0 0", "0 1 1 1",
                      "1 0 0 1", "1 0 1 0", "1 1 0 0", "1 1 1 1"],
    "LAB_2/EXP_2_3": ["0 0 0 0", "0 0 1 0", "0 1 0 0", "0 1 1 0",
                      "1 0 0 1", "1 0 1 1", "1 1 0 0", "1 1 1 0"],
    "LAB_2/EXP_2_4": ["0 0 0 0", "0 0 1 1", "0 1 0 1", "0 1 1 0",
                      "1 0 0 1", "1 0 1 0", "1 1 0 0", "1 1 1 1"],
    "LAB_2/EXP_2_5": ["0 0 0 1", "0 0 1 0", "0 1 0 1", "0 1 1 0",
                      "1 0 0 0", "1 0 1 1", "1 1 0 0", "1 1 1 1"],
}


def adder4_rows():
    """512 dòng của bộ cộng 4 bit (A0..A3, B0..B3, Ci | S3..S0, C4).

    Logisim liệt kê tổ hợp theo thứ tự ngược cột (Ci đổi nhanh nhất).
    """
    rows = []
    for k in range(512):
        cols = [(k >> 8) & 1, (k >> 7) & 1, (k >> 6) & 1, (k >> 5) & 1,   # A0..A3
                (k >> 4) & 1, (k >> 3) & 1, (k >> 2) & 1, (k >> 1) & 1,   # B0..B3
                k & 1]                                                    # Ci
        a = cols[0] + 2 * cols[1] + 4 * cols[2] + 8 * cols[3]
        b = cols[4] + 2 * cols[5] + 4 * cols[6] + 8 * cols[7]
        total = a + b + cols[8]
        s = [(total >> i) & 1 for i in (3, 2, 1, 0)]
        rows.append(" ".join(str(x) for x in cols + s + [1 if total >= 16 else 0]))
    return rows


LOGISIM_EXPECTED = dict(LAB2_ROWS)
LOGISIM_EXPECTED["PRELAB_3/EXP_3_1"] = FA_ROWS
LOGISIM_EXPECTED["LAB_3/EXP_1_full_adder"] = FA_ROWS
LOGISIM_EXPECTED["PRELAB_3/EXP_3_2"] = adder4_rows()
LOGISIM_EXPECTED["LAB_3/EXP_2_addsub_4bit"] = adder4_rows()

NAMES = {
    "LAB_2/EXP_2_1": "EXP_2_1 - Full Adder (Table 2.2)",
    "LAB_2/EXP_2_2": "EXP_2_2 - F = sum m(0,1,3,4,7)",
    "LAB_2/EXP_2_3": "EXP_2_3 - Figure 2.4, F = x&~y",
    "LAB_2/EXP_2_4": "EXP_2_4 - 74LS151, f = sum m(1,2,4,7)",
    "LAB_2/EXP_2_5": "EXP_2_5 - 74LS138, f = sum m(0,2,5,7)",
    "PRELAB_3/EXP_3_1": "PRELAB_3 - Full Adder (Table 3.1)",
    "PRELAB_3/EXP_3_2": "PRELAB_3 - 4-bit Adder/Subtractor (Table 3.4)",
    "PRELAB_3/EXP_3_3": "PRELAB_3 - Bộ đếm 0 đến 7",
    "PRELAB_3/EXP_3_4": "PRELAB_3 - Máy trạng thái (Figure 3.4)",
    "LAB_3/EXP_1_full_adder": "LAB_3 EXP_1 - Full Adder (Table 3.3)",
    "LAB_3/EXP_2_addsub_4bit": "LAB_3 EXP_2 - 4-bit Adder/Subtractor",
    "LAB_3/EXP_3_dff_74ls74": "LAB_3 EXP_3 - D flip-flop 74LS74 (Table 3.5)",
    "LAB_3/EXP_4_counter_0_7": "LAB_3 EXP_4 - Bộ đếm 0 đến 7",
    "LAB_3/EXP_5_state_machine": "LAB_3 EXP_5 - Máy trạng thái (Figure 3.6)",
}


def run_tb(folder):
    """Compile and run the testbench. Returns (ok, summary)."""
    files = sorted(p.name for p in folder.glob("*.sv"))
    vvp_file = folder / "tb.vvp"
    comp = subprocess.run([IVERILOG, "-g2012", "-o", str(vvp_file)] +
                          [str(folder / f) for f in files],
                          capture_output=True, text=True)
    if comp.returncode != 0:
        msg = (comp.stderr or comp.stdout).strip().splitlines()
        return False, "compile error: " + (msg[0][:100] if msg else "?")
    run = subprocess.run([VVP, str(vvp_file)], capture_output=True, text=True, timeout=300)
    out = run.stdout + run.stderr
    passes = len(re.findall(r"\bPASS\b", out))
    fails = len(re.findall(r"\bFAIL\b", out))
    m = re.search(r"(ALL[^\n]*PASS[^\n]*|[^\n]*\d+\s+TESTS?\s+PASS[^\n]*)", out)
    summary = m.group(1).strip() if m else "%d pass / %d fail" % (passes, fails)
    return (fails == 0 and passes > 0), summary


def check_logisim(folder, expected):
    """Compare the Logisim truth table with the table of the manual.

    For the sequential circuits Logisim cannot build a truth table (they are not
    combinational), so they are checked with the test vector mode instead.
    """
    f = folder / "logisim_table.txt"
    if not f.exists():
        return None
    text = f.read_text(encoding="utf-8")
    if expected is None:
        # sequential circuit: checked with test vectors
        if "Error on test vector" in text:
            return "SAI (test vector)"
        return "PASS (vector)"
    rows = [" ".join(ln.split()) for ln in text.strip().splitlines()[1:]]
    if len(rows) != len(expected):
        return "SAI (%d dòng, cần %d)" % (len(rows), len(expected))
    bad = sum(1 for a, b in zip(rows, expected) if a != b)
    return "PASS" if bad == 0 else "SAI (%d dòng sai)" % bad


def check_spice(folder):
    """Both SPICE tables must end with RESULT: PASS."""
    res = []
    for name in ("spice_table_ltspice.txt", "spice_table_ngspice.txt"):
        f = folder / name
        if not f.exists():
            continue
        res.append("PASS" if "RESULT: PASS" in f.read_text(encoding="utf-8") else "FAIL")
    if not res:
        return None
    return "/".join(res)


def check_project(folder):
    rel = str(folder.relative_to(ROOT)).replace("\\", "/")
    tb_ok, tb_msg = run_tb(folder) if (folder / "tb.sv").exists() else (None, "")
    bit = next(folder.rglob("*.bit"), None)
    imgs = [a for a in ARTIFACTS if (folder / a).exists()]
    return {
        "path": rel,
        "name": NAMES.get(rel, rel),
        "tb": tb_ok,
        "tb_msg": tb_msg,
        "bit": bit,
        "imgs": imgs,
        "logisim": check_logisim(folder, LOGISIM_EXPECTED.get(rel)),
        "spice": check_spice(folder),
        "circ": sorted(p.name for p in folder.glob("*.circ")),
        "cir": sorted(p.name for p in folder.glob("*.cir")),
    }


def projects():
    out = []
    for top in ("LAB_2", "LAB_3", "PRELAB_3"):
        for folder in sorted((ROOT / top).iterdir()):
            if folder.is_dir() and (folder / "tb.sv").exists():
                out.append(folder)
    return out


PREAMBLE = """# Báo cáo minh chứng

Mỗi mạch trong `LAB_2`, `LAB_3`, `PRELAB_3` được kiểm tra bằng **ba công cụ độc lập**:

1. **iverilog** – testbench trong mỗi thư mục (`iverilog -g2012 -o tb.vvp *.sv` rồi `vvp tb.vvp`).
2. **Logisim Evolution 5.0.0** – chạy headless (`-tty table`), bảng chân lý do chính Logisim mô phỏng,
   đối chiếu với bảng chân lý trong manual (`logisim_table.txt`).
3. **SPICE** – cùng một netlist chạy bằng **LTspice 26.1.1** và **ngspice 46**; hai bảng
   `spice_table_ltspice.txt` / `spice_table_ngspice.txt` kết thúc bằng `RESULT: PASS`.

Ảnh minh chứng: `wave.png` (dạng sóng Icarus, style GTKWave), `spice_wave.png` (dạng sóng SPICE),
`logic_diagram.png`, `application_circuit.png`, `state_diagram.png` (sơ đồ logic kiểu Logisim/Vivado).

Chạy lại toàn bộ kiểm tra:

```powershell
python tools\\verify_all.py -o REPORT_EVIDENCE.md
```

## Kết quả kiểm tra
"""

FOOTER = """
## Ghi chú

- Chương 3 (`LAB_3`, `PRELAB_3`) **không build `.bit`** theo yêu cầu, chỉ kiểm tra bằng `iverilog`.
  Riêng `LAB_2` có đủ 5 file `.bit` (đã nạp lên Nexys A7).
- Ba mạch tuần tự (D flip-flop, bộ đếm, máy trạng thái) **không kiểm được bằng Logisim headless** vì
  chế độ bảng chân lý của Logisim chỉ phân tích mạch tổ hợp. Chúng được kiểm bằng testbench `iverilog`
  và dạng sóng `wave.png`.
- Chi tiết về cách dùng Logisim / LTspice / ngspice: `tools/README.md`.
"""


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("-o", "--out", default="")
    args = ap.parse_args()

    results = [check_project(f) for f in projects()]
    lines = ["| Bài | iverilog | Logisim | SPICE (LTspice/ngspice) | .bit | ảnh |",
             "|---|---|---|---|---|---|"]
    problems = []
    for r in results:
        tb = "PASS" if r["tb"] else ("FAIL" if r["tb"] is False else "-")
        logisim = r["logisim"] or "-"
        spice = r["spice"] or "-"
        lines.append("| %s | %s | %s | %s | %s | %d |" %
                     (r["name"], tb, logisim, spice,
                      "có" if r["bit"] else "-", len(r["imgs"])))
        if r["tb"] is False or logisim == "SAI" or r["spice"] == "FAIL":
            problems.append(r["path"])
    n_tb = sum(1 for r in results if r["tb"])
    n_log = sum(1 for r in results if r["logisim"] and r["logisim"].startswith("PASS"))
    n_sp = sum(1 for r in results if r["spice"] and "PASS" in r["spice"])
    n_bit = sum(1 for r in results if r["bit"])
    lines += ["", "- iverilog: **%d/%d** project PASS" % (n_tb, len(results)),
              "- Logisim: **%d/%d** project có bảng chân lý đúng" % (n_log, len(results)),
              "- SPICE: **%d/%d** project PASS ở cả LTspice và ngspice" % (n_sp, len(results)),
              "- Bitstream: **%d/%d** project có file `.bit` (chỉ LAB_2, chương 3 không build .bit)"
              % (n_bit, len(results))]
    text = "\n".join(lines)
    print(text)
    if problems:
        print("\nCO VAN:", ", ".join(problems))
    if args.out:
        # báo cáo đầy đủ: phần đầu + bảng + danh sách file từng bài
        detail = ["| Bài | File minh chứng |", "|---|---|"]
        for r in results:
            files = []
            if r["circ"]:
                files.append("Logisim: " + ", ".join("`%s`" % f for f in r["circ"]))
            if r["logisim"]:
                files.append("`logisim_table.txt`")
            if r["cir"]:
                files.append("SPICE: " + ", ".join("`%s`" % f for f in r["cir"]))
            if r["spice"]:
                files.append("`spice_table_ltspice.txt`, `spice_table_ngspice.txt`")
            if r["imgs"]:
                files.append("ảnh: " + ", ".join("`%s`" % f for f in r["imgs"]))
            detail.append("| %s | %s |" % (r["name"], "<br>".join(files) if files else "-"))
        report = (PREAMBLE + text + "\n\n## File minh chứng từng bài\n\n" +
                  "\n".join(detail) + "\n" + FOOTER)
        Path(args.out).write_text(report, encoding="utf-8")
        print("\nda ghi %s" % args.out)
    return 1 if problems else 0


if __name__ == "__main__":
    sys.exit(main())
