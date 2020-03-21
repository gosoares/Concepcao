`timescale 1ns/100ps
module register_file_tb;
    
    int counter, errors;
    logic clk, rst;
    integer file;
    
    logic [4:0] RegA, RegB, RegC;
	logic clock, reset, dataIn, RegWrite;
	logic [1:0] y, y_esperado;
    
    parameter max_vectors = 132;
    logic [20:0] vectors[max_vectors];

    register_file dut(RegA, RegB, RegC, clock, reset, dataIn, RegWrite, y[1], y[0]);

    initial begin
        counter = 0; errors = 0;
		rst = 1'b1; #12; rst = 0;
		clk=0;
		
		if(~rst) begin
			$readmemb("register_file.tv", vectors);
		end	
		
		file = $fopen("register_file_out.txt");
    
        $display("Iniciando Testbench");
        $display("---------------");
        $display("| RegA | RegB | RegC | clk | rst | dIn | RW | RD1 | RD2");
        
        $fwrite(file, "Iniciando Testbench\n");
        $fwrite(file, "---------------\n");
        $fwrite(file, "| RegA | RegB | RegC | clk | rst | dIn | RW | RD1 | RD2\n"); 	
    end
	        
    always begin
        clk = 1; #13;
        clk = 0; #5;
    end

    always @(posedge clk)
        if(~rst) begin
	        {RegA, RegB, RegC, clock, reset, dataIn, RegWrite, y_esperado} = vectors[counter];
		end

    always @(negedge clk)	//Sempre (que o clock descer)
        if(~rst) begin
			if(y_esperado !== 2'bx) begin
				
				assert (y === y_esperado) begin
					$display("| %b | %b | %b | %b | %b | %b | %b | %b | %b | OK", RegA, RegB, RegC, clock, reset, dataIn, RegWrite, y[1], y[0]);
					$fwrite(file, "| %b | %b | %b | %b | %b | %b | %b | %b | %b | OK\n", RegA, RegB, RegC, clock, reset, dataIn, RegWrite, y[1], y[0]);
				end else begin
					errors++;
					$error("| %b | %b | %b | %b | %b | %b | %b | %b | %b | ERROR", RegA, RegB, RegC, clock, reset, dataIn, RegWrite, y[1], y[0]);
					$fwrite(file, "| %b | %b | %b | %b | %b | %b | %b | %b | %b | ERROR\n", RegA, RegB, RegC, clock, reset, dataIn, RegWrite, y[1], y[0]);
				end

				if(counter+1 == max_vectors) begin
					$display("Testes Efetuados  = %0d", counter+1);
					$display("Erros Encontrados = %0d", errors);
					$fwrite(file, "Testes Efetuados  = %0d\n", counter+1);
					$fwrite(file, "Erros Encontrados = %0d\n", errors);
					#10
					$stop;
				end     
			end
			counter++;	//Incrementa contador dos vetores de teste
        end
endmodule
 
 
