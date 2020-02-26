module main_controller(
    input logic clk, rst,
    input logic [5:0] opcode,
    output logic [3:0] state,
    output logic MemtoReg, RegDst, IorD, ALUSrcA,
    IRWrite, MemWrite, PCWrite, BranchEQ, BranchNE, RegWrite,
    output logic [1:0] PCSrc, ALUSrcB, ALUOp
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
        S0: nextState <= S1;
        S1: case(opcode)
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
        S2: case(opcode)
                LW: nextState <= S3;
                SW: nextState <= S5;
                default: nextState <= S3;
            endcase
        S3: nextState <= S4;
        S4: nextState <= S0;
        S5: nextState <= S0;
        S6: nextState <= S7;
        S7: nextState <= S0;
        S8: nextState <= S0;
        S9: nextState <= S10;
        S10: nextState <= S0;
        S11: nextState <= S0;
        S12: nextState <= S0;
    endcase
end

// calcula proximo estado
always_comb begin
    case(thisState)
        S0: begin
			IorD <= 1'b0;
			ALUSrcA <= 1'b0;
			ALUSrcB <= 2'b01;
			ALUOp <= 2'b00;
			PCSrc <= 2'b00;
			IRWrite <= 1'b1;
			PCWrite <= 1'b1;
			
			MemtoReg <= 1'b0;
			RegDst <= 1'b0;
			MemWrite <= 1'b0;
			BranchEQ <= 1'b0;
			BranchNE <= 1'b0;
			RegWrite <= 1'b0;
        end
        S1: begin
			ALUSrcA <= 1'b0;
			ALUSrcB <= 2'b11;
			ALUOp <= 2'b00;
		
			MemtoReg <= 1'b0;
			RegDst <= 1'b0;
			IorD <= 1'b0;
			PCSrc <= 2'b00;
			IRWrite <= 1'b0;
			MemWrite <= 1'b0;
			PCWrite <= 1'b0;
			BranchEQ <= 1'b0;
			BranchNE <= 1'b0;
			RegWrite <= 1'b0;
		end
		S2: begin
			ALUSrcA <= 1'b1;
			ALUSrcB <= 2'b10;
			ALUOp <= 2'b00;
			
			MemtoReg <= 1'b0;
			RegDst <= 1'b0;
			IorD <= 1'b0;
			PCSrc <= 2'b00;
			IRWrite <= 1'b0;
			MemWrite <= 1'b0;
			PCWrite <= 1'b0;
			BranchEQ <= 1'b0;
			BranchNE <= 1'b0;
			RegWrite <= 1'b0;
		end
		S3: begin
			IorD <= 1'b1;
		
			MemtoReg <= 1'b0;
			RegDst <= 1'b0;
			PCSrc <= 2'b00;
			ALUSrcB <= 2'b00;
			ALUSrcA <= 1'b0;
			IRWrite <= 1'b0;
			MemWrite <= 1'b0;
			PCWrite <= 1'b0;
			BranchEQ <= 1'b0;
			BranchNE <= 1'b0;
			RegWrite <= 1'b0;
			ALUOp <= 2'b00;
		end
		S4: begin
			RegDst <= 1'b0;
			MemtoReg <= 1'b1;
			RegWrite <= 1'b1;
			
			IorD <= 1'b0;
			PCSrc <= 2'b00;
			ALUSrcB <= 2'b00;
			ALUSrcA <= 1'b0;
			IRWrite <= 1'b0;
			MemWrite <= 1'b0;
			PCWrite <= 1'b0;
			BranchEQ <= 1'b0;
			BranchNE <= 1'b0;
			ALUOp <= 2'b00;
		end
		S5: begin
			IorD <= 1'b1;
			MemWrite <= 1'b1;
		
			MemtoReg <= 1'b0;
			RegDst <= 1'b0;
			PCSrc <= 2'b00;
			ALUSrcB <= 2'b00;
			ALUSrcA <= 1'b0;
			IRWrite <= 1'b0;
			PCWrite <= 1'b0;
			BranchEQ <= 1'b0;
			BranchNE <= 1'b0;
			RegWrite <= 1'b0;
			ALUOp <= 2'b00;
		end
		S6: begin
			ALUSrcA <= 1'b1;
			ALUSrcB <= 2'b00;
			ALUOp <= 2'b10;

			MemtoReg <= 1'b0;
			RegDst <= 1'b0;
			IorD <= 1'b0;
			PCSrc <= 2'b00;
			IRWrite <= 1'b0;
			MemWrite <= 1'b0;
			PCWrite <= 1'b0;
			BranchEQ <= 1'b0;
			BranchNE <= 1'b0;
			RegWrite <= 1'b0;
		end
		S7: begin
			RegDst <= 1'b1;
			MemtoReg <= 1'b0;
			RegWrite <= 1'b1;
			
			IorD <= 1'b0;
			PCSrc <= 2'b00;
			ALUSrcB <= 2'b00;
			ALUSrcA <= 1'b0;
			IRWrite <= 1'b0;
			MemWrite <= 1'b0;
			PCWrite <= 1'b0;
			BranchEQ <= 1'b0;
			BranchNE <= 1'b0;
			ALUOp <= 2'b00;
		end
		S8: begin
			ALUSrcA <= 1'b1;
			ALUSrcB <= 2'b00;
			ALUOp <= 2'b01;
			PCSrc <= 2'b01;
			BranchEQ <= 1'b1;
			
			MemtoReg <= 1'b0;
			RegDst <= 1'b0;
			IorD <= 1'b0;
			IRWrite <= 1'b0;
			MemWrite <= 1'b0;
			PCWrite <= 1'b0;
			BranchNE <= 1'b0;
			RegWrite <= 1'b0;
		end
		S9: begin
			ALUSrcA <= 1'b1;
			ALUSrcB <= 2'b10;
			ALUOp <= 2'b11;
		
			MemtoReg <= 1'b0;
			RegDst <= 1'b0;
			IorD <= 1'b0;
			PCSrc <= 2'b00;
			IRWrite <= 1'b0;
			MemWrite <= 1'b0;
			PCWrite <= 1'b0;
			BranchEQ <= 1'b0;
			BranchNE <= 1'b0;
			RegWrite <= 1'b0;
		end
		S10: begin
			RegDst <= 1'b0;
			MemtoReg <= 1'b0;
			RegWrite <= 1'b1;
			
			IorD <= 1'b0;
			PCSrc <= 2'b00;
			ALUSrcB <= 2'b00;
			ALUSrcA <= 1'b0;
			IRWrite <= 1'b0;
			MemWrite <= 1'b0;
			PCWrite <= 1'b0;
			BranchEQ <= 1'b0;
			BranchNE <= 1'b0;
			ALUOp <= 2'b00;
		end
		S11: begin
			PCSrc <= 2'b10;
			PCWrite <= 1'b1;
			
			MemtoReg <= 1'b0;
			RegDst <= 1'b0;
			IorD <= 1'b0;
			ALUSrcB <= 2'b00;
			ALUSrcA <= 1'b0;
			IRWrite <= 1'b0;
			MemWrite <= 1'b0;
			BranchEQ <= 1'b0;
			BranchNE <= 1'b0;
			RegWrite <= 1'b0;
			ALUOp <= 2'b00;
		end
		S12: begin
			ALUSrcA <= 1'b1;
			ALUSrcB <= 2'b00;
			ALUOp <= 2'b01;
			PCSrc <= 2'b01;
			BranchNE <= 1'b1;
			
			MemtoReg <= 1'b0;
			RegDst <= 1'b0;
			IorD <= 1'b0;
			IRWrite <= 1'b0;
			MemWrite <= 1'b0;
			PCWrite <= 1'b0;
			BranchEQ <= 1'b0;
			RegWrite <= 1'b0;
		end
    endcase
end
    
endmodule
