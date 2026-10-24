# PREP 4 ? IC Multiplexer 74LS151, f = ?(1,2,4,7)

## M?c ti?u
Vi?t code SystemVerilog m? t? ho?t ??ng c?a 74LS151 (8-to-1 MUX) v? d?ng n?
?? tri?n khai h?m f(x,y,z) = ?(1,2,4,7).

## 74LS151 ? 8-to-1 Multiplexer

**Pinout (16 ch?n):**
- VCC = 16, GND = 8.
- Data inputs D0?D7: ch?n 4,3,2,1,15,14,13,12.
- Select A,B,C: ch?n 11,10,9 (C l? MSB).
- Strobe (enable) Sbar: ch?n 7 (active LOW).
- Output Y: ch?n 5; W (??o c?a Y): ch?n 6.

**B?ng ch?c n?ng:**

| C B A | Sbar | Y | W |
|---|---|---|---|
| X X X | H | L | H |
| L L L | L | D0 | D0bar |
| L L H | L | D1 | D1bar |
| L H L | L | D2 | D2bar |
| L H H | L | D3 | D3bar |
| H L L | L | D4 | D4bar |
| H L H | L | D5 | D5bar |
| H H L | L | D6 | D6bar |
| H H H | L | D7 | D7bar |

## Ph?n t?ch f = ?(1,2,4,7)

- m1: 001 ? x??z
- m2: 010 ? x?y?
- m4: 100 ? x??
- m7: 111 ? xyz

D?ng 74LS151: ch?n C=x, B=y, A=z. C?c ??u v?o d? li?u:
- D0=0, D1=1, D2=1, D3=0, D4=1, D5=0, D6=0, D7=1
- Strobe Sbar = 0 (enable).
- Output Y = f.

## Code SystemVerilog

Module m? t? 74LS151:

```systemverilog
module mux74ls151 (
    input  logic [7:0] d,
    input  logic [2:0] s,   // s = {C,B,A}
    input  logic       g_n,  // strobe, active low
    output logic       y,    // selected data
    output logic       w     // complement
);
    always @(*) begin
        if (g_n) begin y = 1'b0; w = 1'b1; end
        else begin y = d[s]; w = ~d[s]; end
    end
endmodule
```

Module tri?n khai h?m:

```systemverilog
module f_mux74ls151 (
    input  logic x, y, z,
    output logic f
);
    logic [7:0] d = 8'b10010110; // D7..D0 = I7..I0
    logic [2:0] s = {x, y, z};
    logic g_n = 1'b0;
    logic y_out, w_out;
    mux74ls151 u (.d(d), .s(s), .g_n(g_n), .y(y_out), .w(w_out));
    assign f = y_out;
endmodule
```

Wrapper (top-level) cho Nexys A7:

```systemverilog
module top_module (
    input  logic [2:0] SW,
    output logic [15:0] LED
);
    logic x, y, z, f;
    assign x = SW[2]; assign y = SW[1]; assign z = SW[0];
    f_mux74ls151 u (.x(x), .y(y), .z(z), .f(f));
    assign LED[2:0]  = SW[2:0];
    assign LED[15]   = f;
    assign LED[14:3] = 12'b0;
endmodule
```

## B?ng ch?n l?

| x | y | z | f |
|---|---|---|---|
| 0 | 0 | 0 | 0 |
| 0 | 0 | 1 | 1 |
| 0 | 1 | 0 | 1 |
| 0 | 1 | 1 | 0 |
| 1 | 0 | 0 | 1 |
| 1 | 0 | 1 | 0 |
| 1 | 1 | 0 | 0 |
| 1 | 1 | 1 | 1 |

## B?nh lu?n / Nh?n x?t
- 74LS151 l? IC ?a n?ng: ch? c?n n?i data input D0-D7 theo minterm (1 = n?i VCC, 0 = n?i GND) l? c? th? tri?n khai b?t k? h?m 3 bi?n n?o.
- Strobe Sbar ph?i n?i GND ?? enable; n?u n?i VCC th? output Y = 0, W = 1 (disabled).
- Output W l? ??o c?a Y, c? th? d?ng n?u c?n h?m ph? ??nh.
