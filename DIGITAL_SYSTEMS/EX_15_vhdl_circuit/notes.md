# EX_15 — Mạch Tổ Hợp Từ VHDL (Câu 2)

## Khái niệm
Mạch tổ hợp được mô tả bằng VHDL, sử dụng mux2to1 và các tín hiệu trung gian.

## Mô tả VHDL
```vhdl
entity cau_2 is
    port( x : in  STD_LOGIC_VECTOR(3 downto 0);
          y : out  STD_LOGIC_VECTOR(2 downto 0));
end cau_2;

architecture comb of cau_2 is
    component mux2to1
        port ( a : in   STD_LOGIC_VECTOR(2 downto 0);
               b : in   STD_LOGIC_VECTOR(2 downto 0);
               s : in   STD_LOGIC;
               f  :  out STD_LOGIC_VECTOR(2  downto 0));
    end component;
    signal s_temp : STD_LOGIC;
    signal b_temp : STD_LOGIC_VECTOR(2 downto 0);
begin
    s_temp <= x(3) xor x(2);
    b_temp <= not(x(2)) & x(2) & x(2);   -- = 0 always
    U1: mux2to1 port map(
        a => x(2 downto 0),
        b => b_temp,
        s => s_temp,
        f => y
    );
end comb;
```

## Sơ đồ mạch

```
         ┌─────────────┐
x[3] ───┤             │
        │   XOR       ├── s_temp ──┐
x[2] ───┤             │           │
         └─────────────┘           │
                                    │
         ┌─────────────┐           │
x[2] ───┤             │           │
        │   NOT       ├──┐         │
         └─────────────┘  │         │
                          │         │
         ┌─────────────┐  │         │
x[2] ───┤             │  │         │
        │   AND       ├──┴─ b_temp │
x[2] ───┤             │            │
         └─────────────┘            │
                                    │
         ┌─────────────┐            │
x[2:0] ─┤             │            │
        │  mux2to1    │            │
b_temp ─┤  (a, b, s)  ├───────────┘
        │             │
        └──────┬──────┘
               │
               y[2:0]
```

## Phân tích

### Tín hiệu trung gian
- **s_temp** = x[3] XOR x[2]
- **b_temp** = NOT(x[2]) AND x[2] AND x[2] = 0 (luôn 0)

### Chức năng mux2to1
- Nếu s=0: f = a = x[2:0]
- Nếu s=1: f = b = b_temp = 0

### Bảng hoạt động

| x3 | x2 | x1 | x0 | s_temp | y2 | y1 | y0 |
|----|----|----|----|--------|----|----|----|
| 0  | 0  | 0  | 0  | 0      | 0  | 0  | 0  |
| 0  | 0  | 0  | 1  | 0      | 0  | 0  | 1  |
| 0  | 0  | 1  | 0  | 0      | 0  | 1  | 0  |
| 0  | 0  | 1  | 1  | 0      | 0  | 1  | 1  |
| 0  | 1  | 0  | 0  | 1      | 0  | 0  | 0  |
| 0  | 1  | 0  | 1  | 1      | 0  | 0  | 0  |
| 0  | 1  | 1  | 0  | 1      | 0  | 0  | 0  |
| 0  | 1  | 1  | 1  | 1      | 0  | 0  | 0  |
| 1  | 0  | 0  | 0  | 1      | 0  | 0  | 0  |
| 1  | 0  | 0  | 1  | 1      | 0  | 0  | 0  |
| 1  | 0  | 1  | 0  | 1      | 0  | 0  | 0  |
| 1  | 0  | 1  | 1  | 1      | 0  | 0  | 0  |
| 1  | 1  | 0  | 0  | 0      | 1  | 0  | 0  |
| 1  | 1  | 0  | 1  | 0      | 1  | 0  | 1  |
| 1  | 1  | 1  | 0  | 0      | 1  | 1  | 0  |
| 1  | 1  | 1  | 1  | 0      | 1  | 1  | 1  |

### Chức năng
- Khi x[3] = x[2] (s_temp=0): y = x[2:0] (truyền qua).
- Khi x[3] ≠ x[2] (s_temp=1): y = 0.
- Trong biểu diễn 2's complement 4-bit: x[3] là bit dấu. Khi x[3]=x[2], số không tràn (no overflow). Khi x[3]≠x[2], có tràn (overflow).
- Chức năng: **Kiểm tra tràn số (overflow detection)** trong biểu diễn 2's complement. Nếu có tràn, output = 0; nếu không, output = 3 bit thấp.

## Ứng dụng
- Overflow detection trong ALU.
- Kiểm tra tính hợp lệ của kết quả phép toán.
- Mạch bảo vệ trong hệ thống số.
