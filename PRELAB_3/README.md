# PRELAB 3 — LAB 3: Combinational Circuit – Sequential Circuit Design

Nguồn: manual "Lab 3", phần A. PRELAB (PDF pp. 47–53).
Mỗi bài có: module thiết kế + testbench (`iverilog` + `vvp`) + `top_module` cho Nexys A7 + XDC.

| Bài | Nội dung | File chính | Kết quả tb |
|---|---|---|---|
| EXP_3_1 | Full Adder (Table 3.1) | `full_adder.sv` | ALL 8 TESTS PASS |
| EXP_3_2 | 4-bit Adder/Subtractor dùng 74LS283 (Figure 3.1/3.2) | `full_addsub_4bit.sv`, `adder74ls283.sv` | ALL TESTS PASS |
| EXP_3_3 | Bộ đếm 0→7 dùng D-FF 74LS74 (Figure 3.3) | `counter_0_7.sv`, `dff74ls74.sv` | ALL TESTS PASS |
| EXP_3_4 | Mạch tuần tự theo Figure 3.4 (Table 3.2) | `fsm_fig34.sv` | ALL TESTS PASS |

## EXP_3_1 — Full Adder

Bảng chân lý Table 3.1 (A B Ci → S Co):

| A | B | Ci | S | Co |
|---|---|---|---|---|
| 0 | 0 | 0 | 0 | 0 |
| 0 | 0 | 1 | 1 | 0 |
| 0 | 1 | 0 | 1 | 0 |
| 0 | 1 | 1 | 0 | 1 |
| 1 | 0 | 0 | 1 | 0 |
| 1 | 0 | 1 | 0 | 1 |
| 1 | 1 | 0 | 0 | 1 |
| 1 | 1 | 1 | 1 | 1 |

Phương trình: `S = A⊕B⊕Ci`, `Co = A·B + A·Ci + B·Ci`

IC cần dùng (lab): 74LS86 (XOR), 74LS08 (AND), 74LS32 (OR).
Cách hiện thực bằng IC thực tế:
- `T1 = A⊕B` (74LS86), `S = T1⊕Ci` (74LS86)
- `C1 = A·B`, `C2 = T1·Ci` (74LS08), `Co = C1+C2` (74LS32)

## EXP_3_2 — 4-bit Adder/Subtractor (74LS283)

- `Sel = 0` → `S = A + B`
- `Sel = 1` → `S = A − B` (hiện thực bằng `A + ~B + 1`: XOR 4 bit B với `Sel` bằng 74LS86, `Cin = Sel`)

Cấu trúc ripple-carry (Figure 3.1): 4 khối full adder, carry-out khối thấp vào carry-in khối cao hơn.
IC cần dùng: 74LS283 (adder 4 bit), 74LS86 (XOR đảo B khi trừ).

**Lưu ý cần hỏi giảng viên**: manual ghi "ground C0" nhưng phép trừ bù hai cần `Cin = 1` ở chế độ trừ. Trong `full_addsub_4bit.sv` mình nối `Cin = Sel` (0 khi cộng, 1 khi trừ) — cần đối chiếu với wiring thực tế trước khi diễn giải số đo.

Pin 74LS283 (Figure 3.2): `VCC 16, B3 15, A3 14, Σ3 13, A4 12, B4 11, Σ4 10, C4 9, Σ2 1, B2 2, A2 3, Σ1 4, A1 5, B1 6, C0 7, GND 8`.

## EXP_3_3 — Bộ đếm 0→7 (74LS74)

Bộ đếm bất đồng bộ (ripple): mỗi tầng lật (D = ~Q). 74LS74 kích thích cạnh lên nên tầng sau được đồng hồ bằng đầu ra đảo của tầng trước (Q'), nhờ đó:
- `q0'` lên khi `q0` rơi → `q1` tăng mỗi 2 xung
- `q1'` lên khi `q1` rơi → `q2` tăng mỗi 4 xung

Chuỗi đếm: 0,1,2,3,4,5,6,7,0…
IC: 74LS74 (1 package chứa 2 FF → cần 2 package cho 3 FF).

## EXP_3_4 — Mạch tuần tự (Figure 3.4)

Trạng thái: A = 00, B = 01, C = 10, D = 11.

Bảng trạng thái đầy đủ (Table 3.2 + mũi tên Figure 3.4):

| TT hiện tại | | Ngõ vào X | TT kế tiếp | | |
|---|---|---|---|---|---|
| S1 | S0 | | S1+ | S0+ | |
| 0 | 0 | 0 | 0 | 0 | A → A |
| 0 | 0 | 1 | 0 | 1 | A → B |
| 0 | 1 | 0 | 0 | 0 | B → A |
| 0 | 1 | 1 | 1 | 1 | B → D |
| 1 | 0 | 0 | 0 | 0 | C → A |
| 1 | 0 | 1 | 0 | 1 | C → B |
| 1 | 1 | 0 | 0 | 0 | D → A |
| 1 | 1 | 1 | 1 | 0 | D → C |

Ghi chú: manual thiếu dòng `D=11, X=0` trong Table 3.2, nhưng Figure 3.4 có mũi tên D → A khi X = 0 (đã bổ sung ở trên).

Phương trình trạng thái kế tiếp:

```
S1+ = X · S0 · ~S1
S0+ = X · ~(S1 · S0)
```

IC: 74LS74 (2 FF cho 2 trạng thái), 74LS08 (AND), 74LS32 (OR), 74LS86 (XOR nếu cần).
Reset bằng CLR (active low) → về trạng thái A (00).

Chuỗi kiểm tra (Experiment 5): đầu vào `0 1 1 0 0 0 1` bắt đầu từ A cho chuỗi trạng thái
`A → A → B → D → A → A → A → B`.
