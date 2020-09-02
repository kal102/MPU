--Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
--Date        : Sat Aug 22 13:24:15 2020
--Host        : DESKTOP-A70U0DK running 64-bit major release  (build 9200)
--Command     : generate_target base_mb_wrapper.bd
--Design      : base_mb_wrapper
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity base_mb_wrapper is
  port (
    led_8bits_tri_o : out STD_LOGIC_VECTOR ( 7 downto 0 );
    reset : in STD_LOGIC;
    uart2_pl_rxd : in STD_LOGIC;
    uart2_pl_txd : out STD_LOGIC;
    user_si570_sysclk_clk_n : in STD_LOGIC;
    user_si570_sysclk_clk_p : in STD_LOGIC
  );
end base_mb_wrapper;

architecture STRUCTURE of base_mb_wrapper is
  component base_mb is
  port (
    user_si570_sysclk_clk_n : in STD_LOGIC;
    user_si570_sysclk_clk_p : in STD_LOGIC;
    reset : in STD_LOGIC;
    uart2_pl_rxd : in STD_LOGIC;
    uart2_pl_txd : out STD_LOGIC;
    led_8bits_tri_o : out STD_LOGIC_VECTOR ( 7 downto 0 )
  );
  end component base_mb;
begin
base_mb_i: component base_mb
     port map (
      led_8bits_tri_o(7 downto 0) => led_8bits_tri_o(7 downto 0),
      reset => reset,
      uart2_pl_rxd => uart2_pl_rxd,
      uart2_pl_txd => uart2_pl_txd,
      user_si570_sysclk_clk_n => user_si570_sysclk_clk_n,
      user_si570_sysclk_clk_p => user_si570_sysclk_clk_p
    );
end STRUCTURE;
