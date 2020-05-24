cd ..
if [file exists work] {vdel -all}
vlib work
vlog ./src/axis_rx.v
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
vlog ./src/axis_tx_scheduler.v
vlog ./src/axis_tx.v
vlog ./src/top.v
vlog ./tb/mpu_macros.svh
vlog ./tb/mpu_stream.svh
vlog ./tb/top_tb.sv
vsim -debugDB top_tb -sv_seed random
add wave -group mpu_tb /top_tb/m_top/*
add wave -group m_axis_rx /top_tb/m_top/m_axis_rx/*
add wave -group m_mpu /top_tb/m_top/m_mpu/*
add wave -group m_buffer_a /top_tb/m_top/m_mpu/m_buffer_a/m_buffer_a/*
add wave -group m_buffer_b /top_tb/m_top/m_mpu/m_buffer_b/m_buffer_b/*
add wave -group m_mmu_controller /top_tb/m_top/m_mpu/m_mmu_controller/*
add wave -group m_mmu_a_setup /top_tb/m_top/m_mpu/m_mmu_a_setup/*
add wave -group m_mmu_b_setup /top_tb/m_top/m_mpu/m_mmu_b_setup/*
add wave -group m_mmu_str /top_tb/m_top/m_mpu/m_mmu_str/*
add wave -group m_mmu_c_setup /top_tb/m_top/m_mpu/m_mmu_c_setup/*
add wave -group m_activation_pipeline /top_tb/m_top/m_mpu/m_activation_pipeline/*
add wave -group m_padding_pipeline /top_tb/m_top/m_mpu/m_padding_pipeline/*
add wave -group m_pooling_pipeline /top_tb/m_top/m_mpu/m_pooling_pipeline/*
add wave -group m_out_controller /top_tb/m_top/m_mpu/m_out_controller/*
add wave -group m_fifo_v /top_tb/m_top/m_mpu/m_fifo_v/*
add wave -group m_fifo_dim_y /top_tb/m_top/m_mpu/m_fifo_dim_x/*
add wave -group m_fifo_dim_x /top_tb/m_top/m_mpu/m_fifo_dim_y/*
add wave -group m_buffer_c /top_tb/m_top/m_mpu/m_buffer_c/*
add wave -group m_axis_tx /top_tb/m_top/m_axis_tx/*
add wave -group m_axis_tx_scheduler /top_tb/m_top/m_axis_tx/m_axis_tx_scheduler/*
run -all
wave zoom full
