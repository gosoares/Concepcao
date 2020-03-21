`timescale 1ns/100ps
module mux32_tb;
    
    int counter, errors;
    logic clk, rst;
    integer file;
    
    logic [31:0] d;
	logic [4:0] sel;
	logic y, y_esperado;
    
    parameter max_vectors = 64;
    logic [37:0] vectors[max_vectors];

    mux32 dut(d, sel, y);

    initial begin
        counter = 0; errors = 0;
		rst = 1'b1; #12; rst = 0;
		clk=0;
		
		if(~rst) begin
			$readmemb("mux32.tv", vectors);
		end	
		
		file = $fopen("mux32_out.txt");
    
        $display("Iniciando Testbench");
        $display("---------------");
        $display("| D | Sel | Y |");
        
        $fwrite(file, "Iniciando Testbench\n");
        $fwrite(file, "---------------\n");
        $fwrite(file, "| D | Sel | Y |\n"); 	
    end
	        
    always begin
        clk = 1; #13;
        clk = 0; #5;
    end

    always @(posedge clk)
        if(~rst) begin
	        {d, sel, y_esperado} = vectors[counter];	
        end

    always @(negedge clk)	//Sempre (que o clock descer)
        if(~rst) begin
			if(y_esperado !== 1'bx) begin
				
				assert (y === y_esperado) begin
					$display("| %b | %b | %b | OK", d, sel, y);
					$fwrite(file, "| %b | %b | %b | OK\n", d, sel, y);
				end else begin
					errors++;
					$error("| %b | %b | %b | ERROR", d, sel, y_esperado);
					$fwrite(file, "| %b | %b | %b | ERROR\n", d, sel, y);
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
 
 