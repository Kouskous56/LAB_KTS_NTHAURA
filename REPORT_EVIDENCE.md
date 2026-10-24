# Báo cáo minh chứng

Tổng hợp kết quả kiểm chứng cho **14 bài** trong `LAB_2`, `LAB_3`, `PRELAB_3`.

## Phương pháp kiểm chứng

Mỗi mạch được kiểm bằng **ba công cụ độc lập**, mỗi công cụ dùng một mô hình mô phỏng
khác nhau nên lỗi của một công cụ không thể che được lỗi của công cụ khác:

1. **iverilog** – testbench trong từng thư mục bài:
   `iverilog -g2012 -o tb.vvp *.sv` rồi `vvp tb.vvp`.
   Kết quả từng bài đều kết thúc bằng `ALL TESTS PASS`.
2. **Logisim Evolution 5.0.0** – chạy headless (`-tty table`), bảng chân lý do chính
   Logisim mô phỏng, đối chiếu từng dòng với bảng chân lý trong manual.
   Mạch tuần tự dùng chế độ test vector (`-w`) vì `-tty table` chỉ phân tích được
   mạch tổ hợp.
3. **SPICE** – cùng một netlist chạy bằng **LTspice 26.1.1** và **ngspice 46**;
   cả hai bảng kết quả kết thúc bằng `RESULT: PASS`.

Ngoài ra 5 bài của `LAB_2` đã **build bitstream Vivado** (`.bit`) và nạp được lên
bo Nexys A7.

## Kết quả kiểm tra

| Bài | iverilog | Logisim | SPICE (LTspice/ngspice) | Bitstream |
|---|---|---|---|---|
| LAB_2 EXP_2_1 - Full Adder (Table 2.2) | PASS | PASS | PASS/PASS | có |
| LAB_2 EXP_2_2 - F = sum m(0,1,3,4,7) | PASS | PASS | PASS/PASS | có |
| LAB_2 EXP_2_3 - Figure 2.4, F = x&~y | PASS | PASS | PASS/PASS | có |
| LAB_2 EXP_2_4 - 74LS151, f = sum m(1,2,4,7) | PASS | PASS | PASS/PASS | có |
| LAB_2 EXP_2_5 - 74LS138, f = sum m(0,2,5,7) | PASS | PASS | PASS/PASS | có |
| LAB_3 EXP_1 - Full Adder (Table 3.3) | PASS | PASS | PASS/PASS | không build |
| LAB_3 EXP_2 - 4-bit Adder/Subtractor | PASS | PASS | PASS/PASS | không build |
| LAB_3 EXP_3 - D flip-flop 74LS74 (Table 3.5) | PASS | PASS (vector) | PASS/PASS | không build |
| LAB_3 EXP_4 - Bộ đếm 0 đến 7 | PASS | PASS (vector) | PASS/PASS | không build |
| LAB_3 EXP_5 - Máy trạng thái (Figure 3.6) | PASS | PASS (vector) | PASS/PASS | không build |
| PRELAB_3 EXP_3_1 - Full Adder (Table 3.1) | PASS | PASS | PASS/PASS | không build |
| PRELAB_3 EXP_3_2 - 4-bit Adder/Subtractor (Table 3.4) | PASS | PASS | PASS/PASS | không build |
| PRELAB_3 EXP_3_3 - Bộ đếm 0 đến 7 | PASS | PASS (vector) | PASS/PASS | không build |
| PRELAB_3 EXP_3_4 - Máy trạng thái (Figure 3.4) | PASS | PASS (vector) | PASS/PASS | không build |
| PRELAB_4 EXP_4_1 - Full Adder (Fig. 4.1) | PASS | - | - | không build |
| PRELAB_4 EXP_4_2 - 4-bit Adder/Subtractor (2 phương pháp) | PASS | - | - | không build |
| PRELAB_4 EXP_4_3 - BCD -> 7 đoạn anode chung (Table 4.1) | PASS | - | - | không build |
| PRELAB_4 EXP_4_4 - Bộ chia clock 100 MHz -> 1 Hz | PASS | - | - | không build |
| PRELAB_4 EXP_4_5 - FSM 4 trạng thái | PASS | - | - | không build |
| LAB_4 EXP_1 - Giá trị tuyệt đối 4 bit | PASS | - | - | không build |
| LAB_4 EXP_2 - ALU 4 bit | PASS | - | - | không build |
| LAB_4 EXP_3 - Bộ đếm xuống 3 bit ra 7 đoạn | PASS | - | - | không build |
| LAB_4 EXP_4 - Bộ đếm lên 5 -> 14 | PASS | - | - | không build |
| LAB_4 EXP_5 - Mạch tuần tự (chia hết cho 3 & số 0 chẵn) | PASS | - | - | không build |
| LAB_4 EXP_6 - Máy tự động bán hàng | PASS | - | - | không build |

- iverilog: **25/25** project PASS
- Logisim: **14/14** project khớp bảng chân lý manual (chỉ các bài chương 2-3 có sơ đồ Logisim)
- SPICE: **14/14** project PASS ở cả LTspice và ngspice (chỉ các bài chương 2-3 có netlist SPICE)
- Bitstream: **5/25** project có file `.bit` (chỉ LAB_2; chương 3-4 người dùng tự build)
- IC_SV: **52/52** IC submodule (gates 14, combinational 15, sequential 17, memory 2, misc 4) PASS

## Kết quả chi tiết theo bài

### Mạch tổ hợp

Bảng chân lý đã đối chiếu với manual ở từng bài và nằm trong README của lab tương ứng:

