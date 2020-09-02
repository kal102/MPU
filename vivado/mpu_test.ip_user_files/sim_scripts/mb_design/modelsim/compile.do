vlib modelsim_lib/work
vlib modelsim_lib/msim

vlib modelsim_lib/msim/xil_defaultlib
vlib modelsim_lib/msim/xpm
vlib modelsim_lib/msim/microblaze_v11_0_1
vlib modelsim_lib/msim/lmb_v10_v3_0_9
vlib modelsim_lib/msim/lmb_bram_if_cntlr_v4_0_16
vlib modelsim_lib/msim/blk_mem_gen_v8_4_3
vlib modelsim_lib/msim/axi_lite_ipif_v3_0_4
vlib modelsim_lib/msim/mdm_v3_2_16
vlib modelsim_lib/msim/lib_cdc_v1_0_2
vlib modelsim_lib/msim/proc_sys_reset_v5_0_13
vlib modelsim_lib/msim/util_vector_logic_v2_0_1
vlib modelsim_lib/msim/axis_infrastructure_v1_1_0
vlib modelsim_lib/msim/axis_data_fifo_v2_0_1
vlib modelsim_lib/msim/interrupt_control_v3_1_4
vlib modelsim_lib/msim/axi_gpio_v2_0_21

vmap xil_defaultlib modelsim_lib/msim/xil_defaultlib
vmap xpm modelsim_lib/msim/xpm
vmap microblaze_v11_0_1 modelsim_lib/msim/microblaze_v11_0_1
vmap lmb_v10_v3_0_9 modelsim_lib/msim/lmb_v10_v3_0_9
vmap lmb_bram_if_cntlr_v4_0_16 modelsim_lib/msim/lmb_bram_if_cntlr_v4_0_16
vmap blk_mem_gen_v8_4_3 modelsim_lib/msim/blk_mem_gen_v8_4_3
vmap axi_lite_ipif_v3_0_4 modelsim_lib/msim/axi_lite_ipif_v3_0_4
vmap mdm_v3_2_16 modelsim_lib/msim/mdm_v3_2_16
vmap lib_cdc_v1_0_2 modelsim_lib/msim/lib_cdc_v1_0_2
vmap proc_sys_reset_v5_0_13 modelsim_lib/msim/proc_sys_reset_v5_0_13
vmap util_vector_logic_v2_0_1 modelsim_lib/msim/util_vector_logic_v2_0_1
vmap axis_infrastructure_v1_1_0 modelsim_lib/msim/axis_infrastructure_v1_1_0
vmap axis_data_fifo_v2_0_1 modelsim_lib/msim/axis_data_fifo_v2_0_1
vmap interrupt_control_v3_1_4 modelsim_lib/msim/interrupt_control_v3_1_4
vmap axi_gpio_v2_0_21 modelsim_lib/msim/axi_gpio_v2_0_21

vlog -work xil_defaultlib -64 -incr -sv "+incdir+../../../../mpu_test.srcs/sources_1/bd/mb_design/ipshared/c923" "+incdir+../../../../mpu_test.srcs/sources_1/bd/mb_design/ipshared/8713/hdl" \
"E:/Xilinx/Vivado/2019.1/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"E:/Xilinx/Vivado/2019.1/data/ip/xpm/xpm_fifo/hdl/xpm_fifo.sv" \
"E:/Xilinx/Vivado/2019.1/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -64 -93 \
"E:/Xilinx/Vivado/2019.1/data/ip/xpm/xpm_VCOMP.vhd" \

vcom -work microblaze_v11_0_1 -64 -93 \
"../../../../mpu_test.srcs/sources_1/bd/mb_design/ipshared/f8c3/hdl/microblaze_v11_0_vh_rfs.vhd" \

vcom -work xil_defaultlib -64 -93 \
"../../../bd/mb_design/ip/mb_design_microblaze_0_0/sim/mb_design_microblaze_0_0.vhd" \

vcom -work lmb_v10_v3_0_9 -64 -93 \
"../../../../mpu_test.srcs/sources_1/bd/mb_design/ipshared/78eb/hdl/lmb_v10_v3_0_vh_rfs.vhd" \

vcom -work xil_defaultlib -64 -93 \
"../../../bd/mb_design/ip/mb_design_dlmb_v10_0/sim/mb_design_dlmb_v10_0.vhd" \
"../../../bd/mb_design/ip/mb_design_ilmb_v10_0/sim/mb_design_ilmb_v10_0.vhd" \

