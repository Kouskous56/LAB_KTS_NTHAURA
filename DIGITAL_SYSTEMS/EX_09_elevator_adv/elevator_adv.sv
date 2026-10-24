`timescale 1ns/1ps
// Advanced Elevator: 4 floors, up/down, door open/close
module elevator_adv (
    input  logic clk, rst,
    input  logic [3:0] request,  // request[0..3] = floor 0..3
    output logic [1:0] floor,    // current floor
    output logic up, down, door_open, idle
);
    typedef enum logic [1:0] {F0, F1, F2, F3} state_t;
    state_t state;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) state <= F0;
        else begin
            case (state)
                F0: if (request[1] || request[2] || request[3]) state <= F1;
                F1: if (request[2] || request[3]) state <= F2;
                    else if (request[0]) state <= F0;
                F2: if (request[3]) state <= F3;
                    else if (request[0] || request[1]) state <= F1;
                F3: if (request[0] || request[1] || request[2]) state <= F2;
            endcase
        end
    end

    always_comb begin
        floor = state;
        up = 0; down = 0; door_open = 0; idle = 0;
        case (state)
            F0: begin if (request[1]||request[2]||request[3]) up=1; else begin idle=1; door_open=1; end end
            F1: begin if (request[2]||request[3]) up=1; else if (request[0]) down=1; else begin idle=1; door_open=1; end end
            F2: begin if (request[3]) up=1; else if (request[0]||request[1]) down=1; else begin idle=1; door_open=1; end end
            F3: begin if (request[0]||request[1]||request[2]) down=1; else begin idle=1; door_open=1; end end
        endcase
    end
endmodule
