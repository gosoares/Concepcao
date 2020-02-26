module alu_decoder(
	input logic [1:0] ALUOp,
	input logic [5:0] Opcode, Funct,
	output logic [2:0] ALUControl
);

localparam [2:0] AND = 3'b000,
OR = 3'b001, ADD = 3'b010,
SUB = 3'b110, SLT = 3'b111,
NOR = 3'b101, XOR = 3'b011;

always_comb begin
	case(ALUOp)
		2'b00: ALUControl <= ADD;
		2'b01: ALUControl <= SUB;
		2'b10: begin
			case(Funct)
				6'b100000: ALUControl <= ADD;
				6'b100010: ALUControl <= SUB;
				6'b100100: ALUControl <= AND;
				6'b100101: ALUControl <= OR;
				6'b100111: ALUControl <= NOR;
				6'b100110: ALUControl <= XOR;
				6'b101010: ALUControl <= SLT;
				default: ALUControl <= ADD;
			endcase
		end
		2'b11: begin
			case(Opcode)
				6'b001000: ALUControl <= ADD;
				6'b001101: ALUControl <= OR;
				6'b001110: ALUControl <= XOR;
				6'b001010: ALUControl <= SLT;
				default: ALUControl <= ADD;
			endcase
		end
	endcase
end

endmodule