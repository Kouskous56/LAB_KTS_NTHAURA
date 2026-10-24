# EX_09 — MUX-DEMUX pair (định tuyến dữ liệu)

## Khái niệm
Kết hợp MUX và DEMUX để định tuyến dữ liệu từ một trong N nguồn đến một trong M đích.
- MUX chọn một nguồn từ N đầu vào.
- DEMUX định tuyến dữ liệu đến một trong M đầu ra.

## Code SystemVerilog
```systemverilog
module mux_demux_pair (
    input  logic [3:0] din,
    input  logic [1:0] sel_mux, sel_demux,
    output logic [3:0] dout,
    output logic routed
);
    logic mid;
    mux4to1 u_mux (.d(din), .sel(sel_mux), .y(mid));
    demux1to4 u_demux (.d(mid), .sel(sel_demux), .y(dout));
    assign routed = mid;
endmodule
```

## Ứng dụng
- Bus routing trong hệ thống số.
- Chuyển mạch dữ liệu (data switching).
- Mạng truyền thông (communication networks).
