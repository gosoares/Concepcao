transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+D:/Developer/Concepcao/mips/data_path/flopr {D:/Developer/Concepcao/mips/data_path/flopr/flopr.sv}

vlog -sv -work work +incdir+D:/Developer/Concepcao/mips/data_path/flopr/testbench {D:/Developer/Concepcao/mips/data_path/flopr/testbench/flopr_tb.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc" flopr_tb

add wave *
view structure
view signals
run -all
