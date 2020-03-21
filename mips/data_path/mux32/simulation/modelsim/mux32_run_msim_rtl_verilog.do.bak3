transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+D:/Developer/Concepcao/mips/data_path/mux2 {D:/Developer/Concepcao/mips/data_path/mux2/mux2.sv}
vlog -sv -work work +incdir+D:/Developer/Concepcao/mips/data_path/mux4 {D:/Developer/Concepcao/mips/data_path/mux4/mux4.sv}
vlog -sv -work work +incdir+D:/Developer/Concepcao/mips/data_path/mux32 {D:/Developer/Concepcao/mips/data_path/mux32/mux32.sv}

vlog -sv -work work +incdir+D:/Developer/Concepcao/mips/data_path/mux32/testbench {D:/Developer/Concepcao/mips/data_path/mux32/testbench/mux32_tb.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc" mux32_tb

add wave *
view structure
view signals
run -all
