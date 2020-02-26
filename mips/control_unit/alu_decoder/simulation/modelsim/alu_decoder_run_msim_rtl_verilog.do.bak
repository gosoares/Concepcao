transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+D:/Developer/Concepcao/mips/control_unit/alu_decoder {D:/Developer/Concepcao/mips/control_unit/alu_decoder/alu_decoder.sv}

vlog -sv -work work +incdir+D:/Developer/Concepcao/mips/control_unit/alu_decoder/testbench {D:/Developer/Concepcao/mips/control_unit/alu_decoder/testbench/alu_decoder_tb.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc" alu_decoder_tb

add wave *
view structure
view signals
run -all
