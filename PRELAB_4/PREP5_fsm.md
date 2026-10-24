# PREP 5 — FSM bốn trạng thái

## Mã hóa và next-state

| State hiện tại | Mã | X=0 → state/mã | X=1 → state/mã | Output Y |
|---|:---:|---|---|:---:|
| S0 | 00 | S0 / 00 | S1 / 01 | 00 |
| S1 | 01 | S2 / 10 | S0 / 00 | 10 |
| S2 | 10 | S3 / 11 | S2 / 10 | 11 |
| S3 | 11 | S0 / 00 | S3 / 11 | 01 |

Reset active-high đưa state về S0. Output phụ thuộc current_state, vì vậy đây là Moore machine.

## Code SystemVerilog

```systemverilog
module fsm_4state_core (
    input  logic clk,
    input  logic rst,       // active-high async reset
    input  logic x_in,
    output logic [1:0] y_out
);
    typedef enum logic [1:0] {S0=2'b00, S1=2'b01, S2=2'b10, S3=2'b11} state_t;
    state_t current_state, next_state;

    // State register (async reset)
    always_ff @(posedge clk or posedge rst) begin
        if (rst) current_state <= S0;
        else     current_state <= next_state;
    end

    // Next-state logic (combinational, must have default)
    always_comb begin
        unique case (current_state)
            S0: next_state = x_in ? S1 : S0;
            S1: next_state = x_in ? S0 : S2;
            S2: next_state = x_in ? S2 : S3;
            S3: next_state = x_in ? S3 : S0;
        endcase
    end

    // Output logic (Moore: depends on current_state only)
    always_comb begin
        unique case (current_state)
            S0: y_out = 2'b00;
            S1: y_out = 2'b10;
            S2: y_out = 2'b11;
            S3: y_out = 2'b01;
        endcase
    end
endmodule
```

## Top-level (Nexys A7-100T)

```systemverilog
module top_fsm_prep5 (
    input  logic        CLK100MHZ,
    input  logic        BTNC,       // reset active-high
    input  logic [0:0]  SW,         // SW[0] = x_in
    output logic [1:0]  LED          // LED[1:0] = y_out
);
    fsm_4state_core u (.clk(CLK100MHZ), .rst(BTNC), .x_in(SW[0]), .y_out(LED));
endmodule
```

## Kiểm tra
Cần kiểm tra chuỗi đầy đủ `S0→S1→S2→S3→S0` bằng input tương ứng `1,0,0,0`;
reset và quan sát output Y ở mỗi state.

## Bình luận
- Trong phần tổ hợp phải gán giá trị mặc định hoặc có `default` cho mỗi state; nếu không, có thể suy ra latch hoặc tạo state không xác định.
- Output phụ thuộc current_state, vì vậy đây là Moore machine; output đổi sau khi thanh ghi state cập nhật tại clock.
