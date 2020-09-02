-- Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
-- Date        : Thu Aug 27 21:47:26 2020
-- Host        : DESKTOP-A70U0DK running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               F:/vivado_projects/mpu/vivado/mpu_test.srcs/sources_1/bd/mb_design/ip/mb_design_mpu_0_3/mb_design_mpu_0_3_stub.vhdl
-- Design      : mb_design_mpu_0_3
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7z020clg484-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mb_design_mpu_0_3 is
  Port ( 
    clk : in STD_LOGIC;
    rst_n : in STD_LOGIC;
    axis_in_tdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    axis_in_tvalid : in STD_LOGIC;
    axis_in_tready : out STD_LOGIC;
    axis_in_tlast : in STD_LOGIC;
    axis_out_tdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    axis_out_tvalid : out STD_LOGIC;
    axis_out_tready : in STD_LOGIC;
    axis_out_tlast : out STD_LOGIC
  );

end mb_design_mpu_0_3;

architecture stub of mb_design_mpu_0_3 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clk,rst_n,axis_in_tdata[31:0],axis_in_tvalid,axis_in_tready,axis_in_tlast,axis_out_tdata[31:0],axis_out_tvalid,axis_out_tready,axis_out_tlast";
attribute X_CORE_INFO : string;
attribute X_CORE_INFO of stub : architecture is "top,Vivado 2019.1";
begin
end;
