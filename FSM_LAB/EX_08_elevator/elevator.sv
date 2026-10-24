`timescale 1ns/1ps
// Elevator controller FSM: 3 floors, up/down
module elevator (
    input  logic clk, rst,
    input  logic [2:0] request,  // request[0]=floor0, [1]=floor1, [2]=floor2
    output logic [1:0] floor,     // current floor
    output logic up, down, idle
);
    typedef enum logic [1:0] {F0, F1, F2} state_t;
    state_t state;

    always_ff @(posedge clk) begin
        if (rst) state <= F0;
        else begin
            case (state)
                F0: if (request[1] || request[2]) state <= F1;
                F1: if (request[2]) state <= F2;
                    else if (!request[1] && !request[2] && request[0]) state <= F0;
                F2: if (request[0] || request[1]) state <= F1;
            endcase
        end
    end

    always_comb begin
        floor = state;
        up = 0; down = 0; idle = 0;
        case (state)
            F0: begin if (request[1] || request[2]) up = 1; else idle = 1; end
            F1: begin if (request[2]) up = 1; else if (request[0]) down = 1; else idle = 1; end
            F2: begin if (request[0] || request[1]) down = 1; else idle = 1; end
        endcase
    end
endmodule
