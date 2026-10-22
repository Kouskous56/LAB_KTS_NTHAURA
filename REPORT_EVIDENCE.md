# Báo cáo minh chứng

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
python tools\verify_all.py -o REPORT_EVIDENCE.md
```

## Kết quả kiểm tra
| Bài | iverilog | Logisim | SPICE (LTspice/ngspice) | .bit | ảnh |
|---|---|---|---|---|---|
| EXP_2_1 - Full Adder (Table 2.2) | PASS | PASS | PASS/PASS | có | 3 |
| EXP_2_2 - F = sum m(0,1,3,4,7) | PASS | PASS | PASS/PASS | có | 3 |
| EXP_2_3 - Figure 2.4, F = x&~y | PASS | PASS | PASS/PASS | có | 3 |
| EXP_2_4 - 74LS151, f = sum m(1,2,4,7) | PASS | PASS | PASS/PASS | có | 3 |
| EXP_2_5 - 74LS138, f = sum m(0,2,5,7) | PASS | PASS | PASS/PASS | có | 3 |
| LAB_3 EXP_1 - Full Adder (Table 3.3) | PASS | PASS | PASS/PASS | - | 4 |
| LAB_3 EXP_2 - 4-bit Adder/Subtractor | PASS | PASS | PASS/PASS | - | 4 |
| LAB_3 EXP_3 - D flip-flop 74LS74 (Table 3.5) | PASS | PASS (vector) | PASS/PASS | - | 3 |
| LAB_3 EXP_4 - Bộ đếm 0 đến 7 | PASS | PASS (vector) | PASS/PASS | - | 4 |
| LAB_3 EXP_5 - Máy trạng thái (Figure 3.6) | PASS | PASS (vector) | PASS/PASS | - | 4 |
| PRELAB_3 - Full Adder (Table 3.1) | PASS | PASS | PASS/PASS | - | 4 |
| PRELAB_3 - 4-bit Adder/Subtractor (Table 3.4) | PASS | PASS | PASS/PASS | - | 4 |
| PRELAB_3 - Bộ đếm 0 đến 7 | PASS | PASS (vector) | PASS/PASS | - | 4 |
| PRELAB_3 - Máy trạng thái (Figure 3.4) | PASS | PASS (vector) | PASS/PASS | - | 4 |

- iverilog: **14/14** project PASS
- Logisim: **14/14** project có bảng chân lý đúng
- SPICE: **14/14** project PASS ở cả LTspice và ngspice
- Bitstream: **5/14** project có file `.bit` (chỉ LAB_2, chương 3 không build .bit)

## File minh chứng từng bài

| Bài | File minh chứng |
|---|---|
| EXP_2_1 - Full Adder (Table 2.2) | Logisim: `exp_2_1.circ`<br>`logisim_table.txt`<br>SPICE: `exp_2_1.cir`<br>`spice_table_ltspice.txt`, `spice_table_ngspice.txt`<br>ảnh: `logic_diagram.png`, `wave.png`, `spice_wave.png` |
| EXP_2_2 - F = sum m(0,1,3,4,7) | Logisim: `exp_2_2.circ`<br>`logisim_table.txt`<br>SPICE: `exp_2_2.cir`<br>`spice_table_ltspice.txt`, `spice_table_ngspice.txt`<br>ảnh: `logic_diagram.png`, `wave.png`, `spice_wave.png` |
| EXP_2_3 - Figure 2.4, F = x&~y | Logisim: `exp_2_3.circ`<br>`logisim_table.txt`<br>SPICE: `exp_2_3.cir`<br>`spice_table_ltspice.txt`, `spice_table_ngspice.txt`<br>ảnh: `logic_diagram.png`, `wave.png`, `spice_wave.png` |
| EXP_2_4 - 74LS151, f = sum m(1,2,4,7) | Logisim: `mux_74ls151.circ`<br>`logisim_table.txt`<br>SPICE: `mux_74ls151.cir`<br>`spice_table_ltspice.txt`, `spice_table_ngspice.txt`<br>ảnh: `logic_diagram.png`, `wave.png`, `spice_wave.png` |
| EXP_2_5 - 74LS138, f = sum m(0,2,5,7) | Logisim: `dec_74ls138.circ`<br>`logisim_table.txt`<br>SPICE: `dec_74ls138.cir`<br>`spice_table_ltspice.txt`, `spice_table_ngspice.txt`<br>ảnh: `logic_diagram.png`, `wave.png`, `spice_wave.png` |
| LAB_3 EXP_1 - Full Adder (Table 3.3) | Logisim: `full_adder.circ`<br>`logisim_table.txt`<br>SPICE: `full_adder.cir`<br>`spice_table_ltspice.txt`, `spice_table_ngspice.txt`<br>ảnh: `logic_diagram.png`, `application_circuit.png`, `wave.png`, `spice_wave.png` |
| LAB_3 EXP_2 - 4-bit Adder/Subtractor | Logisim: `adder4.circ`<br>`logisim_table.txt`<br>SPICE: `adder4.cir`<br>`spice_table_ltspice.txt`, `spice_table_ngspice.txt`<br>ảnh: `logic_diagram.png`, `application_circuit.png`, `wave.png`, `spice_wave.png` |
| LAB_3 EXP_3 - D flip-flop 74LS74 (Table 3.5) | Logisim: `dff74ls74.circ`<br>`logisim_table.txt`<br>SPICE: `dff74ls74.cir`<br>`spice_table_ltspice.txt`, `spice_table_ngspice.txt`<br>ảnh: `logic_diagram.png`, `wave.png`, `spice_wave.png` |
| LAB_3 EXP_4 - Bộ đếm 0 đến 7 | Logisim: `counter_0_7.circ`<br>`logisim_table.txt`<br>SPICE: `counter_0_7.cir`<br>`spice_table_ltspice.txt`, `spice_table_ngspice.txt`<br>ảnh: `logic_diagram.png`, `application_circuit.png`, `wave.png`, `spice_wave.png` |
| LAB_3 EXP_5 - Máy trạng thái (Figure 3.6) | Logisim: `fsm_fig34.circ`<br>`logisim_table.txt`<br>SPICE: `fsm_fig34.cir`<br>`spice_table_ltspice.txt`, `spice_table_ngspice.txt`<br>ảnh: `logic_diagram.png`, `state_diagram.png`, `wave.png`, `spice_wave.png` |
| PRELAB_3 - Full Adder (Table 3.1) | Logisim: `full_adder.circ`<br>`logisim_table.txt`<br>SPICE: `full_adder.cir`<br>`spice_table_ltspice.txt`, `spice_table_ngspice.txt`<br>ảnh: `logic_diagram.png`, `application_circuit.png`, `wave.png`, `spice_wave.png` |
| PRELAB_3 - 4-bit Adder/Subtractor (Table 3.4) | Logisim: `adder4.circ`<br>`logisim_table.txt`<br>SPICE: `adder4.cir`<br>`spice_table_ltspice.txt`, `spice_table_ngspice.txt`<br>ảnh: `logic_diagram.png`, `application_circuit.png`, `wave.png`, `spice_wave.png` |
| PRELAB_3 - Bộ đếm 0 đến 7 | Logisim: `counter_0_7.circ`<br>`logisim_table.txt`<br>SPICE: `counter_0_7.cir`<br>`spice_table_ltspice.txt`, `spice_table_ngspice.txt`<br>ảnh: `logic_diagram.png`, `application_circuit.png`, `wave.png`, `spice_wave.png` |
| PRELAB_3 - Máy trạng thái (Figure 3.4) | Logisim: `fsm_fig34.circ`<br>`logisim_table.txt`<br>SPICE: `fsm_fig34.cir`<br>`spice_table_ltspice.txt`, `spice_table_ngspice.txt`<br>ảnh: `logic_diagram.png`, `state_diagram.png`, `wave.png`, `spice_wave.png` |

## Ghi chú

- Chương 3 (`LAB_3`, `PRELAB_3`) **không build `.bit`** theo yêu cầu, chỉ kiểm tra bằng `iverilog`.
  Riêng `LAB_2` có đủ 5 file `.bit` (đã nạp lên Nexys A7).
- Chế độ bảng chân lý của Logisim (`-tty table`) chỉ phân tích được **mạch tổ hợp**.
  Ba mạch tuần tự (D flip-flop, bộ đếm, máy trạng thái) được dựng bằng **IC thật**
  (74LS74, 74LS08, 74LS32) và kiểm bằng **chế độ test vector** (`logisim_vectors.txt`);
  hành vi đầy đủ được kiểm bằng mô phỏng SPICE và testbench `iverilog`.
- Chi tiết về cách dùng Logisim / LTspice / ngspice: `tools/README.md`.
