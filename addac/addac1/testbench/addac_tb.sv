`timescale 1ns/100ps
module addac_tb;
    
    int counter, errors, aux_error;
    logic clk, rst;
    integer file;
    
    logic sel0, sel1, a, iclk;
	logic cout, cout_esperado, s, s_esperado;
    
    parameter max_vectors = 63;
    logic [5:0] vectors[max_vectors];

    addac dut(a, sel0, sel1, sel0, iclk, s, cout);

    initial begin
        counter = 0; errors = 0;
		rst = 1'b1; #6; rst = 0;
		
		if(~rst) begin
			$readmemb("addac.tv", vectors);
		end	
		
		file = $fopen("addac_out.txt");
    
        $display("Iniciando Testbench");
        $display("---------------");
        $display("| A | Sel0 | Sel1 | Clk | S | Cout |");
        
        $fwrite(file, "Iniciando Testbench");
        $fwrite(file, "---------------");
        $fwrite(file, "| A | Sel0 | Sel1 | Clk | S | Cout |"); 	
    end
	        
    always begin
        clk = 1; #9;
        clk = 0; #5;
    end

    always @(posedge clk)
        if(~rst) begin
	        {sel0, sel1, a, iclk, cout_esperado, s_esperado} = vectors[counter];	
        end

    always @(negedge clk)	//Sempre (que o clock descer)
        if(~rst) begin
			if(s_esperado !== 1'bx && cout_esperado !== 1'bx) begin
				aux_error = errors;
				
				assert (s === s_esperado) else begin
					errors++;
					$error("| %b |  %b   |  %b   |  %b  | %b |  %b   | ERROR: S = %b Linha %d", 
							a, sel0, sel1, iclk, s_esperado, cout_esperado, s, counter+1);
					$fwrite(file, "| %b |  %b   |  %b   |  %b  | %b |  %b   | ERROR: S = %b Linha %d", 
							a, sel0, sel1, iclk, s_esperado, cout_esperado, s, counter+1);
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
 
 
