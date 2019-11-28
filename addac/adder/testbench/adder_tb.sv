`timescale 1ns/100ps
module adder_tb;
    
int counter, errors, aux_error;
logic clk, rst;
logic a, b, cin, s, s_esperado, cout, cout_esperado;
logic [4:0] vectors[8];

adder dut(a, b, cin, s, cout);

initial begin
    $display("Iniciando Testbench");
    $display("| A | B | Cin | S |"); 
    $display("---------------");
    $readmemb("adder.tv", vectors);
    counter = 0; errors = 0;
    rst = 1; #33; rst = 0;		
end
	    
always
    begin
    clk = 1; #10;
    clk = 0; #5;
    end

always @(posedge clk)
    if(~rst)
    begin
	    {a, b, cin, cout, y_esperado} = vectors[counter];	
    end

always @(negedge clk)	//Sempre (que o clock descer)
    if(~rst)
    begin
        aux_error = errors;
        assert (y === y_esperado)
        else begin
            errors = errors + 1;
            $display("| %b | %b |  %b  | %b |  %b  | ERROR: S = %b", a, b, cin, s_esperado, cout_esperado, s);
        end
        
        assert (y === y_esperado)
        else begin
            errors = errors + 1;
            $display("| %b | %b |  %b  | %b |  %b  | ERROR: Cout = %b", a, b, cin, s_esperado, cout_esperado, cout);
        end

        if(aux_error === errors)
            $display("| %b | %b |  %b  | %b |  %b  | OK", a, b, cin, y, cout);

        counter++;	//Incrementa contador dos vertores de teste
        
        if(counter == $size(vectors)) //Quando os vetores de teste acabarem
        begin
	        $display("Testes Efetuados  = %0d", counter);
	        $display("Erros Encontrados = %0d", errors);
	        #10
	        $stop;
        end     
    end
 endmodule
 
 
