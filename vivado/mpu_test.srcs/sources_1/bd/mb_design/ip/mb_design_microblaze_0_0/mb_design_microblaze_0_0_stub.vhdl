-- Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
-- Date        : Sun May 24 17:24:56 2020
-- Host        : LEN running 64-bit Service Pack 1  (build 7601)
-- Command     : write_vhdl -force -mode synth_stub
--               C:/Users/Lukasz/workspace/mpu/vivado/mpu_test.srcs/sources_1/bd/mb_design/ip/mb_design_microblaze_0_0/mb_design_microblaze_0_0_stub.vhdl
-- Design      : mb_design_microblaze_0_0
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7z020clg484-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mb_design_microblaze_0_0 is
  Port ( 
    Clk : in STD_LOGIC;
    Reset : in STD_LOGIC;
    Interrupt : in STD_LOGIC;
    Interrupt_Address : in STD_LOGIC_VECTOR ( 0 to 31 );
    Interrupt_Ack : out STD_LOGIC_VECTOR ( 0 to 1 );
    Instr_Addr : out STD_LOGIC_VECTOR ( 0 to 31 );
    Instr : in STD_LOGIC_VECTOR ( 0 to 31 );
    IFetch : out STD_LOGIC;
    I_AS : out STD_LOGIC;
    IReady : in STD_LOGIC;
    IWAIT : in STD_LOGIC;
    ICE : in STD_LOGIC;
    IUE : in STD_LOGIC;
    Data_Addr : out STD_LOGIC_VECTOR ( 0 to 31 );
    Data_Read : in STD_LOGIC_VECTOR ( 0 to 31 );
    Data_Write : out STD_LOGIC_VECTOR ( 0 to 31 );
    D_AS : out STD_LOGIC;
    Read_Strobe : out STD_LOGIC;
    Write_Strobe : out STD_LOGIC;
    DReady : in STD_LOGIC;
    DWait : in STD_LOGIC;
    DCE : in STD_LOGIC;
    DUE : in STD_LOGIC;
    Byte_Enable : out STD_LOGIC_VECTOR ( 0 to 3 );
    Dbg_Clk : in STD_LOGIC;
    Dbg_TDI : in STD_LOGIC;
    Dbg_TDO : out STD_LOGIC;
    Dbg_Reg_En : in STD_LOGIC_VECTOR ( 0 to 7 );
    Dbg_Shift : in STD_LOGIC;
    Dbg_Capture : in STD_LOGIC;
    Dbg_Update : in STD_LOGIC;
    Debug_Rst : in STD_LOGIC;
    Dbg_Disable : in STD_LOGIC;
    M0_AXIS_TLAST : out STD_LOGIC;
    M0_AXIS_TDATA : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M0_AXIS_TVALID : out STD_LOGIC;
    M0_AXIS_TREADY : in STD_LOGIC;
    S0_AXIS_TLAST : in STD_LOGIC;
    S0_AXIS_TDATA : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S0_AXIS_TVALID : in STD_LOGIC;
    S0_AXIS_TREADY : out STD_LOGIC
  );

end mb_design_microblaze_0_0;

architecture stub of mb_design_microblaze_0_0 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "Clk,Reset,Interrupt,Interrupt_Address[0:31],Interrupt_Ack[0:1],Instr_Addr[0:31],Instr[0:31],IFetch,I_AS,IReady,IWAIT,ICE,IUE,Data_Addr[0:31],Data_Read[0:31],Data_Write[0:31],D_AS,Read_Strobe,Write_Strobe,DReady,DWait,DCE,DUE,Byte_Enable[0:3],Dbg_Clk,Dbg_TDI,Dbg_TDO,Dbg_Reg_En[0:7],Dbg_Shift,Dbg_Capture,Dbg_Update,Debug_Rst,Dbg_Disable,M0_AXIS_TLAST,M0_AXIS_TDATA[31:0],M0_AXIS_TVALID,M0_AXIS_TREADY,S0_AXIS_TLAST,S0_AXIS_TDATA[31:0],S0_AXIS_TVALID,S0_AXIS_TREADY";
attribute x_core_info : string;
attribute x_core_info of stub : architecture is "MicroBlaze,Vivado 2019.1";
begin
end;
