`timescale 1ns/100ps
module mux4_tb;
    
    int counter, errors;
    logic clk, rst;
    integer file;
    
    logic d0, d1, d2, d3;
	logic [1:0] sel;
	logic y, y_esperado;
    
    parameter max_vectors = 64;
    logic [6:0] vectors[max_vectors];

    mux4 dut(d0, d1, d2, d3, sel, y);

    initial begin
        counter = 0; errors = 0;
		rst = 1'b1; #12; rst = 0;
		clk=0;
		
		if(~rst) begin
			$readmemb("mux4.tv", vectors);
		end	
		
		file = $fopen("mux4_out.txt");
    
        $display("Iniciando Testbench");
        $display("---------------");
        $display("| D0 | D1 | D2 | D3 | Sel | Y |");
        
        $fwrite(file, "Iniciando Testbench\n");
        $fwrite(file, "---------------\n");
        $fwrite(file, "| D0 | D1 | D2 | D3 | Sel | Y |\n"); 	
    end
	        
    always begin
        clk = 1; #8;
        clk = 0; #5;
    end

    always @(posedge clk)
        if(~rst) begin
	        {d0, d1, d2, d3, sel, y_esperado} = vectors[counter];	
        end

    always @(negedge clk)	//Sempre (que o clock descer)
        if(~rst) begin
			if(y_esperado !== 1'bx) begin
				
				assert (y === y_esperado) begin
					$display("| %b | %b | %b | %b | %b | %b | OK", d0, d1, d2, d3, sel, y);
					$fwrite(file, "| %b | %b | %b | %b | %b | %b | OK\n", d0, d1, d2, d3, sel, y);
				end else begin
					errors++;
					$error("| %b | %b | %b | %b | %b | %b | ERROR", d0, d1, d2, d3, sel, y_esperado);
					$fwrite(file, "| %b | %b | %b | %b | %b | %b | ERROR\n", d0, d1, d2, d3, sel, y_esperado);
				end

				counter++;	//Incrementa contador dos vetores de teste
				if(counter == max_vectors) begin
					$display("Testes Efetuados  = %0d", counter);
					$display("Erros Encontrados = %0d", errors);
					$fwrite(file, "Testes Efetuados  = %0d\n", counter);
					$fwrite(file, "Erros Encontrados = %0d\n", errors);
					#10
					$stop;
				end     
			end
        end
endmodule
 
 
