`timescale 1ns/100ps
module acc_tb;
    
int counter, errors, aux_error;
logic clk, rst;
logic a, iclk, y, y_esperado;
logic [2:0] vectors[15];

acc dut(a, iclk, y);

initial begin
    $display("Iniciando Testbench");
    $display("| A | Clk | Y |"); 
    $display("---------------");
    $readmemb("acc.tv", vectors);
    counter = 0; errors = 0;
    rst = 1; #33; rst = 0;
    a = 0; #5 iclk = 0; #5 iclk = 1; #5 iclk = 0;		
end
	    
always
    begin
    clk = 1; #10;
    clk = 0; #5;
    end

always @(posedge clk)
    if(~rst)
    begin
	    {a, iclk, y_esperado} = vectors[counter];	
    end

always @(negedge clk)	//Sempre (que o clock descer)
    if(~rst)
    begin
        aux_error = errors;
        assert (y === y_esperado) else errors = errors + 1;

        if(aux_error === errors)
            $display("| %b |  %b  | %b | OK", a, iclk, y);
        else
            $display("| %b |  %b  | %b | ERROR Linha %d", a, iclk, y_esperado, counter+1);
            
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
 
 
