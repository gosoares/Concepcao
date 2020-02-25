transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+D:/Developer/Concepcao/addac/mux {D:/Developer/Concepcao/addac/mux/mux.sv}
vlog -sv -work work +incdir+D:/Developer/Concepcao/addac/inv {D:/Developer/Concepcao/addac/inv/inv.sv}
vlog -sv -work work +incdir+D:/Developer/Concepcao/addac/adder {D:/Developer/Concepcao/addac/adder/adder.sv}
vlog -sv -work work +incdir+D:/Developer/Concepcao/addac/acc {D:/Developer/Concepcao/addac/acc/acc.sv}
vlog -sv -work work +incdir+D:/Developer/Concepcao/addac/addac1 {D:/Developer/Concepcao/addac/addac1/addac.sv}
vlog -sv -work work +incdir+D:/Developer/Concepcao/addac {D:/Developer/Concepcao/addac/addac4.sv}

vlog -sv -work work +incdir+D:/Developer/Concepcao/addac/testbench {D:/Developer/Concepcao/addac/testbench/addac4_tb.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc" addac4_tb

add wave *
view structure
view signals
run -all
