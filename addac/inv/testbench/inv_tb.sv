`timescale 1ns/100ps

module inv_tb;
	parameter max_vectors = 2;
	logic a, y, y_esperado;
	int counter, errors;
	logic [1:0]vectors[max_vectors];
	logic clk, rst;
	integer file; 
	inv dut(.a(a),.y(y));
	
	initial	begin
		counter = 0; errors = 0;
		rst = 1'b1; #12; rst = 0;
		clk=0;
		
		if(~rst) begin
			$readmemb("inv.tv", vectors);
		end	
		
		file = $fopen("inv_out.txt");
		
		$display("Iniciando Testbench");
		$display("-------------\n");
		$display("|linha | A | Y |");
		
		$fwrite(file, "Iniciando Testbench\n");
		$fwrite(file, "-------------\n");
		$fwrite(file, "|linha | A | Y |\n");
	end
		
	always begin
		clk = 1; #7;
		clk = 0; #5;
	end

	always @(posedge clk)
		if(~rst) begin
			{a, y_esperado} = vectors[counter];
		end	
		
	always @(negedge clk) begin
		if(~rst) begin
			if(y_esperado !== 1'bx) begin
				assert (y === y_esperado) begin
					$display("|  %0d   | %b | %b | OK", counter+1, a, y);
					$fwrite(file, "|  %0d   | %b | %b | OK \n", counter+1, a, y);
				end else begin
					assert (y === y_esperado) else begin
						if(y_esperado!= "x") begin 
							$error("Erro na linha%d",counter," a=%b",a," y=%b",y," y_esperado=%b",y_esperado);	  			     
							$fwrite(file, "Erro na linha%d",counter," a=%b",a," y=%b",y," y_esperado=%b",y_esperado);
							errors++;
						end
					end
				end
			end
			counter++;
			if (counter == max_vectors) begin
				$display("Testes Efetuados  = %0d", counter);
				$display("Erros Encontrados = %0d", errors);
				
				$fwrite(file, "\nTestes Efetuados = %0d \n", counter);
				$fwrite(file, "Erros Encontrados = %0d \n", errors);
				
				$fclose(file);
				
				#10
				$stop;
			end
		end
	end
		
 endmodule
