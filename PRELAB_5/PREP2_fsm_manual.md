# PREP 2 — FSM điều khiển thủ công (Part II)

## Trạng thái và đèn

| State | NS Green | NS Yellow | NS Red | EW Green | EW Yellow | EW Red | Ý nghĩa |
|---|---:|---:|---:|---:|---:|---:|---|
| NS_GO | 1 | 0 | 0 | 0 | 0 | 1 | NS hoạt động; giữ nếu SW0=0 |
| NS_WARN | 0 | 1 | 0 | 0 | 0 | 1 | SW0 chuyển sang 1; pha vàng 3 s |
| EW_GO | 0 | 0 | 1 | 1 | 0 | 0 | EW hoạt động; giữ nếu SW0=1 |
| EW_WARN | 0 | 0 | 1 | 0 | 1 | 0 | SW0 chuyển sang 0; pha vàng 3 s |

## Chuyển trạng thái

| State hiện tại | Điều kiện | State tiếp theo | Timer |
|---|---|---|---|
| NS_GO | SW0=0 | NS_GO | stable 9/blank |
| NS_GO | SW0=1 | NS_WARN | nạp 3 s |
| NS_WARN | chưa hết | NS_WARN | giảm theo tick 1 Hz |
| NS_WARN | hết 3 s | EW_GO | stable 9/blank |
| EW_GO | SW0=1 | EW_GO | stable 9/blank |
| EW_GO | SW0=0 | EW_WARN | nạp 3 s |
| EW_WARN | chưa hết | EW_WARN | giảm theo tick 1 Hz |
| EW_WARN | hết 3 s | NS_GO | stable 9/blank |

Reset: chọn NS_GO hoặc state theo SW0 (phải khai báo). Khi SW0 đổi trong lúc pha vàng,
dùng `target_direction` đã chốt khi bắt đầu pha, hoặc thiết kế/hướng dẫn cụ thể khác.

## Countdown manual

Mô tả nói đếm `3,2,1,0` trong 3 giây. Điểm timing dễ lệch:
- Nếu mỗi số được giữ trọn một giây, bốn số cần 4 giây.
- Thiết kế phổ biến: hiển thị 3 ngay khi bắt đầu pha, giảm mỗi giây và chuyển state khi hết ba khoảng một giây;
  khi đó các số 3,2,1 mỗi số kéo dài 1 s, còn 0 chỉ là giá trị tại biên chuyển.
- Nếu bắt buộc hiển thị 0 đủ một giây thì pha vàng phải dài 4 s.

Xác nhận quy tắc chấm với giảng viên.

## Code SystemVerilog (FSM manual)

```systemverilog
module traffic_fsm_manual (
    input  logic clk,
    input  logic rst,
    input  logic sw0,           // 0=NS go, 1=EW go
    input  logic tick_1s,       // 1 Hz tick
    output logic ns_g, ns_y, ns_r,
    output logic ew_g, ew_y, ew_r,
    output logic [3:0] timer    // countdown display
);
    typedef enum logic [1:0] {NS_GO, NS_WARN, EW_GO, EW_WARN} state_t;
    state_t state, next_state;
    logic [3:0] timer_reg;
    logic target_dir;  // 0=NS, 1=EW

    always_ff @(posedge clk) begin
        if (rst) begin
            state <= NS_GO;
            timer_reg <= 4'd3;
            target_dir <= 1'b0;
        end else if (tick_1s) begin
            // timer and state update
            case (state)
                NS_GO: begin
                    if (sw0 != 1'b0) begin
                        state <= NS_WARN;
                        timer_reg <= 4'd3;
                        target_dir <= 1'b1;
                    end
                end
                NS_WARN: begin
                    if (timer_reg == 4'd1) begin
                        state <= EW_GO;
                        timer_reg <= 4'd9;  // stable display
                    end else begin
                        timer_reg <= timer_reg - 4'd1;
                    end
                end
                EW_GO: begin
                    if (sw0 != 1'b1) begin
                        state <= EW_WARN;
                        timer_reg <= 4'd3;
                        target_dir <= 1'b0;
                    end
                end
                EW_WARN: begin
                    if (timer_reg == 4'd1) begin
                        state <= NS_GO;
                        timer_reg <= 4'd9;
                    end else begin
                        timer_reg <= timer_reg - 4'd1;
                    end
                end
            endcase
        end
    end

    // Output logic (Moore)
    always_comb begin
        ns_g = 0; ns_y = 0; ns_r = 0;
        ew_g = 0; ew_y = 0; ew_r = 0;
        case (state)
            NS_GO:   begin ns_g = 1; ew_r = 1; end
            NS_WARN: begin ns_y = 1; ew_r = 1; end
            EW_GO:   begin ns_r = 1; ew_g = 1; end
            EW_WARN: begin ns_r = 1; ew_y = 1; end
        endcase
    end

    assign timer = timer_reg;
endmodule
```

## Bình luận
- Khi SW0 đổi trong lúc pha vàng, target_dir đã chốt khi bắt đầu pha; SW0 tiếp theo bị bỏ qua cho đến khi hoàn tất.
- Reset về NS_GO (NS xanh, EW đỏ) bất kể SW0.
