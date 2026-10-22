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
| 0 | 0 | X | X | 1 | 1 (nonstable) |
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
PRE/CLR tác động theo **mức**, không chỉ theo cạnh. Khi PRE=CLR=0 → **Q=Q'=1** và trạng thái
không bền (theo Note 1 của datasheet TI); `dff74ls74.sv` mô hình hoá đúng quy tắc này.
Lưu ý: mô hình 74LS74 trong thư viện TTL của Logisim cho ngõ ra `U` ở trường hợp này
(Logisim không mô phỏng trạng thái nonstable), nên dòng này được kiểm bằng testbench
`iverilog` và mô phỏng SPICE chứ không kiểm bằng Logisim.

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
| `*.cir` | netlist SPICE, mở được bằng cả LTspice lẫn ngspice |

Bảng chân lý do Logisim và SPICE sinh ra, cùng dạng sóng và sơ đồ logic, được giữ ở
máy cá nhân của tác giả (không đưa lên repo) vì chúng là **kết quả sinh tự động**;
đối chiếu với manual đã được ghi lại trong các mục bên dưới.

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
kiểm được các dòng có cạnh clock hoặc có preset/clear tác động. Hành vi đầy đủ của ba
mạch tuần tự được kiểm bằng mô phỏng SPICE và testbench `iverilog`.

## Mô hình SPICE của 74LS74

Bộ script dùng chung một sub-circuit `dff` cho cả ba mạch (script ở máy cá nhân, không có trong repo):

- Cổng tắc `SW` mở trong một **xung hẹp sinh ở cạnh dây dương** của clock → lấy mẫu D.
- Tụ điện 5 pF giữ trạng thái, điện trở 1 TΩ chống rò.
- Preset/clear bất đồng bộ mức thấp ép trực tiếp trạng thái (PRE ưu tiên).
- Nhánh RC trì hoãn 5 ns cho bản sao trạng thái, phá vỡ vòng phản hồi `D = ~Q`
  (nếu không, mô phỏng sẽ không có lời giải ổn định).

Vì dùng toàn bộ phần tử sơ cấp của SPICE nên **cùng một netlist chạy được ở LTspice lẫn
ngspice** (ngspice không có hàm `if()`/`delay()` trong nguồn hành vi).

## Kết quả kiểm chứng

| Bài | Testbench `iverilog` | Logisim | SPICE (LTspice / ngspice) | Bitstream |
|---|---|---|---|---|
| EXP_1 | ALL 8 TESTS PASS | 8/8 dòng khớp Table 3.3 | PASS / PASS | không build |
| EXP_2 | ALL TESTS PASS (24 lượt: 12 cặp Table 3.4 × 2 mode) | 512/512 dòng | PASS / PASS (16 tổ hợp) | không build |
| EXP_3 | ALL TESTS PASS | 5/5 dòng test vector (IC thật **74LS74**) | PASS / PASS, **11/11 dòng Table 3.5** | không build |
| EXP_4 | ALL TESTS PASS | 2/2 dòng test vector (IC thật **74LS74** + **74LS08**) | PASS / PASS, đếm đúng 0→7 | không build |
| EXP_5 | ALL TESTS PASS | 2/2 dòng test vector (IC thật **74LS74** + **74LS08** + **74LS32**) | PASS / PASS, chuỗi trạng thái A,A,B,D,A,A,A,B | không build |

Ba bài tuần tự được kiểm bằng **mô hình SPICE của 74LS74** (cổng tắc + tụ giữ, lấy mẫu ở
cạnh dây dương của clock) — cùng một netlist chạy được ở cả LTspice lẫn ngspice.

Kết quả mô phỏng của bộ đếm (mẫu lấy sau mỗi cạnh clock):

| Chế độ | A | B | Q sau từng xung |
|---|---|---|---|
| LSB đứng yên | 0 | 1 | 000, 000, 000, 000, 000 |
| Chỉ LSB đảo | 1 | 0 | 001, 000, 001 |
| Đếm tự do | 1 | 1 | 001, 010, 011, 100, 101, 110, 111, 000 |

## File trong mỗi thư mục bài

| File | Nội dung |
|---|---|
| `*.sv` | mô hình SystemVerilog (module thiết kế + testbench `tb.sv` + `top_module.sv` cho bo Nexys A7) |
| `Nexys-A7-100T-Master.xdc` | ràng buộc chân cho bo |
| `*.circ` | sơ đồ mạch trong **Logisim Evolution** (mở trực tiếp được, dùng IC thật của thư viện TTL) |
| `*.cir` | netlist SPICE của cùng mạch (chạy được bằng cả LTspice lẫn ngspice) |
| `project_*/` | project Vivado (chỉ có ở LAB_2, đã build sẵn `.bit`) |

> **Lưu ý**: ảnh minh chứng (`logic_diagram.png`, `application_circuit.png`,
> `state_diagram.png`, `wave.png`, `spice_wave.png`), bảng kết quả thô
> (`logisim_table.txt`, `spice_table_*.txt`, `logisim_vectors.txt`) và bộ script
> `tools/` được sinh trên máy cá nhân của tác giả, **không đưa lên repo**. Repo giữ
> mã thiết kế, sơ đồ Logisim, netlist SPICE và tài liệu.
