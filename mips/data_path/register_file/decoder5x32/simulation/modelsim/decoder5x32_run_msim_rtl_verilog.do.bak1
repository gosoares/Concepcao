transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+D:/Developer/Concepcao/mips/data_path/register_file/decoder5x32 {D:/Developer/Concepcao/mips/data_path/register_file/decoder5x32/decoder5x32.sv}

vlog -sv -work work +incdir+D:/Developer/Concepcao/mips/data_path/register_file/decoder5x32/testbench {D:/Developer/Concepcao/mips/data_path/register_file/decoder5x32/testbench/decoder5x32_tb.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc" decoder5x32_tb

add wave *
view structure
view signals
run -all
