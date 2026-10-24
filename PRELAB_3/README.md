# PRELAB 3 — Bài 3 phần chuẩn bị

Nguồn: manual "Lab 3", phần A. PRELAB (PDF pp. 47-52).

Nội dung: Full Adder 1 bit, Adder/Subtractor 4 bit, flip-flop D 74LS74 + bộ đếm ripple
modulo 8, và máy trạng thái 4 trạng thái (Figure 3.4).

## Danh sách

| File | Nội dung |
|---|---|
| [PREP1_full_adder.md](PREP1_full_adder.md) | Prep 1: Full Adder 1 bit, S=A⊕B⊕Ci, Co=AB+ACi+BCi |
| [PREP2_addsub_4bit.md](PREP2_addsub_4bit.md) | Prep 2: Adder 4 bit (ripple/74LS283) và adder/subtractor |
| [PREP3_dff_counter.md](PREP3_dff_counter.md) | Prep 3: 74LS74 D-FF + bộ đếm ripple modulo 8 |
| [PREP4_fsm.md](PREP4_fsm.md) | Prep 4: FSM 4 trạng thái, next-state equations |

## Lưu ý quan trọng
- Adder/subtractor: mâu thuẫn C0 trong manual. C0 nên = Sel (chuẩn), không phải GND.
- FSM: Table 3.2 thiếu hàng D,X=0 → A; phải bổ sung từ sơ đồ trạng thái.
- D-FF: `/PRE` và `/CLR` active-low bất đồng bộ; không kéo cả hai xuống LOW cùng lúc.
