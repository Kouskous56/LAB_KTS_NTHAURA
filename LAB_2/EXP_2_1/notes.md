# EXP_2_1 — Full Adder (Table 2.2)

## Hàm
f = x'yz + (xy)'z + xy  (không rút gọn, đúng manual)
Rút gọn: f = xy + z  (theo testbench/README).

## Truth table (Table 2.2)
x y z | f
0 0 0 | 0
0 0 1 | 1
0 1 0 | 0
0 1 1 | 1
1 0 0 | 0
1 0 1 | 1
1 1 0 | 1
1 1 1 | 1

## IC / cổng
- Dùng cổng logic cơ bản (NOT, AND, OR). Rút gọn: 1×74LS08 (AND) + 1×74LS32 (OR).

## Pin (Nexys A7)
- SW[2]=x, SW[1]=y, SW[0]=z; LED[15]=f; LED[2:0] hiển thị input.

## Bình luận
- Testbench kiểm tra cả dạng không rút gọn và dạng rút gọn cho khớp nhau.
- RTL Viewer sau synthesis sẽ cho thấy mạch được tối giản thành xy + z.
