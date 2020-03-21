`timescale 1ns/100ps
module sign_extend16_tb;
    
    int counter, errors;
    logic clk, rst;
    integer file;
    
    logic [15:0] a;
	logic [31:0] y, y_esperado;
    
    parameter max_vectors = 20;
    logic [48:0] vectors[max_vectors];

    sign_extend16 dut(a, y);

    initial begin
        counter = 0; errors = 0;
		rst = 1'b1; #12; rst = 0;
		clk=0;
		
		if(~rst) begin
			$readmemb("sign_extend16.tv", vectors);
		end	
		
		file = $fopen("sign_extend16_out.txt");
    
        $display("Iniciando Testbench");
        $display("---------------");
        $display("| A | Y |");
        
        $fwrite(file, "Iniciando Testbench\n");
        $fwrite(file, "---------------\n");
        $fwrite(file, "| A | Y |\n"); 	
    end
	        
    always begin
        clk = 1; #9;
        clk = 0; #5;
    end

    always @(posedge clk)
        if(~rst) begin
	        {a, y_esperado} = vectors[counter];	
        end

    always @(negedge clk)	//Sempre (que o clock descer)
        if(~rst) begin
			if(y_esperado !== 32'bx) begin
				
				assert (y === y_esperado) begin
					$display("| %b | %b | OK", a, y);
					$fwrite(file, "| %b | %b | OK\n", a, y);
				end else begin
					errors++;
					$error("| %b | %b | ERROR", a, y_esperado);
					$fwrite(file, "| %b | %b | ERROR\n", a, y);
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
 
 
