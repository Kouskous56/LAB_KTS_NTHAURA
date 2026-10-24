# PREP 3 ? M?ch H?nh 2.3 (F = x?z)

## M? t? m?ch (Figure 2.3)

M?ch g?m c?c c?ng logic v?i 3 input x, y, z v? 1 output F:

- **x** ? input tr?n c?ng OR (tr?i) v? input tr?n c?ng NAND (tr?n).
- **y** ? input tr?n c?ng AND v? input c?ng NOT.
- **z** ? input d??i c?ng AND v? input d??i c?ng NAND (d??i).

K?t n?i:
- Output AND ? input d??i OR (tr?i).
- Output OR ? input d??i NAND (tr?n).
- Output NOT (?) ? input tr?n NAND (d??i).
- Output NAND (tr?n) ? input tr?n NOR (ph?i).
- Output NAND (d??i) ? input d??i NOR (ph?i).
- Output NOR ? F.

## Ph?n t?ch logic

- OR (tr?i): X = x + y?z
- NAND (tr?n): Y = NOT(x ? (x+yz)) = NOT(x)   [v? x + xyz = x(1+yz) = x]
- NOT: ?
- NAND (d??i): Z = NOT(? ? z) = y + z?
- NOR (ph?i): F = NOT(Y + Z) = NOT(x? + y + z?) = x ? ? ? z

? **F = x?z** (minterm m5 n?u x l? MSB, z l? LSB).

## Code SystemVerilog (theo y?u c?u Prep 3)

```systemverilog
module prep3 (
    input  logic x, y, z,
    output logic f
);
    // F = x & ~y & z
    assign f = x & ~y & z;
endmodule
```

Wrapper (top-level) cho Nexys A7:

```systemverilog
module prep3_wrapper (
    input  logic [2:0] SW,
    output logic [15:0] LED
);
    logic f;
    prep3 u (.x(SW[2]), .y(SW[1]), .z(SW[0]), .f(f));
    assign LED[2:0]  = SW[2:0];
    assign LED[15]   = f;
    assign LED[14:3] = 12'b0;
endmodule
```

## B?ng ch?n l?

| x | y | z | F |
|---|---|---|---|
| 0 | 0 | 0 | 0 |
| 0 | 0 | 1 | 0 |
| 0 | 1 | 0 | 0 |
| 0 | 1 | 1 | 0 |
| 1 | 0 | 0 | 0 |
| 1 | 0 | 1 | 1 |
| 1 | 1 | 0 | 0 |
| 1 | 1 | 1 | 0 |

F = 1 ch? t?i minterm 5 (101).

## Pin assignment
- SW[2]=x, SW[1]=y, SW[0]=z; LED[2:0] hi?n th? input; LED[15]=f.
- Compile v? simulate: d?ng s?ng output ph?i hi?n th? t?t c? 8 t? h?p input.

## B?nh lu?n / Nh?n x?t
- M?ch H?nh 2.3 m?c d? c? nhi?u c?ng (OR, AND, NOT, NAND?2, NOR) nh?ng r?t g?n ch? l? m?t minterm ??n `x?z`. ??y l? v? d? t?t v? t?i gi?n m?ch logic.
- RTL Viewer sau synthesis s? cho th?y m?ch ???c t?i gi?n th?nh AND 3 ??u v?o + NOT, kh?ng ph?i to?n b? m?ch g?c.
