`timescale 1ns/100ps
module mux2_tb;
    
    int counter, errors;
    logic clk, rst;
    integer file;
    
    logic a, b, sel, y, y_esperado;
    
    parameter max_vectors = 8;
    logic [3:0] vectors[max_vectors];

    mux2 dut(a, b, sel, y);

    initial begin
        counter = 0; errors = 0;
		rst = 1'b1; #12; rst = 0;
		clk=0;
		
		if(~rst) begin
			$readmemb("mux2.tv", vectors);
		end	
		
		file = $fopen("mux2_out.txt");
    
        $display("Iniciando Testbench");
        $display("---------------");
        $display("| A | B | S | Y |");
        
        $fwrite(file, "Iniciando Testbench\n");
        $fwrite(file, "---------------\n");
        $fwrite(file, "| A | B | S | Y |\n"); 	
    end
	        
    always begin
        clk = 1; #8;
        clk = 0; #5;
    end

    always @(posedge clk)
        if(~rst) begin
	        {a, b, sel, y_esperado} = vectors[counter];	
        end

    always @(negedge clk)
        if(~rst) begin
			if(y_esperado !== 1'bx) begin
				
				assert (y === y_esperado) begin
					$display("| %b | %b | %b | %b | OK", a, b, sel, y);
					$fwrite(file, "| %b | %b | %b | %b | OK\n", a, b, sel, y);
				end else begin
					errors++;
					$error("| %b | %b | %b | %b | ERROR", a, b, sel, y_esperado);
					$fwrite(file, "| %b | %b | %b | %b | ERROR\n", a, b, sel, y_esperado);
				end

				counter++;	//Incrementa contador dos vetores de teste
				if(counter == max_vectors) begin
					$display("Testes Efetuados  = %0d", counter);
					$display("Erros Encontrados = %0d", errors);
					$fwrite(file, "Testes Efetuados  = %0d", counter);
					$fwrite(file, "Erros Encontrados = %0d", errors);
					#10
					$stop;
				end     
			end
        end
endmodule
 
 
