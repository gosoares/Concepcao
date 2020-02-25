module main_controller(
    input logic clk, rst,
    input logic [5:0] opcode,
    output logic [3:0] state
);

typedef enum logic [3:0] {S0, S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11, S12} State;

localparam [5:0] LW = 6'b100011,
SW = 6'b101011,
R_TYPE = 6'b000000,
BEQ = 6'b000100,
BNE = 6'b000101,
J = 6'b000010,
ADDI = 6'b001000,
ORI = 6'b001101,
XORI = 6'b001110,
SLTI = 6'b001010;

State thisState, nextState;
assign state = thisState;

// muda o estado
always_ff @(posedge clk, posedge rst) begin
    if(rst) thisState <= S0;
    else thisState <= nextState;
end
    
// calcula proximo estado
always_comb begin
    case(thisState)
        S0: begin
            nextState <= S1;
        end
        
        S1: begin
            case(opcode)
                LW: nextState <= S2;
                SW: nextState <= S2;
                R_TYPE: nextState <= S6;
                BEQ: nextState <= S8;
                ADDI: nextState <= S9;
                ORI: nextState <= S9;
                XORI: nextState <= S9;
                SLTI: nextState <= S9;
                J: nextState <= S11;
                BNE: nextState <= S12;
                default: nextState <= S2;
            endcase
        end
        
        S2: begin
            case(opcode)
                LW: nextState <= S3;
                SW: nextState <= S5;
                default: nextState <= S3;
            endcase
        end
        
        S3: begin
            nextState <= S4;
        end
        
        S4: begin
            nextState <= S0;
        end
        
        S5: begin
            nextState <= S0;
        end
        
        S6: begin
            nextState <= S7;
        end
        
        S7: begin
            nextState <= S0;
        end
        
        S8: begin
            nextState <= S0;
        end
        
        S9: begin
            nextState <= S10;
        end
        
        S10: begin
            nextState <= S0;
        end
        
        S11: begin
            nextState <= S0;
        end
        
        S12: begin
            nextState <= S0;
        end
    endcase
end
    
endmodule
