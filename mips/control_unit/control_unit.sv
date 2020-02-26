module control_unit(
    input logic clk, rst,
    input logic [5:0] opcode, funct,
    output logic [3:0] state,
    output logic MemtoReg, RegDst, IorD, ALUSrcA,
    IRWrite, MemWrite, PCWrite, BranchEQ, BranchNE, RegWrite,
    output logic [1:0] PCSrc, ALUSrcB,
	output logic [2:0] ALUControl
);

	logic[1:0] ALUOp;
	main_controller mc(
		clk, rst, opcode, state, MemtoReg, RegDst, IorD,
		ALUSrcA, IRWrite, MemWrite, PCWrite, BranchEQ,
		BranchNE, RegWrite, PCSrc, ALUSrcB, ALUOp
	);
	alu_decoder ad(ALUOp, opcode, funct, ALUControl);


endmodule

