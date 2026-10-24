# PRELAB 5 — Bài 5 phần chuẩn bị (FPGA)

Nguồn: manual "Lab 5", phần A. PRELAB (PDF pp. 89-97).

Nội dung: chia clock 100 MHz→1 Hz, FSM điều khiển thủ công, FSM chế độ tự động,
sơ đồ nối Pmod JA với 6 LED, và multiplex 7 đoạn 2 digit.

## Danh sách

| File | Nội dung |
|---|---|
| [PREP1_clock_divider.md](PREP1_clock_divider.md) | Prep 1: Bộ chia clock 100 MHz→1 Hz |
| [PREP2_fsm_manual.md](PREP2_fsm_manual.md) | Prep 2: FSM điều khiển thủ công (Part II) |
| [PREP3_fsm_auto.md](PREP3_fsm_auto.md) | Prep 3: FSM chế độ tự động (Part III) |
| [PREP4_pmod_ja.md](PREP4_pmod_ja.md) | Prep 4: Sơ đồ nối Pmod JA với 6 LED (Part IV) |
| [PREP5_seg7_mux.md](PREP5_seg7_mux.md) | Prep 5: Multiplex 7 đoạn 2 digit (Part V) |

## Pin assignment (Nexys A7-100T)

- SW[0]=direction (0=NS go, 1=EW go), SW[1]=mode (0=manual, 1=auto).
- BTNC = reset (active-high).
- CLK100MHZ = clock 100 MHz.
- JA1=NS_GREEN, JA2=NS_YELLOW, JA3=NS_RED, JA4=EW_GREEN, JA7=EW_YELLOW, JA8=EW_RED.
- CA..CG = segments (active-low), AN[0]=digit 0, AN[1]=digit 1.
