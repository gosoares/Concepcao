`timescale 1ns/100ps
module shift_left32_tb;
    
    int counter, errors;
    logic clk, rst;
    integer file;

	logic [31:0] a, y, y_esperado;
    
    parameter max_vectors = 20;
    logic [63:0] vectors[max_vectors];

    shift_left32 dut(a, y);

    initial begin
        counter = 0; errors = 0;
		rst = 1'b1; #12; rst = 0;
		clk=0;
		
		if(~rst) begin
			$readmemb("shift_left32.tv", vectors);
		end	
		
		file = $fopen("shift_left32_out.txt");
    
        $display("Iniciando Testbench");
        $display("---------------");
        $display("| A | Y |");
        
        $fwrite(file, "Iniciando Testbench\n");
        $fwrite(file, "---------------\n");
        $fwrite(file, "| A | Y |\n"); 	
    end
	        
    always begin
        clk = 1; #8;
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
 
 
