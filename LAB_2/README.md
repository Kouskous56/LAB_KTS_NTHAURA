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
cd LAB_2\EXP_2_1
iverilog -g2012 -o tb.vvp *.sv
vvp tb.vvp
```

Kiểm tra cả 14 project của ba lab:

```powershell
python tools\verify_all.py
```

> Bộ script `tools/` và các ảnh/bảng kết quả thô chỉ nằm ở máy cá nhân của tác giả,
> không có trong repo. Repo giữ mã thiết kế, sơ đồ Logisim, netlist SPICE và tài liệu.

## Kết quả kiểm chứng

Mỗi mạch được kiểm bằng **ba công cụ độc lập**: testbench `iverilog`, mô phỏng Logisim
Evolution (bảng chân lý do chính Logisim sinh ra) và mô phỏng SPICE chạy trên **cả LTspice
lẫn ngspice** (cùng một netlist).

| Bài | Testbench `iverilog` | Logisim | SPICE (LTspice / ngspice) | Bitstream |
|---|---|---|---|---|
| EXP_2_1 | ALL 8 TESTS PASS | 8/8 dòng khớp Table 2.2 | PASS / PASS | `top_module.bit` |
| EXP_2_2 | ALL 8 TESTS PASS | 8/8 dòng khớp Table 2.3 | PASS / PASS | `top_module.bit` |
| EXP_2_3 | ALL 8 TESTS PASS | 8/8 dòng, F khớp Fs | PASS / PASS | `top_module.bit` |
| EXP_2_4 | ALL 8 TESTS PASS | 8/8 dòng, dùng IC thật **74LS151** | PASS / PASS | `top_module.bit` |
| EXP_2_5 | ALL 8 TESTS PASS | 8/8 dòng, dùng IC thật **74LS138** | PASS / PASS | `top_module.bit` |

Bảng chân lý đầy đủ của từng bài đã ghi ở mục trên. Dạng sóng mô phỏng (Icarus Verilog
và SPICE) và sơ đồ logic được sinh ở máy cá nhân, không đưa lên repo.

### Ghi chú về hai bài dùng IC thật

- **EXP_2_4 (74LS151)**: `I = 8'b10010110` (I7..I0), chọn `S = {x,y,z}` tức `C=x, B=y, A=z`,
  cho phép `nG = 0`. Ngõ ra `Y` là `f`, `W` là ngõ ra đảo.
- **EXP_2_5 (74LS138)**: cho phép `nEN2A = 0`, `nEN2B = 0`, `EN1 = 1`; chọn `A = {x,y,z}`
  (`C=x, B=y, A=z`). Vì ngõ ra mức thấp nên `f = ~(Y0.Y2.Y5.Y7)`, dựng bằng
  **74LS08** (hai cổng AND) + **74LS00** (một cổng NAND).

## File trong mỗi thư mục bài

| File | Nội dung |
|---|---|
| `*.sv` | mô hình SystemVerilog (module thiết kế + testbench `tb.sv` + `top_module.sv` cho bo Nexys A7) |
| `Nexys-A7-100T-Master.xdc` | ràng buộc chân cho bo |
| `*.circ` | sơ đồ mạch trong **Logisim Evolution** (mở trực tiếp được, dùng IC thật của thư viện TTL) |
| `*.cir` | netlist SPICE của cùng mạch (chạy được bằng cả LTspice lẫn ngspice) |
| `project_*/` | project Vivado (chỉ có ở LAB_2, đã build sẵn `.bit`) |

> **Lưu ý**: ảnh minh chứng (`logic_diagram.png`, `application_circuit.png`, `wave.png`,
> `spice_wave.png`) và bảng kết quả thô (`logisim_table.txt`, `spice_table_*.txt`) được
> sinh bằng bộ script trên máy cá nhân của tác giả, **không đưa lên repo**. Repo giữ
> mã thiết kế, sơ đồ Logisim, netlist SPICE và tài liệu.
