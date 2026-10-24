# LAB 1 ? Lab 1: Implementation of Boolean Function on Breadboard

Nguon: manual "Lab 1", phan B. LAB MANUAL (PDF pp. 12-20).

Noi dung: lap mach so tren breadboard, muc logic TTL, pinout cac IC 74LS,
thiet ke ham Boolean (AND-OR, NAND, NOR, MUX 74LS151, decoder 74LS138).

## Prelab
Cau tra loi Prelab 1 nam trong `PRELAB_1/` (Q01..Q12).

## Danh sach bai

| Bai | Noi dung | File chinh | Ket qua tb |
|---|---|---|---|
| EXP_1 | f = xbar.y + ybar.z (AND-OR va NAND) | func_and_or.sv, func_nand.sv | ALL TESTS PASS |
| EXP_2 | Ham Boolean tu bang chan ly (Table 1.2) | func_exp2.sv | ALL TESTS PASS |
| EXP_3 | Mach cho san (Fig 1.6), toi gian F2 | func_f1.sv, func_f2.sv | ALL TESTS PASS |
| EXP_4 | f = Sigma(2,3,5,7) dung 74LS151 | func_exp4.sv, ic_74151.sv | ALL TESTS PASS |
| EXP_5 | f = Sigma(2,3,5,7) dung 74LS138 | func_exp5.sv, ic_74138.sv | ALL TESTS PASS |

## Pin assignment (Nexys A7-100T)
- Tat ca bai: SW[2]=x, SW[1]=y, SW[0]=z; LED[0]=f.

## Chay testbench
    cd LAB_1\EXP_1_and_or_nand
    iverilog -g2012 -o tb.vvp *.sv
    vvp tb.vvp

## Ghi chu
- Lab 1 la bai thuc hanh tren breadboard; phan SystemVerilog/FPGA la mo hinh hoa
  de kiem chung ham Boolean va IC.
- Prelab tra loi (Q1-Q12) nam trong PRELAB_1/.
