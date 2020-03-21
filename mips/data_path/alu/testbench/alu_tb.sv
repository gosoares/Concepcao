`timescale 1ns/100ps
module alu_tb;
    
    int counter, errors;
    logic clk, rst;
    integer file;
    
    logic a, b, slt_in, adder_cin;
	logic [2:0] op;
	logic [2:0]	y, y_esp;
    
    parameter max_vectors = 56;
    logic [9:0] vectors[max_vectors];

    alu dut(a, b, slt_in, adder_cin, op, y[2], y[1], y[0]);

    initial begin
        counter = 0; errors = 0;
		rst = 1'b1; #12; rst = 0;
		clk=0;
		
		if(~rst) begin
			$readmemb("alu.tv", vectors);
		end	
		
		file = $fopen("alu_out.txt");
    
        $display("Iniciando Testbench");
        $display("---------------");
        $display("| A | B | SLT | Cin | op | cout | s | result |");
        
        $fwrite(file, "Iniciando Testbench\n");
        $fwrite(file, "---------------\n");
        $fwrite(file, "| A | B | SLT | Cin | op | cout | s | result |\n"); 	
    end
	        
    always begin
        clk = 1; #10;
        clk = 0; #5;
    end

    always @(posedge clk)
        if(~rst) begin
	        {a, b, op, slt_in, adder_cin, y_esp[2], y_esp[1], y_esp[0]} = vectors[counter];	
        end

    always @(negedge clk)	//Sempre (que o clock descer)
        if(~rst) begin
			if(y_esp !== 3'bx) begin
				
				assert (y === y_esp) begin
					$display("| %b | %b | %b | %b | %b | %b | %b | %b | OK", a, b, slt_in, adder_cin, op, y[2], y[1], y[0]);
					$fwrite(file, "| %b | %b | %b | %b | %b | %b | %b | %b | OK\n", a, b, slt_in, adder_cin, op, y[2], y[1], y[0]);
				end else begin
					errors++;
					$error("| %b | %b | %b | %b | %b | %b | %b | %b | ERROR", a, b, slt_in, adder_cin, op, y[2], y[1], y[0]);
					$fwrite(file, "| %b | %b | %b | %b | %b | %b | %b | %b | ERROR", a, b, slt_in, adder_cin, op, y[2], y[1], y[0]);
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
 
 
