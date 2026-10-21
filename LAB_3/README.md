# LAB 3 — Thực hành (PDF pp. 54–62)

Mỗi thí nghiệm có module thiết kế + testbench + `top_module` cho Nexys A7 + XDC.
Chạy kiểm tra: `iverilog -g2012 -o tb.vvp *.sv` rồi `vvp tb.vvp`.

| Exp | Nội dung | File chính | Kết quả tb |
|---|---|---|---|
| EXP_1 | Full Adder bằng cổng logic (Table 3.3) | `full_adder.sv` | ALL 8 TESTS PASS |
| EXP_2 | 4-bit Adder/Subtractor dùng 74LS283 (Table 3.4) | `full_addsub_4bit.sv` | ALL TESTS PASS (24 lượt: 12 cặp × 2 mode) |
| EXP_3 | D Flip-Flop 74LS74 (Table 3.5) | `dff74ls74.sv` | ALL TESTS PASS |
| EXP_4 | Bộ đếm 0→7 dùng 74LS74 | `counter_0_7.sv` | ALL TESTS PASS |
| EXP_5 | Mạch tuần tự Figure 3.6 | `fsm_fig34.sv` | ALL TESTS PASS |

## EXP_1 — Full Adder

IC: 74LS86 (XOR), 74LS08 (AND), 74LS32 (OR). 8 tổ hợp A,B,Ci → ghi S, Co vào Table 3.3.

## EXP_2 — 4-bit Adder/Subtractor (74LS283)

IC: 74LS283 + 74LS86. Đầu vào `Sel`, `A[3:0]`, `B[3:0]`; đầu ra `S[3:0]`, `Cout`.
`Sel=0` → cộng, `Sel=1` → trừ.

12 cặp toán hạng trong Table 3.4 (mỗi cặp đo ở cả 2 mode):
(10,11) (14,10) (12,4) (5,3) (4,5) (13,13) (6,9) (2,8) (1,2) (7,1) (15,6) (9,15)

**Lưu ý cần hỏi giảng viên**: manual ghi "ground C0" nhưng phép trừ bù hai cần `Cin = 1` khi trừ.
Code dùng `Cin = Sel`. Cần xác nhận wiring thực tế trước khi diễn giải số đo.

## EXP_3 — D Flip-Flop 74LS74 (Table 3.5)

`dff74ls74.sv`: kích thích **cạnh lên**, PRE/CLR bất đồng bộ active-low (PRE thắng).
Bảng chức năng:

| PRE | CLR | D | CLK | Q | Q' |
|---|---|---|---|---|---|
| 0 | 0 | X | X | 1 | 0 |
| 1 | 0 | X | X | 0 | 1 |
| 0 | 1 | X | X | 1 | 0 |
| 1 | 1 | 0 | 0 | giữ nguyên | |
| 1 | 1 | 1 | 0 | giữ nguyên | |
| 1 | 1 | 0 | 1 (mức) | giữ nguyên | |
| 1 | 1 | 1 | 1 (mức) | giữ nguyên | |
| 1 | 1 | 0 | ↓ | giữ nguyên | |
| 1 | 1 | 1 | ↓ | giữ nguyên | |
| 1 | 1 | 0 | ↑ | 0 | 1 |
| 1 | 1 | 1 | ↑ | 1 | 0 |

Nguyên tắc: đầu ra chỉ đổi khi có **cạnh lên** clock; tạo cạnh lên bằng cách gạt switch từ 0 sang 1.

## EXP_4 — Bộ đếm 0→7

Ban đầu nối clock vào switch. Hai ngõ vào A và B trong manual không được giải thích;
trong `counter_0_7.sv` mình quy chúng là **enable** cho tầng LSB và tầng kế tiếp:

- `A=0, B=1` → LSB đứng yên, bộ đếm không chạy
- `A=1, B=0` → chỉ LSB lật (0,1,0,1,…)
- `A=B=1` → đếm đủ 0→7

Với `A=B=1`, dùng Digital Pattern Generator (DIO, PP, Clock) ở 1 Hz → 10 Hz → 100 Hz → …
và quan sát khi nào không còn nhìn thấy số đếm đổi bằng mắt.

## EXP_5 — Mạch tuần tự (Figure 3.6)

IC: 74LS74 + 74LS08 + 74LS32. Reset về trạng thái A.
Chuỗi đầu vào `0 1 1 0 0 0 1` (tạo xung clock bằng cách bật/tắt switch) cho chuỗi trạng thái.
Bảng của manual ghi trạng thái *trước* khi áp input tương ứng (ô đầu là A):

| Input | 0 | 1 | 1 | 0 | 0 | 0 | 1 | → sau xung cuối |
|---|---|---|---|---|---|---|---|---|
| State | A | A | B | D | A | A | A | B |

Kiểm tra theo sơ đồ: A -0-> A -1-> B -1-> D -0-> A -0-> A -0-> A -1-> B.

Sơ đồ trạng thái giống hệt Figure 3.4, nên dùng chung module `fsm_fig34.sv` với
`S1+ = X·S0·~S1`, `S0+ = X·~(S1·S0)`.
