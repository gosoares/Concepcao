transcript on
if {[file exists gate_work]} {
	vdel -lib gate_work -all
}
vlib gate_work
vmap work gate_work

vlog -vlog01compat -work work +incdir+. {alu_decoder_6_1200mv_85c_slow.vo}

vlog -sv -work work +incdir+D:/Developer/Concepcao/mips/control_unit/alu_decoder/testbench {D:/Developer/Concepcao/mips/control_unit/alu_decoder/testbench/alu_decoder_tb.sv}

vsim -t 1ps +transport_int_delays +transport_path_delays -L altera_ver -L cycloneive_ver -L gate_work -L work -voptargs="+acc" alu_decoder_tb

add wave *
view structure
view signals
run -all