| Bài | Hàm | Bảng chân lý đối chiếu |
|---|---|---|
| LAB_2 EXP_2_1 | Full Adder | 8 dòng khớp Table 2.2 |
| LAB_2 EXP_2_2 | `F = sum m(0,1,3,4,7)` | 8 dòng khớp Table 2.3 |
| LAB_2 EXP_2_3 | `F = NOR(NOR(x,yz), NAND(~y,x))` | 8 dòng, `F` khớp dạng rút gọn `x·~y` |
| LAB_2 EXP_2_4 | MUX 74LS151, `f = sum m(1,2,4,7)` | 8 dòng khớp bảng chọn I = `10010110` |
| LAB_2 EXP_2_5 | Decoder 74LS138, `f = sum m(0,2,5,7)` | 8 dòng khớp bảng chọn ngõ ra Y0, Y2, Y5, Y7 |
| LAB_3 EXP_1 | Full Adder | 8 dòng khớp Table 3.3 |
| LAB_3 EXP_2 | Bộ cộng/trừ 4 bit 74LS283 | 512/512 dòng (Logisim) khớp Table 3.4; iverilog kiểm 12 cặp toán hạng × 2 mode |
| PRELAB_3 EXP_3_1 | Full Adder | 8 dòng khớp Table 3.1 |
| PRELAB_3 EXP_3_2 | Bộ cộng/trừ 4 bit | 512/512 dòng (Logisim) khớp Table 3.4; iverilog kiểm 12 cặp toán hạng × 2 mode |

### Mạch tuần tự

Ba mạch dùng **IC thật** của thư viện TTL trong Logisim (`74LS74`, `74LS08`, `74LS32`)
và được kiểm bằng **mô hình SPICE của 74LS74** (cổng tắc lấy mẫu ở cạnh dây dương
của clock + tụ giữ trạng thái).

| Bài | Kiểm Logisim (test vector) | Kiểm SPICE |
|---|---|---|
| LAB_3 EXP_3 | 5/5 dòng: 3 dòng lấy mẫu theo cạnh clock, 1 dòng preset, 1 dòng clear | **11/11 dòng** Table 3.5, cả LTspice và ngspice |
| LAB_3 EXP_4 | 2/2 dòng (trạng thái sau clear) | Đếm đúng 0→7 rồi về 0, cả hai simulator |
| LAB_3 EXP_5 | 2/2 dòng (trạng thái sau clear) | Chuỗi trạng thái `A,A,B,D,A,A,A,B` khớp manual, cả hai simulator |
| PRELAB_3 EXP_3_3 | 2/2 dòng (trạng thái sau clear) | Đếm đúng 0→7 rồi về 0, cả hai simulator |
| PRELAB_3 EXP_3_4 | 2/2 dòng (trạng thái sau clear) | Chuỗi trạng thái `A,A,B,D,A,A,A,B` khớp manual, cả hai simulator |

Bảng chức năng đầy đủ của D flip-flop (Table 3.5) nằm trong
[`LAB_3/README.md`](LAB_3/README.md).

## Ghi chú và giới hạn

- Chương 3 (`LAB_3`, `PRELAB_3`) **không build `.bit`** theo yêu cầu, chỉ kiểm bằng
  `iverilog` và mô phỏng. Riêng `LAB_2` có đủ 5 file `.bit` đã nạp lên Nexys A7.
- Chế độ bảng chân lý của Logisim (`-tty table`) chỉ phân tích được **mạch tổ hợp**.
  Ba mạch tuần tự được dựng bằng **IC thật** (74LS74, 74LS08, 74LS32) và kiểm bằng
  **chế độ test vector**; hành vi đầy đủ được kiểm bằng mô phỏng SPICE và testbench.
- Chế độ test vector của Logisim **khởi tạo lại trạng thái mạch ở mỗi dòng vector**,
  nên chỉ kiểm được các dòng có cạnh clock hoặc có preset/clear tác động. Phần
  "giữ trạng thái" phải kiểm bằng SPICE hoặc testbench `iverilog`.
- Model SPICE của 74LS74 là mô hình **hành vi** (cổng tắc + tụ giữ), không phải mô hình
  transistor. Cùng một netlist chạy được ở cả LTspice lẫn ngspice nhờ chỉ dùng phần
  tử sơ cấp và toán tử ba ngôi (ngspice không có hàm `if()`/`delay()`).
- Có một điểm manual cần hỏi giảng viên: manual ghi "ground C0" cho phép trừ của
  bộ cộng/trừ 4 bit, trong khi phép trừ bù hai cần `Cin = 1` khi trừ. Code dùng
  `Cin = Sel`; xem [`LAB_3/README.md`](LAB_3/README.md).

## Nội dung repo

Repo mang **mã thiết kế và tài liệu**:

| Loại file | Ví dụ |
|---|---|
| Mô hình SystemVerilog | `full_adder.sv`, `dff74ls74.sv`, `counter_0_7.sv`, `fsm_fig34.sv`, `tb.sv`, `top_module.sv` |
| Ràng buộc chân bo | `Nexys-A7-100T-Master.xdc` |
| Project Vivado + bitstream | `project_*/…/top_module.bit` |
| Sơ đồ Logisim | `*.circ` (dùng IC thật của thư viện TTL, mở trực tiếp được) |
| Netlist SPICE | `*.cir` (chạy được bằng cả LTspice lẫn ngspice) |
| Tài liệu | `README.md`, `REPORT_EVIDENCE.md`, `LAB_3/IC_REFERENCE.md` |

Các **script công cụ** (`tools/*.py`), **ảnh sinh tự động** (`*.png`) và **bảng kết quả
thô** (`logisim_table.txt`, `spice_table_*.txt`, `logisim_vectors.txt`) được giữ ở máy
cá nhân của tác giả, **không đưa lên repo**; chúng có thể sinh lại từ mã thiết kế và
netlist có sẵn trong repo.
