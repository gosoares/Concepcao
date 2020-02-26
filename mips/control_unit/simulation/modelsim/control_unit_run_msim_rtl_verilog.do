transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+D:/Developer/Concepcao/mips/control_unit/main_controller {D:/Developer/Concepcao/mips/control_unit/main_controller/main_controller.sv}
vlog -sv -work work +incdir+D:/Developer/Concepcao/mips/control_unit/alu_decoder {D:/Developer/Concepcao/mips/control_unit/alu_decoder/alu_decoder.sv}
vlog -sv -work work +incdir+D:/Developer/Concepcao/mips/control_unit {D:/Developer/Concepcao/mips/control_unit/control_unit.sv}

vlog -sv -work work +incdir+D:/Developer/Concepcao/mips/control_unit/testbench {D:/Developer/Concepcao/mips/control_unit/testbench/control_unit_tb.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc" control_unit_tb

add wave *
view structure
view signals
run -all
