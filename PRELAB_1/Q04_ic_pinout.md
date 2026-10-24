# Cau 4: Bang pinout cac IC

| IC | Chuc nang | Pin (14 chan: VCC=14, GND=7; 16 chan: VCC=16, GND=8) |
|---|---|---|
| 74LS00 | 4 NAND 2 dau vao | 3=1 NAND 2; 6=4 NAND 5; 8=9 NAND 10; 11=12 NAND 13 |
| 74LS02 | 4 NOR 2 dau vao (pinout dac biet) | 1=2 NOR 3; 4=5 NOR 6; 10=8 NOR 9; 13=11 NOR 12 (output o chan 1,4,10,13) |
| 74LS04 | 6 NOT | 2=NOT1; 4=NOT3; 6=NOT5; 8=NOT9; 10=NOT11; 12=NOT13 |
| 74LS08 | 4 AND 2 dau vao | 3=1 AND 2; 6=4 AND 5; 8=9 AND 10; 11=12 AND 13 |
| 74LS32 | 4 OR 2 dau vao | 3=1 OR 2; 6=4 OR 5; 8=9 OR 10; 11=12 OR 13 |
| 74LS86 | 4 XOR 2 dau vao | 3=1 XOR 2; 6=4 XOR 5; 8=9 XOR 10; 11=12 XOR 13 |
| 74LS125 | 4 buffer 3-state, enable active LOW | enable: 1,4,10,13; input: 2,5,9,12; output: 3,6,8,11 |
| 74LS126 | 4 buffer 3-state, enable active HIGH | enable: 1,4,10,13; input: 2,5,9,12; output: 3,6,8,11 |
| 74LS138 | 3-to-8 decoder | A0=1,A1=2,A2=3; E0=4, E1bar=5, E2bar=6; Q0..Q7 = 15,14,13,12,11,10,9,7 (active low); VCC=16,GND=8 |
| 74LS151 | 8-to-1 MUX | D0..D7 = 4,3,2,1,15,14,13,12; A=11,B=10,C=9; Sbar=7; Y=5,W=6; VCC=16,GND=8 |

Luu y: 74LS00, 08, 32, 86 cung pinout (input 1&2, output 3). 74LS02 (NOR) khac: output chan 1, inputs chan 2&3.