vcom -work lmb_bram_if_cntlr_v4_0_16 -64 -93 \
"../../../../mpu_test.srcs/sources_1/bd/mb_design/ipshared/6335/hdl/lmb_bram_if_cntlr_v4_0_vh_rfs.vhd" \

vcom -work xil_defaultlib -64 -93 \
"../../../bd/mb_design/ip/mb_design_dlmb_bram_if_cntlr_0/sim/mb_design_dlmb_bram_if_cntlr_0.vhd" \
"../../../bd/mb_design/ip/mb_design_ilmb_bram_if_cntlr_0/sim/mb_design_ilmb_bram_if_cntlr_0.vhd" \

vlog -work blk_mem_gen_v8_4_3 -64 -incr "+incdir+../../../../mpu_test.srcs/sources_1/bd/mb_design/ipshared/c923" "+incdir+../../../../mpu_test.srcs/sources_1/bd/mb_design/ipshared/8713/hdl" \
"../../../../mpu_test.srcs/sources_1/bd/mb_design/ipshared/c001/simulation/blk_mem_gen_v8_4.v" \

vlog -work xil_defaultlib -64 -incr "+incdir+../../../../mpu_test.srcs/sources_1/bd/mb_design/ipshared/c923" "+incdir+../../../../mpu_test.srcs/sources_1/bd/mb_design/ipshared/8713/hdl" \
"../../../bd/mb_design/ip/mb_design_lmb_bram_0/sim/mb_design_lmb_bram_0.v" \

vcom -work axi_lite_ipif_v3_0_4 -64 -93 \
"../../../../mpu_test.srcs/sources_1/bd/mb_design/ipshared/66ea/hdl/axi_lite_ipif_v3_0_vh_rfs.vhd" \

vcom -work mdm_v3_2_16 -64 -93 \
"../../../../mpu_test.srcs/sources_1/bd/mb_design/ipshared/550e/hdl/mdm_v3_2_vh_rfs.vhd" \

vcom -work xil_defaultlib -64 -93 \
"../../../bd/mb_design/ip/mb_design_mdm_1_0/sim/mb_design_mdm_1_0.vhd" \

vlog -work xil_defaultlib -64 -incr "+incdir+../../../../mpu_test.srcs/sources_1/bd/mb_design/ipshared/c923" "+incdir+../../../../mpu_test.srcs/sources_1/bd/mb_design/ipshared/8713/hdl" \
"../../../bd/mb_design/ip/mb_design_clk_wiz_1_0/mb_design_clk_wiz_1_0_clk_wiz.v" \
"../../../bd/mb_design/ip/mb_design_clk_wiz_1_0/mb_design_clk_wiz_1_0.v" \

vcom -work lib_cdc_v1_0_2 -64 -93 \
"../../../../mpu_test.srcs/sources_1/bd/mb_design/ipshared/ef1e/hdl/lib_cdc_v1_0_rfs.vhd" \

vcom -work proc_sys_reset_v5_0_13 -64 -93 \
"../../../../mpu_test.srcs/sources_1/bd/mb_design/ipshared/8842/hdl/proc_sys_reset_v5_0_vh_rfs.vhd" \

vcom -work xil_defaultlib -64 -93 \
"../../../bd/mb_design/ip/mb_design_rst_clk_wiz_1_100M_0/sim/mb_design_rst_clk_wiz_1_100M_0.vhd" \

