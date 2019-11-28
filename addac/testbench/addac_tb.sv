`timescale 1ns/100ps
module addac_tb;
    
int counter, errors, aux_error;
logic clk, rst;
logic sel0, sel1, a, iclk;
logic cout, cout_esperado, s, s_esperado;
logic [5:0] vectors[60];

addac dut(a, sel0, sel1, sel0, iclk, s, cout);

initial begin
    $display("Iniciando Testbench");
    $display("| A | Sel0 | Sel1 | Clk | S | Cout |"); 
    $display("---------------");
    $readmemb("addac.tv", vectors);
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
	    {sel0, sel1, a, iclk, cout_esperado, s_esperado} = vectors[counter];	
    end

always @(negedge clk)	//Sempre (que o clock descer)
    if(~rst)
    begin
        aux_error = errors;
        assert (s === s_esperado)
        else begin
            errors = errors + 1;
            $display("| %b |  %b   |  %b   |  %b  | %b |  %b   | ERROR: S = %b Linha %d", 
                        a, sel0, sel1, iclk, s_esperado, cout_esperado, s, counter+1);
        end
        
        assert (y === y_esperado)
        else begin
            errors = errors + 1;
            $display("| %b |  %b   |  %b   |  %b  | %b |  %b   | ERROR: Cout = %b Linha %d", 
                        a, sel0, sel1, iclk, s_esperado, cout_esperado, cout, counter+1);
        end

        if(aux_error === errors)
            $display("| %b |  %b   |  %b   |  %b  | %b |  %b   | OK", a, sel0, sel1, iclk, s, cout);
            
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
 
 
