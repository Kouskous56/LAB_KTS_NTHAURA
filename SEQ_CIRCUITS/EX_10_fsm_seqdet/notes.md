# EX_10 ? FSM (sequence detector)

## Kh?i ni?m
Finite State Machine (FSM) detecting sequence "101" (Mealy output).
- Mealy: output depends on state AND input.
- z=1 when the last bit of "101" is received.

## State diagram
- S0: initial state (no match)
- S1: received "1"
- S2: received "10"
- On receiving "1" in S2: output z=1, go to S1 (overlap)

## ?ng d?ng
- Sequence detector.
- Protocol parser.
- Pattern matching.
