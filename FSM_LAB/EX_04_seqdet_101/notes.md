# EX_04 ? Sequence detector "101" (Mealy, overlapping)

## Kh?i ni?m
FSM ph?t hi?n m?u "101" trong chu?i bit (Mealy output).
- Mealy: output ph? thu?c state + input.
- z=1 khi bit cu?i c?a "101" ???c nh?n.
- Overlapping: sau khi ph?t hi?n, quay v? S1 (v? bit cu?i "1" c? th? l? b?t ??u m?i).

## State diagram
- S0: tr?ng th?i ban ??u (ch?a match)
- S1: ?? nh?n "1"
- S2: ?? nh?n "10"
- Nh?n "1" ? S2: output z=1, chuy?n S1 (overlap)

## ?ng d?ng
- Sequence detector.
- Protocol parser.
- Pattern matching.
