`timescale 1ns/100ps
module mux_tb;
    
int counter, errors, aux_error;
logic clk, rst;
logic a, b, sel, y, y_esperado;
logic [3:0] vectors[8];

mux dut(a, y);

initial begin
    $display("Iniciando Testbench");
    $display("| A | B | S | Y |"); 
    $display("---------------");
    $readmemb("mux.tv", vectors);
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
	    {a, b, sel, y_esperado} = vectors[counter];	
    end

always @(negedge clk)	//Sempre (que o clock descer)
    if(~rst)
    begin
        aux_error = errors;
        assert (y === y_esperado) else errors = errors + 1;

        if(aux_error === errors)
            $display("| %b | %b | %b | %b | OK", a, b, sel, y);
        else
            $display("| %b | %b | %b | %b | ERROR", a, b, sel, y);

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
 
 
