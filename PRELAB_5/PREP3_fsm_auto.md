# PREP 3 — FSM chế độ tự động (Part III)

## Chuỗi trạng thái và thời lượng

| State | Đèn NS | Đèn EW | Thời lượng | Next state |
|---|---|---|---:|---|
| NS_GREEN | xanh | đỏ | 5 s | NS_YELLOW |
| NS_YELLOW | vàng | đỏ | 2 s | EW_GREEN |
| EW_GREEN | đỏ | xanh | 5 s | EW_YELLOW |
| EW_YELLOW | đỏ | vàng | 2 s | NS_GREEN |

Timer được nạp khi vào state. Có thể dùng counter tăng đến duration hoặc đếm xuống.
Để mỗi state kéo dài chính xác N giây, tạo enable mỗi giây rồi transition sau đúng N enable events.

## Code SystemVerilog (FSM auto)

```systemverilog
module traffic_fsm_auto (
    input  logic clk,
    input  logic rst,
    input  logic tick_1s,
    output logic ns_g, ns_y, ns_r,
    output logic ew_g, ew_y, ew_r,
    output logic [3:0] timer
);
    typedef enum logic [1:0] {NS_G, NS_Y, EW_G, EW_Y} state_t;
    state_t state;
    logic [3:0] timer_reg;

    always_ff @(posedge clk) begin
        if (rst) begin
            state <= NS_G;
            timer_reg <= 4'd5;
        end else if (tick_1s) begin
            case (state)
                NS_G: begin
                    if (timer_reg == 4'd1) begin state <= NS_Y; timer_reg <= 4'd2; end
                    else timer_reg <= timer_reg - 4'd1;
                end
                NS_Y: begin
                    if (timer_reg == 4'd1) begin state <= EW_G; timer_reg <= 4'd5; end
                    else timer_reg <= timer_reg - 4'd1;
                end
                EW_G: begin
                    if (timer_reg == 4'd1) begin state <= EW_Y; timer_reg <= 4'd2; end
                    else timer_reg <= timer_reg - 4'd1;
                end
                EW_Y: begin
                    if (timer_reg == 4'd1) begin state <= NS_G; timer_reg <= 4'd5; end
                    else timer_reg <= timer_reg - 4'd1;
                end
            endcase
        end
    end

    // Output logic (Moore)
    always_comb begin
        ns_g = 0; ns_y = 0; ns_r = 0;
        ew_g = 0; ew_y = 0; ew_r = 0;
        case (state)
            NS_G: begin ns_g = 1; ew_r = 1; end
            NS_Y: begin ns_y = 1; ew_r = 1; end
            EW_G: begin ns_r = 1; ew_g = 1; end
            EW_Y: begin ns_r = 1; ew_y = 1; end
        endcase
    end

    assign timer = timer_reg;
endmodule
```

## Chế độ Manual/Auto tích hợp

Khi `SW[1]=0` chọn manual; `SW[1]=1` chọn auto, SW0 bị bỏ qua ở auto.
Manual không chỉ rõ nếu SW1 đổi giữa pha. Một chính sách kiểm thử được:
nhận mode mới ở tick 1 Hz kế tiếp, reset timer, đưa state đến hướng manual được chọn
hoặc NS_GREEN của auto; đảm bảo đèn an toàn trong đổi mode.

## Bình luận
- Khi kết hợp auto và manual, SW[1]=0 chọn manual; SW[1]=1 chọn auto, SW0 bị bỏ qua ở auto.
- Chốt quy ước timer để duration chính xác: vào Green với remaining=5; sau mỗi tick giây giảm một;
  khi đủ 5 giây chuyển Yellow. Cách trình bày trên LED có thể là 5→4→3→2→1, rồi pha kế tiếp ở ranh giới 5 giây.
- Không để đếm 5,4,3,2,1,0 mỗi số đủ 1 s rồi mới chuyển, vì khi đó pha kéo dài 6 s.
