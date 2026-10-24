# EX_10 — Parametric N-to-1 MUX v? 1-to-N DEMUX

## Khái niệm
Sử dụng parameter để tạo MUX/DEMUX tổng quát với N đầu vào/đầu ra.
- N phải là lũy thừa của 2 (2, 4, 8, 16, ...).
- Số bit select = $clog2(N).

## Code SystemVerilog
```systemverilog
module mux_param #(parameter N = 8) (
    input  logic [N-1:0] d,
    input  logic [$clog2(N)-1:0] sel,
    output logic y
);
    assign y = d[sel];
endmodule

module demux_param #(parameter N = 8) (
    input  logic d,
    input  logic [$clog2(N)-1:0] sel,
    output logic [N-1:0] y
);
    always_comb begin
        y = '0;
        y[sel] = d;
    end
endmodule
```

## Ứng dụng
- Tái sử dụng code cho nhiều kích thước.
- FPGA: instantiate với N khác nhau trong cùng design.
- Software-defined hardware (parameterization).
