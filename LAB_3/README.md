# LAB 3 — Thực hành (PDF pp. 54–62)

Mỗi thí nghiệm có module thiết kế + testbench + `top_module` cho Nexys A7 + XDC.
Chạy kiểm tra: `iverilog -g2012 -o tb.vvp *.sv` rồi `vvp tb.vvp`.

| Exp | Nội dung | File chính | Kết quả tb |
|---|---|---|---|
| EXP_1 | Full Adder bằng cổng logic (Table 3.3) | `full_adder.sv` | ALL 8 TESTS PASS |

> **Tài liệu tham chiếu IC**: xem [`IC_REFERENCE.md`](IC_REFERENCE.md) — pinout 74LS74/74LS283/74LS86/08/32,
> bảng chức năng, và danh sách các chỗ manual sai/lệch đã kiểm chứng với datasheet TI.
| EXP_2 | 4-bit Adder/Subtractor dùng 74LS283 (Table 3.4) | `full_addsub_4bit.sv` + `addsub_4bit_fa.sv` | ALL TESTS PASS (24 lượt: 12 cặp × 2 mode, kiểm song song cả 2 cách dựng) |
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

Pin 74LS74 (DIP-14): `1=1CLR, 2=1D, 3=1CLK, 4=1PRE, 5=1Q, 6=1Q', 7=GND, 8=2Q', 9=2Q, 10=2PRE, 11=2CLK, 12=2D, 13=2CLR, 14=VCC`.
PRE/CLR tác động theo **mức**, không chỉ theo cạnh. Khi PRE=CLR=0 → Q=Q'=1 (nonstable).

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

## Minh chứng mô phỏng từ terminal

Ngoài testbench `iverilog`, mỗi bài còn có minh chứng từ **Logisim Evolution** và
**SPICE (LTspice + ngspice)**, tất cả đều chạy headless:

| File | Nội dung |
|---|---|
| `*.circ` | sơ đồ mạch trong Logisim Evolution, mở trực tiếp được bằng Logisim |
| `logisim_table.txt` | bảng chân lý do chính Logisim mô phỏng |
| `*.cir` | netlist SPICE, mở được bằng cả LTspice lẫn ngspice |
| `spice_table_ltspice.txt` | bảng chân lý lấy từ mô phỏng LTspice (có dòng `RESULT: PASS`) |
| `spice_table_ngspice.txt` | bảng chân lý lấy từ mô phỏng ngspice (có dòng `RESULT: PASS`) |
| `spice_wave.png` | dạng sóng mô phỏng, style GTKWave |
| `logic_diagram.png`, `application_circuit.png`, `wave.png` | hình vẽ logic đồ, mạch ứng dụng, dạng sóng Icarus |

Chạy lại toàn bộ:

```powershell
python tools\logisim_lab3.py       # Full Adder + bo cong 4 bit
python tools\logisim_lab3_seq.py   # mach tuan tu bang IC that cua Logisim
python tools\spice_lab3.py         # Full Adder + bo cong 4 bit
python tools\spice_lab3_seq.py     # DFF, bo dem, may trang thai
python tools\render_all.py
```

Chi tiết cách dùng từng công cụ: `tools/README.md`.

| Bài | Minh chứng thêm |
|---|---|
| EXP_1 | `EXP_1_full_adder/full_adder.circ` + `logisim_table.txt` (Logisim, 8/8 đúng) |
| EXP_2 | `EXP_2_addsub_4bit/adder4.cir` (bộ cộng 4 bit ripple, Figure 3.1), mô phỏng 16 tổ hợp, PASS |
| EXP_3 | `EXP_3_dff_74ls74/dff74ls74.circ` (IC thật **74LS74** của thư viện TTL) + `logisim_vectors.txt` (5/5 dòng) + `dff74ls74.cir` (mô hình SPICE của 74LS74, **11/11 dòng Table 3.5** ở cả LTspice và ngspice) |
| EXP_4 | `EXP_4_counter_0_7/counter_0_7.circ` (**74LS74** + **74LS08** làm cổng cho phép A, B) + `logisim_vectors.txt` + `counter_0_7.cir` (mô phỏng bộ đếm 0 đến 7, PASS ở cả hai simulator) |
| EXP_5 | `EXP_5_state_machine/fsm_fig34.circ` (**74LS74** + **74LS08** + **74LS32**) + `logisim_vectors.txt` + `fsm_fig34.cir` (chuỗi trạng thái A,A,B,D,A,A,A,B, PASS ở cả hai simulator) |

## Mạch Logisim dùng IC thật

Các mạch tuần tự được dựng bằng **IC thật của thư viện TTL** trong Logisim Evolution
(lib `A`), đúng như sơ đồ trong manual:

| Bài | IC dùng trong Logisim |
|---|---|
| EXP_3 | 74LS74 (1 flip-flop, flip-flop còn lại để dự phòng) |
| EXP_4 | 74LS74 × 2 + 74LS08 × 2 (cổng cho phép clock theo A, B) |
| EXP_5 | 74LS74 (2 trạng thái) + 74LS08 (2 cổng AND) + 74LS32 (1 cổng OR) |

Mỗi file `.circ` mở trực tiếp bằng Logisim Evolution để mô phỏng tay trên máy thật
(bấm nút đồng hồ trong thanh công cụ để xem flip-flop đổi trạng thái).

**Giới hạn của chế độ kiểm tự động**: `-tty table` chỉ phân tích được mạch tổ hợp, còn
chế độ test vector (`-w`) **khởi tạo lại trạng thái mạch ở mỗi dòng vector**, nên chỉ
kiểm được các dòng có cạnh clock hoặc có preset/clear tác động (file
`logisim_vectors.txt` trong mỗi thư mục bài). Hành vi đầy đủ của ba mạch tuần tự được
kiểm bằng mô phỏng SPICE và testbench `iverilog`.

## Mô hình SPICE của 74LS74

`tools/spice_lab3_seq.py` dùng chung một sub-circuit `dff` cho cả ba mạch:

- Cổng tắc `SW` mở trong một **xung hẹp sinh ở cạnh dây dương** của clock → lấy mẫu D.
- Tụ điện 5 pF giữ trạng thái, điện trở 1 TΩ chống rò.
- Preset/clear bất đồng bộ mức thấp ép trực tiếp trạng thái (PRE ưu tiên).
- Nhánh RC trì hoãn 5 ns cho bản sao trạng thái, phá vỡ vòng phản hồi `D = ~Q`
  (nếu không, mô phỏng sẽ không có lời giải ổn định).

Vì dùng toàn bộ phần tử sơ cấp của SPICE nên **cùng một netlist chạy được ở LTspice lẫn
ngspice** (ngspice không có hàm `if()`/`delay()` trong nguồn hành vi).
