# PREP 5 ? IC Decoder 74LS138, f = ?(0,2,5,7)

## M?c ti?u
Vi?t code SystemVerilog m? t? ho?t ??ng c?a 74LS138 (3-to-8 decoder) v? d?ng n?
?? tri?n khai h?m f(x,y,z) = ?(0,2,5,7).

## 74LS138 ? 3-to-8 Decoder/Demultiplexer

**Pinout (16 ch?n):**
- VCC = 16, GND = 8.
- Address A0, A1, A2: ch?n 1, 2, 3 (A0 l? LSB).
- Enable: E0 (active HIGH) = ch?n 4, E1bar (active LOW) = ch?n 5, E2bar (active LOW) = ch?n 6.
- Outputs Q0..Q7 (active LOW): ch?n 15, 14, 13, 12, 11, 10, 9, 7.

**B?ng ch?c n?ng (r?t g?n):**

| E0 | E1bar | E2bar | A2 A1 A0 | Q0..Q7 |
|---|---|---|---|---|
| H | X | X | X X X | all H |
| X | H | X | X X X | all H |
| X | X | L | X X X | all H |
| L | L | L | 0 0 0 | Q0 = L |
| L | L | L | 0 0 1 | Q1 = L |
| L | L | L | 0 1 0 | Q2 = L |
| L | L | L | 0 1 1 | Q3 = L |
| L | L | L | 1 0 0 | Q4 = L |
| L | L | L | 1 0 1 | Q5 = L |
| L | L | L | 1 1 0 | Q6 = L |
| L | L | L | 1 1 1 | Q7 = L |

Output t?ch c?c m?c th?p (active LOW): khi ???c ch?n, output = 0; c?c output kh?c = 1.

## Ph?n t?ch f = ?(0,2,5,7)

- m0: 000 ? Q0bar = 0
- m2: 010 ? Q2bar = 0
- m5: 101 ? Q5bar = 0
- m7: 111 ? Q7bar = 0

V? output active LOW, ?? c? f = 1 t?i c?c minterm n?y:
f = NOT( Q0bar AND Q2bar AND Q5bar AND Q7bar )
(d?ng c?ng NAND 4 ??u v?o, ho?c k?t h?p NAND 2 ??u v?o).

## Code SystemVerilog

Module m? t? 74LS138:

```systemverilog
module dec74ls138 (
    input  logic [2:0] a,
    input  logic       e1, e2_n, e3_n,
    output logic [7:0] y_n  // active low outputs
);
    always @(*) begin
        if (e1 && !e2_n && !e3_n)
            y_n = ~(8'b1 << a);
        else
            y_n = 8'hFF;
    end
endmodule
```

Module tri?n khai h?m:

```systemverilog
module f_dec74ls138 (
    input  logic x, y, z,
    output logic f
);
    logic [2:0] a = {x, y, z};  // A2=x, A1=y, A0=z
    logic [7:0] y_n;
    dec74ls138 u (.a(a), .e1(1'b1), .e2_n(1'b0), .e3_n(1'b0), .y_n(y_n));
    // f = NAND of Q0bar,Q2bar,Q5bar,Q7bar
    assign f = ~(y_n[0] & y_n[2] & y_n[5] & y_n[7]);
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
    f_dec74ls138 u (.x(x), .y(y), .z(z), .f(f));
    assign LED[2:0]  = SW[2:0];
    assign LED[15]   = f;
    assign LED[14:3] = 12'b0;
endmodule
```

## B?ng ch?n l?

| x | y | z | f |
|---|---|---|---|
| 0 | 0 | 0 | 1 |
| 0 | 0 | 1 | 0 |
| 0 | 1 | 0 | 1 |
| 0 | 1 | 1 | 0 |
| 1 | 0 | 0 | 0 |
| 1 | 0 | 1 | 1 |
| 1 | 1 | 0 | 0 |
| 1 | 1 | 1 | 1 |

## B?nh lu?n / Nh?n x?t
- 74LS138 l? decoder active-LOW: khi ???c enable, output t??ng ?ng minterm xu?ng m?c 0, c?c output kh?c ? m?c 1.
- ?? c? f = OR c?a c?c minterm, d?ng NAND c?c output active-low t??ng ?ng (v? NOT(AND of active-low) = OR).
- N?u c?n enable/disable decoder, ?i?u khi?n E0 (active HIGH) ho?c E1bar/E2bar (active LOW).
