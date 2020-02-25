`timescale 1ns/100ps
module acc_tb;
    
    int counter, errors, aux_error;
    logic clk, rst;
    integer file;
    
    logic a, iclk, y, y_esperado;
    
    parameter max_vectors = 18;
    logic [2:0] vectors[max_vectors];

    acc dut(a, iclk, y);

    initial begin
        counter = 0; errors = 0;
		rst = 1'b1; #12; rst = 0;
		clk=0;
		
		if(~rst) begin
			$readmemb("acc.tv", vectors);
		end	
		
		file = $fopen("acc_out.txt");
    
        $display("Iniciando Testbench");
        $display("---------------");
        $display("| A | Clk | Y |");
        
        $fwrite(file, "Iniciando Testbench");
        $fwrite(file, "---------------");
        $fwrite(file, "| A | Clk | Y |"); 	
    end
	        
    always begin
        clk = 1; #6;
        clk = 0; #5;
    end

    always @(posedge clk)
        if(~rst) begin
	        {a, iclk, y_esperado} = vectors[counter];	
        end

    always @(negedge clk)	//Sempre (que o clock descer)
        if(~rst) begin
			if(y_esperado !== 1'bx) begin
				aux_error = errors;
				
				assert (y === y_esperado) else begin
					errors++;
					$error("| %b |  %b  | %b | ERROR", a, iclk, y_esperado);
					$fwrite(file, "| %b |  %b  | %b | ERROR", a, iclk, y_esperado);
				end

				if(aux_error === errors) begin // Nao houve erro
					$display("| %b |  %b  | %b | OK", a, iclk, y);
					$fwrite(file, "| %b |  %b  | %b | OK", a, iclk, y);
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
 
 
