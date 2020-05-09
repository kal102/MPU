cd ..
if [file exists work] {vdel -all}
vlib work
vlog ./src/mmu_beh.v
vlog ./src/mmu_setup.v
vlog ./src/mac_cell.v
vlog ./src/mmu_str.v
vlog ./tb/mmu_tb.sv
vsim -debugDB mmu_tb -sv_seed random
add wave -group mmu_tb /mmu_tb/*
add wave -group m_mmu_a_setup /mmu_tb/m_mmu_a_setup/*
add wave -group m_mmu_b_setup /mmu_tb/m_mmu_b_setup/*
add wave -group m_mmu_str /mmu_tb/m_mmu_str/*
add wave -group m_mmu_c_setup /mmu_tb/m_mmu_c_setup/*
run -all
wave zoom full
