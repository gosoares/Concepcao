`timescale 1ns/100ps
module addac4_tb;
    
int counter, errors, aux_error;
logic clk, rst;
logic sel0, sel1, iclk, cout, cout_esperado;
logic [3:0] a, s, s_esperado;
logic [11:0] vectors[240];

addac4 dut(a, sel0, sel1, sel0, iclk, s, cout);

initial begin
    $display("Iniciando Testbench");
    $display("|   A   | Sel0 | Sel1 | Clk | S | Cout |"); 
    $display("---------------");
    $readmemb("addac4.tv", vectors);
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
        for(int i = 0; i < 4; i++) begin
			assert (s[i] === s_esperado[i])
			else begin
			    //Mostra mensagem de erro se a saída do DUT for diferente da saída esperada
		        $display("Error S: input in position %d = %b", i, s[i]);
		        $display("linha %d ª , saída = %b, (%b esperado)",counter+1, s[i], s_esperado[i]);
					        
		        errors = errors + 1; //Incrementa contador de erros a cada bit errado encontrado
	        end
		end
		
		assert(cout === cout_esperado)
		else begin
			//Mostra mensagem de erro se a saída do DUT for diferente da saída esperada
			$display("Error COUT:");
			$display("linha %d ª , saída = %b, (%b esperado)",counter+1, cout, cout_esperado);
						
			errors = errors + 1; //Incrementa contador de erros a cada bit errado encontrado
		end

        if(aux_error === errors)
            $display("| %b |  %b   |  %b   |  %b  | %b | %b | OK", a, sel0, sel1, iclk, s, cout);
        else
            $display("| %b |  %b   |  %b   |  %b  | %b | %b | ERROR", a, sel0, sel1, iclk, s, cout);
            
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
 
 
