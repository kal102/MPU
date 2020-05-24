onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+mb_design -L xil_defaultlib -L xpm -L microblaze_v11_0_1 -L lmb_v10_v3_0_9 -L lmb_bram_if_cntlr_v4_0_16 -L blk_mem_gen_v8_4_3 -L axi_lite_ipif_v3_0_4 -L mdm_v3_2_16 -L lib_cdc_v1_0_2 -L proc_sys_reset_v5_0_13 -L util_vector_logic_v2_0_1 -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.mb_design xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {mb_design.udo}

run -all

endsim

quit -force