`timescale 1ns/100ps
module main_controller_tb;
    
    int counter, errors, aux_error;
    logic clk, rst;
    integer file;
    
    logic clock, reset;
    logic [5:0] opcode;
    logic [3:0] state, state_esperado;

    logic MemtoReg, RegDst, IorD, ALUSrcA,
    IRWrite, MemWrite, PCWrite, BranchEQ, BranchNE, RegWrite;
    logic [1:0] PCSrc, ALUSrcB, ALUOp;

    logic MemtoReg_esperado, RegDst_esperado, IorD_esperado, ALUSrcA_esperado,
    IRWrite_esperado, MemWrite_esperado, PCWrite_esperado, BranchEQ_esperado,
    BranchNE_esperado, RegWrite_esperado;
    logic [1:0] PCSrc_esperado, ALUSrcB_esperado, ALUOp_esperado;
    
    parameter max_vectors = 78;
    logic [30:0] vectors[max_vectors];

    main_controller dut(clock, reset, opcode, state, MemtoReg, RegDst, IorD,
	ALUSrcA, IRWrite, MemWrite, PCWrite, BranchEQ, BranchNE, RegWrite, PCSrc,
	ALUSrcB, ALUOp);

    initial begin
        counter = 0; errors = 0;
		rst = 1'b1; #12; rst = 0;
		clk=0;
		
		if(~rst) begin
			$readmemb("main_controller.tv", vectors);
		end	
		
		file = $fopen("main_controller_out.txt");
    
        $display("Iniciando Testbench");
        $display("---------------");
        $display("| clk | rst | opcode | state | MemtoReg | RegDst | IorD | PCSrc | ALUSrcB | ALUSrcA | IRWrite | MemWrite | PCWrite | BranchEQ | BranchNE | RegWrite | ALUOp |");
        
        $fwrite(file, "Iniciando Testbench");
        $fwrite(file, "---------------");
        $fwrite(file, "| clk | rst | opcode | state | MemtoReg | RegDst | IorD | PCSrc | ALUSrcB | ALUSrcA | IRWrite | MemWrite | PCWrite | BranchEQ | BranchNE | RegWrite | ALUOp |"); 	
    end
	        
    always begin
        clk = 1; #10;
        clk = 0; #5;
    end

    always @(posedge clk) begin
        if(~rst) begin
	        {clock, reset, opcode, state_esperado, MemtoReg_esperado, RegDst_esperado,IorD_esperado,
			PCSrc_esperado, ALUSrcB_esperado, ALUSrcA_esperado, IRWrite_esperado, MemWrite_esperado,
			PCWrite_esperado, BranchEQ_esperado, BranchNE_esperado, RegWrite_esperado, ALUOp_esperado} = vectors[counter];
        end
    end

    always @(negedge clk)	//Sempre (que o clock descer)
        if(~rst) begin
			if(state_esperado !== 4'bx) begin
				aux_error = errors;
				
				assert(state === state_esperado) else begin 
					for(int i = 0; i < 4; i++) begin
						assert (state[i] === state_esperado[i]) else begin
							//Mostra mensagem de erro se a saída do DUT for diferente da saída esperada
							$error("s[%d] = %b (%b esperado) {Linha %d}", i, state[i], state_esperado[i], counter+1);
										
							errors = errors + 1; //Incrementa contador de erros a cada bit errado encontrado
						end
					end
				end
				
				assert(MemtoReg === MemtoReg_esperado) else begin
					$error("MemtoReg = %b na linha %d", MemtoReg, counter+1);
					errors = errors + 1;
				end
				
				assert(RegDst === RegDst_esperado) else begin
					$error("RegDst = %b na linha %d", RegDst, counter+1);
					errors = errors + 1;
				end
				
				assert(IorD === IorD_esperado) else begin
					$error("IorD = %b na linha %d", IorD, counter+1);
					errors = errors + 1;
				end
				
				assert(ALUSrcA === ALUSrcA_esperado) else begin
					$error("ALUSrcA = %b na linha %d", ALUSrcA, counter+1);
					errors = errors + 1;
				end
				
				assert(IRWrite === IRWrite_esperado) else begin
					$error("IRWrite = %b na linha %d", IRWrite, counter+1);
					errors = errors + 1;
				end
				
				assert(MemWrite === MemWrite_esperado) else begin
					$error("MemWrite = %b na linha %d", MemWrite, counter+1);
					errors = errors + 1;
				end
				
				assert(PCWrite === PCWrite_esperado) else begin
					$error("PCWrite = %b na linha %d", PCWrite, counter+1);
					errors = errors + 1;
				end
				
				assert(BranchEQ === BranchEQ_esperado) else begin
					$error("BranchEQ = %b na linha %d", BranchEQ, counter+1);
					errors = errors + 1;
				end
				
				assert(BranchNE === BranchNE_esperado) else begin
					$error("BranchNE = %b na linha %d", BranchNE, counter+1);
					errors = errors + 1;
				end
				
				assert(RegWrite === RegWrite_esperado) else begin
					$error("RegWrite = %b na linha %d", RegWrite, counter+1);
					errors = errors + 1;
				end
				
				for(int i = 0; i < 2; i++) begin
					assert (PCSrc[i] === PCSrc_esperado[i]) else begin
						$error("Erro PCSrc na linha %d bit %d, saida = %b, (%b esperado)", counter+1, i, PCSrc[i], PCSrc_esperado[i]);
						errors = errors + 1;
					end
				end
				
				for(int i = 0; i < 2; i++) begin
					assert (ALUSrcB[i] === ALUSrcB_esperado[i]) else begin
						$error("Erro ALUSrcB na linha %d bit %d, saida = %b, (%b esperado)", counter+1, i, ALUSrcB[i], ALUSrcB_esperado[i]);
						errors = errors + 1;
					end
				end
				
				for(int i = 0; i < 2; i++) begin
					assert (ALUOp[i] === ALUOp_esperado[i]) else begin
						$error("Erro ALUOp na linha %d bit %d, saida = %b, (%b esperado)", counter+1, i, ALUOp[i], ALUOp_esperado[i]);
						errors = errors + 1;
					end
				end
				
				if(aux_error === errors) begin // Nao houve erro
					$display("|  %b  |  %b  | %b | %b  | %b | %b | %b | %b | %b | %b | %b | %b | %b | %b | %b | %b | %b | OK",
						clock, reset, opcode, state, MemtoReg, RegDst,IorD, PCSrc, ALUSrcB,
						ALUSrcA, IRWrite, MemWrite, PCWrite, BranchEQ, BranchNE ,RegWrite, ALUOp);
					$fwrite(file, "|  %b  |  %b  | %b | %b  | %b | %b | %b | %b | %b | %b | %b | %b | %b | %b | %b | %b | %b | OK\n",
						clock, reset, opcode, state, MemtoReg, RegDst,IorD, PCSrc, ALUSrcB,
						ALUSrcA, IRWrite, MemWrite, PCWrite, BranchEQ, BranchNE ,RegWrite, ALUOp);
				end else begin
					$display("|  %b  |  %b  | %b | %b  | %b | %b | %b | %b | %b | %b | %b | %b | %b | %b | %b | %b | %b | ERROR (see above)",
						clock, reset, opcode, state, MemtoReg, RegDst,IorD, PCSrc, ALUSrcB,
						ALUSrcA, IRWrite, MemWrite, PCWrite, BranchEQ, BranchNE ,RegWrite, ALUOp);
					$fwrite(file, "|  %b  |  %b  | %b | %b  | %b | %b | %b | %b | %b | %b | %b | %b | %b | %b | %b | %b | %b | ERROR (see above)\n",
						clock, reset, opcode, state, MemtoReg, RegDst,IorD, PCSrc, ALUSrcB,
						ALUSrcA, IRWrite, MemWrite, PCWrite, BranchEQ, BranchNE ,RegWrite, ALUOp);
				end
	
				if(counter+1 == max_vectors) begin
					$display("Testes Efetuados  = %0d", counter+1);
					$display("Erros Encontrados = %0d", errors);
					$fwrite(file, "Testes Efetuados  = %0d", counter+1);
					$fwrite(file, "Erros Encontrados = %0d", errors);
					#10
					$stop;
				end    
			end
			counter++; //Incrementa contador dos vertores de teste
        end
endmodule
 
 
