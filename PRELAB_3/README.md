# PRELAB 3 — LAB 3: Combinational Circuit – Sequential Circuit Design

Nguồn: manual "Lab 3", phần A. PRELAB (PDF pp. 47–53).
Mỗi bài có: module thiết kế + testbench (`iverilog` + `vvp`) + `top_module` cho Nexys A7 + XDC.

| Bài | Nội dung | File chính | Kết quả tb |
|---|---|---|---|
| EXP_3_1 | Full Adder (Table 3.1) | `full_adder.sv` | ALL 8 TESTS PASS |
| EXP_3_2 | 4-bit Adder/Subtractor dùng 74LS283 (Figure 3.1/3.2) | `full_addsub_4bit.sv`, `adder74ls283.sv`, `addsub_4bit_fa.sv` | ALL TESTS PASS |
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

Trong project này có **hai cách hiện thực** (tb kiểm tra song song, cùng 12 cặp Table 3.4 × 2 mode):
- `full_addsub_4bit.sv` — dùng vi mạch 74LS283 (`adder74ls283.sv`).
- `addsub_4bit_fa.sv` — dựng từ 4 khối Full Adder nối dây carry, đúng sơ đồ Figure 3.1 (ripple-carry thuần).

**Lưu ý cần hỏi giảng viên**: manual ghi "ground C0" nhưng phép trừ bù hai cần `Cin = 1` ở chế độ trừ. Trong `full_addsub_4bit.sv` mình nối `Cin = Sel` (0 khi cộng, 1 khi trừ) — cần đối chiếu với wiring thực tế trước khi diễn giải số đo.

Ngoài ra: TI mô tả 74LS283 có **full internal look-ahead** qua cả 4 bit, chỉ *hiệu quả tương đương ripple* ở mức hệ thống — manual gọi nó là "ripple-carry adder" là không chính xác về mạch nội bộ. Hình Figure 3.1 (4 khối FA nối dây) mới thật sự là ripple thuần.

Pin 74LS283 (Figure 3.2, đã đối chiếu datasheet TI): `VCC 16, B3 15, A3 14, Σ3 13, A4 12, B4 11, Σ4 10, C4 9, GND 8, C0 7, B1 6, A1 5, Σ1 4, A2 3, B2 2, Σ2 1`.
Xem `LAB_3/IC_REFERENCE.md` cho toàn bộ pinout, bảng chức năng và các chỗ manual sai/lệch.

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

Pin 74LS74 (DIP-14, đã đối chiếu datasheet TI): `1=1CLR, 2=1D, 3=1CLK, 4=1PRE, 5=1Q, 6=1Q', 7=GND, 8=2Q', 9=2Q, 10=2PRE, 11=2CLK, 12=2D, 13=2CLR, 14=VCC`.

Chuỗi kiểm tra (Experiment 5): đầu vào `0 1 1 0 0 0 1` bắt đầu từ A cho chuỗi trạng thái
`A → A → B → D → A → A → A → B`.

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
| EXP_3_3 | 74LS74 × 2 (3 tầng đếm, mỗi package chứa 2 flip-flop) |
| EXP_3_4 | 74LS74 (2 trạng thái) + 74LS08 (2 cổng AND) + 74LS32 (1 cổng OR) |

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
| EXP_3_1 | ALL 8 TESTS PASS | 8/8 dòng khớp Table 3.1 | PASS / PASS | không build |
| EXP_3_2 | ALL TESTS PASS (24 lượt: 12 cặp Table 3.4 × 2 mode) | 512/512 dòng | PASS / PASS (16 tổ hợp) | không build |
| EXP_3_3 | ALL TESTS PASS | 2/2 dòng test vector (IC thật **74LS74**) | PASS / PASS, đếm 0→7 rồi về 0 | không build |
| EXP_3_4 | ALL TESTS PASS | 2/2 dòng test vector (IC thật **74LS74** + **74LS08** + **74LS32**) | PASS / PASS, chuỗi trạng thái A,A,B,D,A,A,A,B | không build |

Kết quả mô phỏng bộ đếm EXP_3_3: `000 → 001 → 010 → 011 → 100 → 101 → 110 → 111 → 000`.

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
