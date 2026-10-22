# Tham chiếu IC TTL 74LS — dùng cho Lab 3

Tất cả thông số dưới đây đã đối chiếu **datasheet chính thức Texas Instruments** (tải và đọc trực tiếp
từ ti.com) và một nguồn độc lập, rồi so với hình vẽ trong manual (Figure 3.2, 3.3, 3.5).

Nguồn:
- TI SN74LS74A: https://www.ti.com/lit/ds/symlink/sn74ls74a.pdf
- TI SN74LS283: https://www.ti.com/lit/ds/symlink/sn74ls283.pdf
- TI product page SN74LS74A: https://www.ti.com/product/SN74LS74A
- TI product page SN74LS283: https://www.ti.com/product/SN74LS283
- Bảng chân 74HC74/74LS74 (nguồn độc lập): https://www.build-electronic-circuits.com/7400-series-integrated-circuits/74hc74-74ls74/

---

## 1. 74LS74 — Dual D-type positive-edge-triggered flip-flop with preset and clear

DIP-14. Mỗi vi mạch chứa **2** flip-flop độc lập.

### Pin configuration (TOP VIEW) — khớp 100% với Figure 3.3 của manual

| Chân | Tín hiệu | Chân | Tín hiệu |
|---|---|---|---|
| 1 | 1CLR̅ | 14 | VCC |
| 2 | 1D | 13 | 2CLR̅ |
| 3 | 1CLK | 12 | 2D |
| 4 | 1PR̅ | 11 | 2CLK |
| 5 | 1Q | 10 | 2PR̅ |
| 6 | 1Q̅ | 9 | 2Q |
| 7 | GND | 8 | 2Q̅ |

### Function table (khớp với Figure 3.5 của manual)

| PR̅ | CLR̅ | CLK | D | Q | Q̅ |
|---|---|---|---|---|---|
| L | H | X | X | H | L |
| H | L | X | X | L | H |
| L | L | X | X | H ↑ | H ↑ |
| H | H | ↑ | H | H | L |
| H | H | ↑ | L | L | H |
| H | H | L | X | Q₀ | Q̅₀ |

Chú thích Note 1 của TI: *"this configuration is nonstable; that is, it will not persist when either
the preset or clear inputs return to their inactive (HIGH) level."*

### Đặc tính quan trọng
- Kích thích **cạnh lên** (positive-going transition) — đúng như manual nhấn mạnh.
- PR/CLR là **bất đồng bộ theo mức**: TI viết rõ *"A low level at the preset or clear inputs sets or
  resets the outputs regardless of the levels of the other inputs"* → mô hình SystemVerilog phải
  cho PRE/CLR tác động theo mức, không phải chỉ theo cạnh.
- Khi PR=CLR=0 → **nonstable**: cả Q và Q' lên 1 (đã mô hình hoá đúng trong `dff74ls74.sv`).
- Điện trở vào (LS series): I_IL max −0,4 mA → R_eq nom ≈ 20 kΩ; I_OH max −0,4 mA, I_OL max 8 mA.
- t_pd 10–50 ns, f_max 35 MHz.

---

## 2. 74LS283 — 4-bit binary full adder with fast carry

DIP-16. Bổ sung hai số 4 bit, có carry-in **C0** và carry-out **C4**.

### Pin configuration (TOP VIEW) — khớp 100% với Figure 3.2 của manual

| Chân | Tín hiệu | Chân | Tín hiệu |
|---|---|---|---|
| 1 | Σ2 | 16 | VCC |
| 2 | B2 | 15 | B3 |
| 3 | A2 | 14 | A3 |
| 4 | Σ1 | 13 | Σ3 |
| 5 | A1 | 12 | A4 |
| 6 | B1 | 11 | B4 |
| 7 | **C0** | 10 | Σ4 |
| 8 | GND | 9 | **C4** |

### Bảng chức năng (rút gọn theo logic symbol của datasheet)
- Khi **C0 = L**: Σ = A + B, C4 = carry ra.
- Khi **C0 = H**: Σ = A + B + 1, C4 = carry ra.
- Bảng chức năng đầy đủ 16 dòng × 10 cột được chia theo "WHEN C0 = L" và "WHEN C0 = H";
  note của TI: *"Input conditions at A1, B1, A2, B2, and C0 are used to determine outputs Σ1 and Σ2 and
  the value of the internal carry C2. The values at C2, A3, B3, A4, and B4 are then used to determine
  outputs Σ3, Σ4, and C4."*

### Đặc tính quan trọng — cảnh báo so với manual
- TI ghi rõ: *"These improved full adders perform the addition of two 4-bit binary words... These
  adders feature **full internal look-ahead across all four bits** generating the carry term in ten
  nanoseconds... This capability provides the system designer with partial look-ahead performance at
  the economy and reduced package count of a **ripple-carry** implementation."*
  → Manual gọi 74LS283 là "ripple-carry adder" là **không chính xác về mạch nội bộ**; nó có
  look-ahead toàn bộ 4 bit, chỉ *hiệu quả tương đương* ripple ở mức hệ thống.
  Hình Figure 3.1 (4 khối FULL ADDER nối dây carry) mới thật sự là ripple-carry thuần.
