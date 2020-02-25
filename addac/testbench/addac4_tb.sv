`timescale 1ns/100ps
module addac4_tb;
    
    int counter, errors, aux_error;
    logic clk, rst;
    integer file;
    
    logic sel0, sel1, iclk, cout, cout_esperado;
	logic [3:0] a, s, s_esperado;
    
    parameter max_vectors = 243;
    logic [11:0] vectors[max_vectors];

    addac4 dut(a, sel0, sel1, iclk, s, cout);

    initial begin
        counter = 0; errors = 0;
		rst = 1'b1; #12; rst = 0;
		clk=0;
		
		if(~rst) begin
			$readmemb("addac4.tv", vectors);
		end	
		
		file = $fopen("addac4_out.txt");
    
        $display("Iniciando Testbench");
        $display("---------------");
        $display("|  A   | Sel0 | Sel1 | Clk |  S   | Cout |");
        
        $fwrite(file, "Iniciando Testbench");
        $fwrite(file, "---------------");
        $fwrite(file, "|   A  | Sel0 | Sel1 | Clk |  S   | Cout |"); 	
    end
	        
    always begin
        clk = 1; #10;
        clk = 0; #5;
    end

    always @(posedge clk) begin
        if(~rst) begin
	        {sel0, sel1, a, iclk, cout_esperado, s_esperado} = vectors[counter];	
        end
	end

    always @(negedge clk)	//Sempre (que o clock descer)
        if(~rst) begin
			if(s_esperado !== 4'bx && cout_esperado !== 1'bx) begin
				aux_error = errors;
				
				for(int i = 0; i < 4; i++) begin
					assert (s[i] === s_esperado[i]) else begin
						//Mostra mensagem de erro se a saída do DUT for diferente da saída esperada
						$error("Erro S na linha %d bit %d, saida = %b, (%b esperado)", counter+1, i, s[i], s_esperado[i]);
									
						errors = errors + 1; //Incrementa contador de erros a cada bit errado encontrado
					end
				end
				
				assert (cout === cout_esperado) else begin
					errors++;
					$error("| %b |  %b   |  %b   |  %b  | %b |  %b   | ERROR: Cout = %b Linha %d", 
							a, sel0, sel1, iclk, s_esperado, cout_esperado, cout, counter+1);
					$fwrite(file, "| %b |  %b   |  %b   |  %b  | %b |  %b   | ERROR: Cout = %b Linha %d", 
							a, sel0, sel1, iclk, s_esperado, cout_esperado, cout, counter+1);
				end

				if(aux_error === errors) begin // Nao houve erro
					$display("| %b |  %b   |  %b   |  %b  | %b |  %b   | OK", a, sel0, sel1, iclk, s, cout);
					$fwrite(file, "| %b |  %b   |  %b   |  %b  | %b |  %b   | OK", a, sel0, sel1, iclk, s, cout);
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
 
 
