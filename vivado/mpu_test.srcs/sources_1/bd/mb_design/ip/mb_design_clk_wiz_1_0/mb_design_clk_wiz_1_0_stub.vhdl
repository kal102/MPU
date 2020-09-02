-- Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
-- Date        : Fri Aug 28 19:36:26 2020
-- Host        : DESKTOP-A70U0DK running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               F:/vivado_projects/mpu/vivado/mpu_test.srcs/sources_1/bd/mb_design/ip/mb_design_clk_wiz_1_0/mb_design_clk_wiz_1_0_stub.vhdl
-- Design      : mb_design_clk_wiz_1_0
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7z020clg484-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mb_design_clk_wiz_1_0 is
  Port ( 
    clk_out1 : out STD_LOGIC;
    reset : in STD_LOGIC;
    locked : out STD_LOGIC;
    clk_in1 : in STD_LOGIC
  );

end mb_design_clk_wiz_1_0;

architecture stub of mb_design_clk_wiz_1_0 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clk_out1,reset,locked,clk_in1";
begin
end;