- `'283`/`'LS283` tương đương với `'83A`/`'LS83A`, chỉ khác thứ tự chân.
- Add time: '283 23/43 ns, 'LS283 25/45 ns, 'S283 15/30 ns.

### Về câu "Remember to ground C0" trong manual (mâu thuẫn cần hỏi giảng viên)
Phép trừ `A − B` theo phương pháp bù hai cần `A + ~B + 1`, tức là **C0 phải bằng 1** ở chế độ trừ.
Nếu nối cứng C0 xuống đất thì chế độ trừ không thể hoạt động đúng.
Cách làm kinh điển với 74LS283 + 74LS86:
- 4 cổng XOR (74LS86) đảo B khi `Sel = 1`: `B' = B ⊕ Sel`
- `C0 = Sel` (0 khi cộng, 1 khi trừ)
Đó chính là cách mình cài trong `full_addsub_4bit.sv` và `addsub_4bit_fa.sv`.

---

## 3. 74LS86 / 74LS08 / 74LS32 — cổng logic 4 ngõ

DIP-14, nguồn +5V, mức logic TTL chuẩn (0,3 V / 2,7 V).

| IC | Hàm | Dùng cho |
|---|---|---|
| 74LS86 | XOR 4 ngõ | T1 = A⊕B, S = T1⊕Ci; đảo B khi trừ (4 cổng) |
| 74LS08 | AND 4 ngõ | C1 = A·B, C2 = T1·Ci |
| 74LS32 | OR 4 ngõ | Co = C1 + C2 |

**Full adder 1 bit bằng IC thực tế**: 2 cổng XOR (1/2 vi mạch 74LS86) + 2 cổng AND (1/2 74LS08)
+ 1 cổng OR (1/4 74LS32) → tổng 1 vi mạch 74LS86 + 1 vi mạch 74LS08 + 1 vi mạch 74LS32 cho cả 4 tầng
trong một bộ cộng 4 bit.

---

## 4. Bộ đếm 0→7 dùng 74LS74 (ripple / bất đồng bộ)

Vì 74LS74 kích thích **cạnh lên**, tầng sau phải lấy đồng hồ từ **đầu ra đảo Q'** của tầng trước:

```
D0 = ~Q0,  D1 = ~Q1,  D2 = ~Q2
CLK0 = clk,  CLK1 = Q0',  CLK2 = Q1'
```

- Q0' lên khi Q0 rơi → Q1 tăng mỗi 2 xung
- Q1' lên khi Q1 rơi → Q2 tăng mỗi 4 xung
→ chuỗi đếm 0,1,2,…,7,0,…

Đây chính là mạch trong `counter_0_7.sv` (PRELS74 cho phép dùng 2 vi mạch cho 3 FF).

**Hai ngõ A, B trong Experiment 4**: manual không giải thích vai trò. Diễn giải hợp lý nhất (và khớp
với trình tự thí nghiệm "A=0,B=1 → A=1,B=0 → A=B=1 thì mới quan sát được đếm") là A và B là
**enable cho tầng LSB và tầng kế tiếp**:
- `A=0,B=1`: LSB đứng → bộ đếm đứng yên
- `A=1,B=0`: chỉ LSB lật → 0,1,0,1,…
- `A=B=1`: đếm đủ 0→7

Cần xác nhận với giảng viên ở bàn thực hành trước khi diễn giải số đo.

---

## 5. Analog Discovery Studio (WaveForms)

Từ Appendix 1 của manual:
- Cắm kit, mở **WaveForms**, kiểm tra status bar góc phải dưới hiện tên thiết bị + S/N.
- **Supplies**: đặt điện áp, nối chân V+ / V−, bật Master Enable và supply tương ứng.
- **Scope**: nối 1+/1−, 2+/2− và **luôn nối chân Ground (↓)**.
- **Wavegen**: chọn dạng sóng, tần số, biên độ; xuất ở W1 / W2.
- **Digital Pattern Generator** (Experiment 4): Add channels → Signal → DIOx (x = 0..15),
  Output = **PP (Push-Pull)**, Type = **Clock**, đổi tần số 1 Hz → 10 Hz → 100 Hz → … và quan sát
  khi nào mắt không kịp thấy số đếm đổi.
- Tạo cạnh lên clock: gạt switch từ 0 sang 1 (theo ghi chú manual ở Table 3.5).
- Nối CLK và X vào hai DIO cấu hình làm switch (Experiment 5).

## 6. Tóm tắt những chỗ manual sai/lệch đã phát hiện

| # | Manual | Thực tế (đã kiểm chứng) |
|---|---|---|
| 1 | "74LS283 is an IC 4-bit **ripple-carry** adder" | Có **full internal look-ahead** 4 bit (TI); chỉ tương đương ripple ở mức hệ thống |
| 2 | "Remember to **ground C0**" (Experiment 2) | Phép trừ cần C0 = 1; nối đất cứng là mâu thuẫn → cần hỏi giảng viên |
| 3 | Table 3.2 thiếu dòng `D=11, X=0` | Figure 3.4 có mũi tên D → A khi X=0, đã bổ sung |
| 4 | A, B ở Experiment 4 không được giải thích | Nhiều khả năng là enable từng tầng, cần xác nhận |
| 5 | — | Figure 3.5 (PRE=CLR=0) cho Q=Q'=1 (nonstable), đã mô hình hoá đúng |