vlog -work xil_defaultlib -64 -incr "+incdir+../../../../mpu_test.srcs/sources_1/bd/mb_design/ipshared/c923" "+incdir+../../../../mpu_test.srcs/sources_1/bd/mb_design/ipshared/8713/hdl" \
"../../../bd/mb_design/ipshared/5f9b/FIFO_v.v" \
"../../../bd/mb_design/ipshared/5f9b/activation_pipeline.v" \
"../../../bd/mb_design/ipshared/5f9b/axis_rx.v" \
"../../../bd/mb_design/ipshared/5f9b/axis_tx.v" \
"../../../bd/mb_design/ipshared/5f9b/axis_tx_scheduler.v" \
"../../../bd/mb_design/ipshared/5f9b/buffer_a.v" \
"../../../bd/mb_design/ipshared/5f9b/buffer_a_4x.v" \
"../../../bd/mb_design/ipshared/5f9b/buffer_b.v" \
"../../../bd/mb_design/ipshared/5f9b/buffer_b_4x.v" \
"../../../bd/mb_design/ipshared/5f9b/buffer_c.v" \
"../../../bd/mb_design/ipshared/5f9b/delay.v" \
"../../../bd/mb_design/ipshared/5f9b/mac_cell.v" \
"../../../bd/mb_design/ipshared/5f9b/mem_1to2.v" \
"../../../bd/mb_design/ipshared/5f9b/mem_2to2.v" \
"../../../bd/mb_design/ipshared/5f9b/mmu_controller.v" \
"../../../bd/mb_design/ipshared/5f9b/mmu_setup.v" \
"../../../bd/mb_design/ipshared/5f9b/mmu_str.v" \
"../../../bd/mb_design/ipshared/5f9b/mpu.v" \
"../../../bd/mb_design/ipshared/5f9b/out_controller.v" \
"../../../bd/mb_design/ipshared/5f9b/padding_pipeline.v" \
"../../../bd/mb_design/ipshared/5f9b/pooling_max.v" \
"../../../bd/mb_design/ipshared/5f9b/pooling_pipeline.v" \
"../../../bd/mb_design/ipshared/5f9b/single_port_ram.v" \
"../../../bd/mb_design/ipshared/5f9b/top.v" \
"../../../bd/mb_design/ip/mb_design_mpu_0_3/sim/mb_design_mpu_0_3.v" \

vlog -work util_vector_logic_v2_0_1 -64 -incr "+incdir+../../../../mpu_test.srcs/sources_1/bd/mb_design/ipshared/c923" "+incdir+../../../../mpu_test.srcs/sources_1/bd/mb_design/ipshared/8713/hdl" \
"../../../../mpu_test.srcs/sources_1/bd/mb_design/ipshared/2137/hdl/util_vector_logic_v2_0_vl_rfs.v" \

vlog -work xil_defaultlib -64 -incr "+incdir+../../../../mpu_test.srcs/sources_1/bd/mb_design/ipshared/c923" "+incdir+../../../../mpu_test.srcs/sources_1/bd/mb_design/ipshared/8713/hdl" \
"../../../bd/mb_design/ip/mb_design_util_vector_logic_0_0/sim/mb_design_util_vector_logic_0_0.v" \

vlog -work axis_infrastructure_v1_1_0 -64 -incr "+incdir+../../../../mpu_test.srcs/sources_1/bd/mb_design/ipshared/c923" "+incdir+../../../../mpu_test.srcs/sources_1/bd/mb_design/ipshared/8713/hdl" \
"../../../../mpu_test.srcs/sources_1/bd/mb_design/ipshared/8713/hdl/axis_infrastructure_v1_1_vl_rfs.v" \

vlog -work axis_data_fifo_v2_0_1 -64 -incr "+incdir+../../../../mpu_test.srcs/sources_1/bd/mb_design/ipshared/c923" "+incdir+../../../../mpu_test.srcs/sources_1/bd/mb_design/ipshared/8713/hdl" \
"../../../../mpu_test.srcs/sources_1/bd/mb_design/ipshared/e1b1/hdl/axis_data_fifo_v2_0_vl_rfs.v" \

vlog -work xil_defaultlib -64 -incr "+incdir+../../../../mpu_test.srcs/sources_1/bd/mb_design/ipshared/c923" "+incdir+../../../../mpu_test.srcs/sources_1/bd/mb_design/ipshared/8713/hdl" \
"../../../bd/mb_design/ip/mb_design_axis_data_fifo_0_0/sim/mb_design_axis_data_fifo_0_0.v" \
"../../../bd/mb_design/sim/mb_design.v" \

vcom -work interrupt_control_v3_1_4 -64 -93 \
"../../../../mpu_test.srcs/sources_1/bd/mb_design/ipshared/a040/hdl/interrupt_control_v3_1_vh_rfs.vhd" \

vcom -work axi_gpio_v2_0_21 -64 -93 \
"../../../../mpu_test.srcs/sources_1/bd/mb_design/ipshared/9c6e/hdl/axi_gpio_v2_0_vh_rfs.vhd" \

vcom -work xil_defaultlib -64 -93 \
"../../../bd/mb_design/ip/mb_design_axi_gpio_0_0/sim/mb_design_axi_gpio_0_0.vhd" \

vlog -work xil_defaultlib \
"glbl.v"

