`timescale 1ns/100ps
module decoder5x32_tb;
    
    int counter, errors;
    logic clk, rst;
    integer file;
    
    logic [4:0] a;
	logic [31:0] y, y_esperado;
    
    parameter max_vectors = 32;
    logic [36:0] vectors[max_vectors];

    decoder5x32 dut(a, y);

    initial begin
        counter = 0; errors = 0;
		rst = 1'b1; #12; rst = 0;
		clk=0;
		
		if(~rst) begin
			$readmemb("decoder5x32.tv", vectors);
		end	
		
		file = $fopen("decoder5x32_out.txt");
    
        $display("Iniciando Testbench");
        $display("---------------");
        $display("|   A   |                 Y                |");
        
        $fwrite(file, "Iniciando Testbench\n");
        $fwrite(file, "---------------\n");
        $fwrite(file, "|   A   |                 Y                |\n"); 	
    end
	        
    always begin
        clk = 1; #12;
        clk = 0; #5;
    end

    always @(posedge clk)
        if(~rst) begin
	        {a, y_esperado} = vectors[counter];	
        end

    always @(negedge clk)	//Sempre (que o clock descer)
        if(~rst) begin
			if(y_esperado !== 32'bx) begin
				counter++;	//Incrementa contador dos vetores de teste
				
				assert (y === y_esperado) begin
					$display("| %b | %b | OK", a, y);
					$fwrite(file, "| %b | %b | OK\n", a, y);
				end else begin
					for(int i = 0; i < 32; i++) begin
						assert(y[i] == y_esperado[i]) else begin
							errors++;
							$error("Erro y(%d) = %b Linha %d", i, y_esperado[i], counter);
							$fwrite(file, "Erro y(%d) = %b Linha %d", i, y_esperado[i], counter);
						end
					end
				end

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
 
 
