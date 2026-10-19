`timescale 1ns/1ps
// tao la verilog haha
module f_bool (
    input  logic a, b, c,  // 3 ngõ vào từ Switch
    output logic f         // 1 ngõ ra logic
);
    // Gán phương trình logic: f = (~a & b) | (~b | c)
    assign f = (~a & b) | (~b | c);
endmodule