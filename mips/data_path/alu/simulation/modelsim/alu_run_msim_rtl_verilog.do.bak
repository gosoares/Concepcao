transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+D:/Developer/Concepcao/mips/data_path/mux2 {D:/Developer/Concepcao/mips/data_path/mux2/mux2.sv}
vlog -sv -work work +incdir+D:/Developer/Concepcao/mips/data_path/mux4 {D:/Developer/Concepcao/mips/data_path/mux4/mux4.sv}
vlog -sv -work work +incdir+D:/Developer/Concepcao/mips/data_path/full_adder {D:/Developer/Concepcao/mips/data_path/full_adder/full_adder.sv}
vlog -sv -work work +incdir+D:/Developer/Concepcao/mips/data_path/mux8 {D:/Developer/Concepcao/mips/data_path/mux8/mux8.sv}
vlog -sv -work work +incdir+D:/Developer/Concepcao/mips/data_path/alu {D:/Developer/Concepcao/mips/data_path/alu/alu.sv}

vlog -sv -work work +incdir+D:/Developer/Concepcao/mips/data_path/alu/testbench {D:/Developer/Concepcao/mips/data_path/alu/testbench/alu_tb.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc" alu_tb

add wave *
view structure
view signals
run -all
