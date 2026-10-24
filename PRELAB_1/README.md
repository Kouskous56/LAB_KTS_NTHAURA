# PRELAB 1 ? B?i 1 ph?n chu?n b?

Nguon: manual "Lab 1", phan A. PRELAB (PDF pp. 2-11).

Noi dung: cach lap mach so tren breadboard, muc logic TTL, pinout cac IC 74LS,
va 12 cau hoi ve thiet ke ham Boolean (AND-OR, NAND, NOR, MUX 74LS151,
decoder 74LS138).

## Danh sach cau hoi

| File | Cau hoi |
|---|---|
| [Q01_numbering_principle.md](Q01_numbering_principle.md) | Nguyen tac danh so chan IC DIP |
| [Q02_identify_inputs.md](Q02_identify_inputs.md) | Xac dinh X, Y, Z, W trong 4 mach |
| [Q03_led_status.md](Q03_led_status.md) | Trang thai LED khi f1..f4 = 0,1,1,0 |
| [Q04_ic_pinout.md](Q04_ic_pinout.md) | Bang pinout cac IC (74LS00,02,04,08,32,86,125,126,138,151) |
| [Q05_compare_125_126.md](Q05_compare_125_126.md) | So sanh 74LS125 va 74LS126 |
| [Q06_func_and_or.md](Q06_func_and_or.md) | f = xbar.y + ybar.z (AND-OR) |
| [Q07_func_nand.md](Q07_func_nand.md) | f = xbar.y + ybar.z (NAND) |
| [Q08_func_sop.md](Q08_func_sop.md) | f = m1 + m3 + m6 (SOP) |
| [Q09_func_nor.md](Q09_func_nor.md) | f = m1 + m3 + m6 (NOR) |
| [Q10_given_circuit.md](Q10_given_circuit.md) | Phan tich mach cho san, toi gian F2 |
| [Q11_mux_74151.md](Q11_mux_74151.md) | f = Sigma(2,3,5,7) dung 74LS151 |
| [Q12_decoder_74138.md](Q12_decoder_74138.md) | f = Sigma(2,3,5,7) dung 74LS138 |

## Tom tat muc logic TTL

- Input HIGH: 2V-5V; LOW: 0-0.8V.
- Output HIGH: 2.7V-5V; LOW: 0-0.5V.
- Dung 5V cho HIGH, 0V cho LOW.
- Dien tro input: 10 kOhm; output LED: 1 kOhm.
