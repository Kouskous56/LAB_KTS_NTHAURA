# EX_04 — MUX as Boolean function generator

## Khái niệm
MUX có thể dùng để triển khai bất kỳ hàm Boolean nào. Với hàm 3 biến, dùng MUX 8-to-1:
- Select lines = các biến (x, y, z).
- Data inputs D0-D7 = giá trị hàm tại từng minterm (0 hoặc 1).

## Hàm
f = Σm(2,3,5,7) = ~x.y + x.z
Bảng chân lý: 0,0,1,1,0,1,0,1.

## Data inputs
D0=0, D1=0, D2=1, D3=1, D4=0, D5=1, D6=0, D7=1
D7..D0 = 10100110

## Code SystemVerilog
```systemverilog
module mux_function (input logic x, y, z, output logic f);
    logic [7:0] d = 8'b10100110;
    assign f = d[{x, y, z}];
endmodule
```

## Ưu điểm
- Không cần tối giản hàm Boolean.
- Dễ thay đổi hàm (chỉ đổi data inputs).
- IC 74LS151 là MUX 8-to-1 với enable active-low.
