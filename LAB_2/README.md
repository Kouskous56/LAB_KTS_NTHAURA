# LAB 2: Boolean Algebra and Combinational Circuits

Nguồn: manual "Lab 2", phần B (PDF pp. 21–46). Mỗi bài có module thiết kế + testbench
(`iverilog` + `vvp`), `top_module` cho Nexys A7, XDC, project Vivado (đã build `.bit`),
và **ba lớp minh chứng độc lập**: testbench `iverilog`, mô phỏng Logisim Evolution, mô phỏng
SPICE (LTspice + ngspice).

| Bài | Nội dung | File chính | Kiểm chứng |
|---|---|---|---|
| EXP_2_1 | Full Adder (Table 2.2) | `f_exp2_1.sv` | iverilog + Logisim + SPICE PASS |
| EXP_2_2 | `F = sum m(0,1,3,4,7)` (Table 2.3) | `f_exp2_2.sv`, `f_exp2_2_pos.sv` | iverilog + Logisim + SPICE PASS |
| EXP_2_3 | Hình 2.4: `F = NOR(NOR(x,yz), NAND(~y,x))` | `f_exp2_3.sv`, `f_exp2_3_simp.sv` | iverilog + Logisim + SPICE PASS |
| EXP_2_4 | MUX 74LS151: `f = sum m(1,2,4,7)` | `f_mux74ls151.sv`, `mux74ls151.sv` | iverilog + Logisim + SPICE PASS |
| EXP_2_5 | Decoder 74LS138: `f = sum m(0,2,5,7)` | `f_dec74ls138.sv`, `dec74ls138.sv` | iverilog + Logisim + SPICE PASS |

Tóm tắt kiểm tra toàn bộ: [`REPORT_EVIDENCE.md`](../REPORT_EVIDENCE.md).

## EXP_2_1 – Full Adder

Cổng thực hiện (không rút gọn, đúng như manual):

```
t1 = ~x & y & z
t2 = ~(x & y) & z
t3 =  x & y
f  = t1 | t2 | t3
```

Rút gọn: `f = x·y + z`.

| x | y | z | f |
|---|---|---|---|
| 0 | 0 | 0 | 0 |
| 0 | 0 | 1 | 1 |
| 0 | 1 | 0 | 0 |
| 0 | 1 | 1 | 1 |
| 1 | 0 | 0 | 0 |
| 1 | 0 | 1 | 1 |
| 1 | 1 | 0 | 1 |
| 1 | 1 | 1 | 1 |

Chân: `x = SW[2]`, `y = SW[1]`, `z = SW[0]`, `f = LED[15]`.

## EXP_2_2 – `F = sum m(0,1,3,4,7)`

- Dạng tối giản (SOP): `F = (Y·Z) + (~X·~Y) + (~Y·~Z)` → `f_exp2_2.sv`
- Dạng tích phân (POS) tương đương: `F = (Z + ~Y)·(Y + ~X + ~Z)` → `f_exp2_2_pos.sv`

| X | Y | Z | F |
|---|---|---|---|
| 0 | 0 | 0 | 1 |
| 0 | 0 | 1 | 1 |
| 0 | 1 | 0 | 0 |
| 0 | 1 | 1 | 1 |
| 1 | 0 | 0 | 1 |
| 1 | 0 | 1 | 0 |
| 1 | 1 | 0 | 0 |
| 1 | 1 | 1 | 1 |

## EXP_2_3 – Hình 2.4 (NOR + NAND)

```
A = NOR(x, y·z)
B = NAND(~y, x)
F = NOR(A, B)
```

Theo De Morgan: `F = x·~y` (không phụ thuộc z) – dạng rút gọn nằm ở `f_exp2_3_simp.sv`.
Testbench kiểm tra **cả hai dạng cho khớp nhau**.

| x | y | z | F | Fs (dạng rút gọn) |
|---|---|---|---|---|
| 0 | 0 | 0 | 0 | 0 |
| 0 | 0 | 1 | 0 | 0 |
| 0 | 1 | 0 | 0 | 0 |
| 0 | 1 | 1 | 0 | 0 |
| 1 | 0 | 0 | 1 | 1 |
| 1 | 0 | 1 | 1 | 1 |
| 1 | 1 | 0 | 0 | 0 |
| 1 | 1 | 1 | 0 | 0 |

## EXP_2_4 – Multiplexer 74LS151

Ngõ vào dữ liệu `I = 8'b10010110` (I7..I0) ⇒ `f = sum m(1,2,4,7)`, chọn bằng `S = {x,y,z}`.
Enable `E` tích cực mức thấp (nối GND).

| x | y | z | f |
|---|---|---|---|
| 0 | 0 | 0 | 0 |
| 0 | 0 | 1 | 1 |
| 0 | 1 | 0 | 1 |
| 0 | 1 | 1 | 0 |
| 1 | 0 | 0 | 1 |
| 1 | 0 | 1 | 0 |
| 1 | 1 | 0 | 0 |
| 1 | 1 | 1 | 1 |

## EXP_2_5 – Decoder 74LS138

Bộ giải mã 3→8, ngõ ra tích cực mức thấp; cho phép `E1 = E2 = 0`, `E3 = 1`.
`f = 1` khi một trong `Y0, Y2, Y5, Y7` xuống mức thấp ⇒ `f = sum m(0,2,5,7)`.

| x | y | z | f |
|---|---|---|---|
| 0 | 0 | 0 | 1 |
| 0 | 0 | 1 | 0 |
| 0 | 1 | 0 | 1 |
| 0 | 1 | 1 | 0 |
| 1 | 0 | 0 | 0 |
| 1 | 0 | 1 | 1 |
| 1 | 1 | 0 | 0 |
| 1 | 1 | 1 | 1 |

## Chạy lại

```powershell
# testbench
cd EXP_2_1
iverilog -g2012 -o tb.vvp *.sv
vvp tb.vvp

# Logisim Evolution (headless) -> logisim_table.txt
python ..\..\tools\logisim_lab2.py

# SPICE: LTspice + ngspice -> spice_table_*.txt, spice_wave.png
python ..\..\tools\spice_lab2.py

# ảnh dạng sóng từ Icarus
python ..\..\tools\render_all.py
```

Kiểm tra tất cả 14 project của cả ba lab:

```powershell
python tools\verify_all.py -o REPORT_EVIDENCE.md
```

## File minh chứng trong mỗi thư mục bài

| File | Nội dung |
|---|---|
| `*.circ` | sơ đồ mạch trong Logisim Evolution (mở trực tiếp được) |
| `logisim_table.txt` | bảng chân lý do Logisim mô phỏng, đã đối chiếu với manual |
| `*.cir` | netlist SPICE, chạy được cả LTspice lẫn ngspice |
| `spice_table_ltspice.txt` | bảng chân lý từ LTspice (`RESULT: PASS`) |
| `spice_table_ngspice.txt` | bảng chân lý từ ngspice (`RESULT: PASS`) |
| `spice_wave.png` | dạng sóng mô phỏng SPICE, style GTKWave |
| `wave.png` | dạng sóng Icarus Verilog, style GTKWave |
| `project_*/…/top_module.bit` | bitstream nạp Nexys A7 |
