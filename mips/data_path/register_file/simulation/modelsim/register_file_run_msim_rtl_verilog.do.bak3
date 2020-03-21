transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+D:/Developer/Concepcao/mips/data_path/decoder5x32 {D:/Developer/Concepcao/mips/data_path/decoder5x32/decoder5x32.sv}
vlog -sv -work work +incdir+D:/Developer/Concepcao/mips/data_path/mux2 {D:/Developer/Concepcao/mips/data_path/mux2/mux2.sv}
vlog -sv -work work +incdir+D:/Developer/Concepcao/mips/data_path/mux4 {D:/Developer/Concepcao/mips/data_path/mux4/mux4.sv}
vlog -sv -work work +incdir+D:/Developer/Concepcao/mips/data_path/flopenr {D:/Developer/Concepcao/mips/data_path/flopenr/flopenr.sv}
vlog -sv -work work +incdir+D:/Developer/Concepcao/mips/data_path/mux32 {D:/Developer/Concepcao/mips/data_path/mux32/mux32.sv}
vlog -sv -work work +incdir+D:/Developer/Concepcao/mips/data_path/register_file {D:/Developer/Concepcao/mips/data_path/register_file/register_file.sv}

vlog -sv -work work +incdir+D:/Developer/Concepcao/mips/data_path/register_file/testbench {D:/Developer/Concepcao/mips/data_path/register_file/testbench/register_file_tb.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc" register_file_tb

add wave *
view structure
view signals
run -all
