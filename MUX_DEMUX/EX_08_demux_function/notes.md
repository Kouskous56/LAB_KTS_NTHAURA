# EX_08 — DEMUX as Boolean function generator

## Khái niệm
DEMUX có thể dùng để triển khai hàm Boolean. Với hàm 3 biến, dùng DEMUX 1-to-8:
- Select lines = các biến (x, y, z).
- Input d = 1 (constant).
- Output f = OR của các output DEMUX tại các vị trí minterm.

## Hàm
f = Σm(0,2,5,7) = x̄ȳžz + x̄yz̄ + xưyz + xyz
Bảng chân lý: 1,0,1,0,0,1,0,1.

## Code SystemVerilog
```systemverilog
module demux_function (input logic x, y, z, output logic f);
    logic [7:0] yout;
    demux1to8 u (.d(1'b1), .sel({x, y, z}), .y(yout));
    assign f = yout[0] | yout[2] | yout[5] | yout[7];
endmodule
```

## So sánh với MUX
- MUX: data inputs = giá trị hàm, select = biến, output = f.
- DEMUX: input = 1 (constant), select = biến, output = OR của các minterm.
- Cả hai đều có thể triển khai bất kỳ hàm Boolean nào.
