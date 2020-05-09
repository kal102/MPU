cd ..
if [file exists work] {vdel -all}
vlib work
vlog ./src/eth_rx.v
vlog ./src/single_port_ram.v
vlog ./src/mem_1to2.v
vlog ./src/buffer_a_4x.v
vlog ./src/buffer_b_4x.v
vlog ./src/buffer_a.v
vlog ./src/buffer_b.v
vlog ./src/delay.v
vlog ./src/mmu_controller.v
vlog ./src/mmu_setup.v
vlog ./src/mac_cell.v
vlog ./src/mmu_str.v
vlog ./src/activation_pipeline.v
vlog ./src/padding_pipeline.v
vlog ./src/pooling_max.v
vlog ./src/pooling_pipeline.v
vlog ./src/out_controller.v
vlog ./src/FIFO_v.v
vlog ./src/mem_2to2.v
vlog ./src/buffer_c.v
vlog ./src/mpu.v
vlog ./src/eth_tx_scheduler.v
vlog ./src/eth_tx.v
vlog ./tb/matrix.svh
vlog ./tb/mpu_macros.svh
vlog ./tb/mpu_frame.svh
vlog ./tb/mpu_tb.sv
vsim -debugDB mpu_tb -sv_seed random
add wave -group mpu_tb /mpu_tb/*
add wave -group m_eth_rx /mpu_tb/m_eth_rx/*
add wave -group m_mpu /mpu_tb/m_mpu/*
add wave -group m_buffer_a /mpu_tb/m_mpu/m_buffer_a/m_buffer_a/*
add wave -group m_buffer_b /mpu_tb/m_mpu/m_buffer_b/m_buffer_b/*
add wave -group m_mmu_controller /mpu_tb/m_mpu/m_mmu_controller/*
add wave -group m_mmu_a_setup /mpu_tb/m_mpu/m_mmu_a_setup/*
add wave -group m_mmu_b_setup /mpu_tb/m_mpu/m_mmu_b_setup/*
add wave -group m_mmu_str /mpu_tb/m_mpu/m_mmu_str/*
add wave -group m_mmu_c_setup /mpu_tb/m_mpu/m_mmu_c_setup/*
add wave -group m_activation_pipeline /mpu_tb/m_mpu/m_activation_pipeline/*
add wave -group m_padding_pipeline /mpu_tb/m_mpu/m_padding_pipeline/*
add wave -group m_pooling_pipeline /mpu_tb/m_mpu/m_pooling_pipeline/*
add wave -group m_out_controller /mpu_tb/m_mpu/m_out_controller/*
add wave -group m_fifo_v /mpu_tb/m_mpu/m_fifo_v/*
add wave -group m_fifo_dim_y /mpu_tb/m_mpu/m_fifo_dim_x/*
add wave -group m_fifo_dim_x /mpu_tb/m_mpu/m_fifo_dim_y/*
add wave -group m_buffer_c /mpu_tb/m_mpu/m_buffer_c/*
add wave -group m_eth_tx /mpu_tb/m_eth_tx/*
add wave -group m_eth_tx_scheduler /mpu_tb/m_eth_tx/m_eth_tx_scheduler/*
run -all
wave zoom full
