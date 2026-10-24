# EX_06 ? Priority Encoder 4-to-2

## Kh?i ni?m
Priority Encoder m? h?a ??u v?o ?u ti?n cao nh?t th?nh m? nh? ph?n.
- ?u ti?n: d[3] > d[2] > d[1] > d[0].
- Output valid = 1 khi c? ?t nh?t m?t input active.
- N?u kh?ng c? input active, valid = 0.

## Code SystemVerilog
```systemverilog
module prienc4to2 (input logic [3:0] d, output logic [1:0] y, output logic valid);
    always_comb begin
        if (d[3]) begin y = 2'b11; valid = 1'b1; end
        else if (d[2]) begin y = 2'b10; valid = 1'b1; end
        else if (d[1]) begin y = 2'b01; valid = 1'b1; end
        else if (d[0]) begin y = 2'b00; valid = 1'b1; end
        else begin y = 2'b00; valid = 1'b0; end
    end
endmodule
```

## ?ng d?ng
- IC 74LS147 (10-to-4 priority encoder).
- Interrupt controller (ch?n interrupt c? ?u ti?n cao nh?t).
- Keyboard encoder.
