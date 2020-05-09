cd ..
if [file exists work] {vdel -all}
vlib work
vlog ./src/single_port_ram.v
vlog ./src/mem_1to2.v
vlog ./src/buffer_a_10x.v
vlog ./tb/buffer_tb.sv
vsim -debugDB buffer_tb -sv_seed random
add wave -group buffer_tb /buffer_tb/*
add wave -group m_buffer_input /buffer_tb/m_buffer_a/*
run -all
wave zoom full
