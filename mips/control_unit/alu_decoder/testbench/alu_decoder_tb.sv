`timescale 1ns/100ps
module alu_decoder_tb;
    
    int counter, errors, aux_error;
    logic clk, rst;
    integer file;
    
    logic [1:0] ALUOp;
	logic [5:0] Opcode, Funct;
	logic [2:0] ALUControl, ALUControl_esperado;
    
    parameter max_vectors = 13;
    logic [30:0] vectors[max_vectors];

    alu_decoder dut(ALUOp, Opcode, Funct, ALUControl);

    initial begin
        counter = 0; errors = 0;
		rst = 1'b1; #12; rst = 0;
		clk=0;
		
		if(~rst) begin
			$readmemb("alu_decoder.tv", vectors);
		end	
		
		file = $fopen("alu_decoder_out.txt");
    
        $display("Iniciando Testbench");
        $display("---------------");
        $display("| ALUOp | Opcode | Funct  | ALUControl |");
        
        $fwrite(file, "Iniciando Testbench");
        $fwrite(file, "---------------");
        $fwrite(file, "| ALUOp | Opcode | Funct  | ALUControl |"); 	
    end
	        
    always begin
        clk = 1; #11;
        clk = 0; #5;
    end

    always @(posedge clk) begin
        if(~rst) begin
	        {ALUOp, Opcode, Funct, ALUControl_esperado} = vectors[counter];
        end
	end

    always @(negedge clk)	//Sempre (que o clock descer)
        if(~rst) begin
			if(ALUControl_esperado !== 3'bx) begin
				aux_error = errors;
				
				for(int i = 0; i < 3; i++) begin
					assert (ALUControl[i] === ALUControl_esperado[i]) else begin
						//Mostra mensagem de erro se a saída do DUT for diferente da saída esperada
						$error("ALUControl[%d] = %b (%b esperado) {Linha %d}", i, ALUControl[i], ALUControl_esperado[i], counter+1);
									
						errors = errors + 1; //Incrementa contador de erros a cada bit errado encontrado
					end
				end
				
				
				if(aux_error === errors) begin // Nao houve erro
					$display("|  %b   | %b | %b |    %b     | OK", ALUOp, Opcode, Funct, ALUControl);
					$fwrite(file, "|  %b   | %b | %b |    %b     | OK", ALUOp, Opcode, Funct, ALUControl);
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
 
 
