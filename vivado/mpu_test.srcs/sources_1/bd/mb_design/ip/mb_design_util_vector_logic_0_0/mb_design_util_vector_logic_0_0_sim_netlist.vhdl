-- Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
-- Date        : Sun May 24 17:23:48 2020
-- Host        : LEN running 64-bit Service Pack 1  (build 7601)
-- Command     : write_vhdl -force -mode funcsim
--               C:/Users/Lukasz/workspace/mpu/vivado/mpu_test.srcs/sources_1/bd/mb_design/ip/mb_design_util_vector_logic_0_0/mb_design_util_vector_logic_0_0_sim_netlist.vhdl
-- Design      : mb_design_util_vector_logic_0_0
-- Purpose     : This VHDL netlist is a functional simulation representation of the design and should not be modified or
--               synthesized. This netlist cannot be used for SDF annotated simulation.
-- Device      : xc7z020clg484-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity mb_design_util_vector_logic_0_0_util_vector_logic_v2_0_1_util_vector_logic is
  port (
    Res : out STD_LOGIC_VECTOR ( 7 downto 0 );
    Op1 : in STD_LOGIC_VECTOR ( 7 downto 0 )
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of mb_design_util_vector_logic_0_0_util_vector_logic_v2_0_1_util_vector_logic : entity is "util_vector_logic_v2_0_1_util_vector_logic";
end mb_design_util_vector_logic_0_0_util_vector_logic_v2_0_1_util_vector_logic;

architecture STRUCTURE of mb_design_util_vector_logic_0_0_util_vector_logic_v2_0_1_util_vector_logic is
begin
\Res[0]_INST_0\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => Op1(0),
      O => Res(0)
    );
\Res[1]_INST_0\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => Op1(1),
      O => Res(1)
    );
\Res[2]_INST_0\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => Op1(2),
      O => Res(2)
    );
\Res[3]_INST_0\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => Op1(3),
      O => Res(3)
    );
\Res[4]_INST_0\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => Op1(4),
      O => Res(4)
    );
\Res[5]_INST_0\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => Op1(5),
      O => Res(5)
    );
\Res[6]_INST_0\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => Op1(6),
      O => Res(6)
    );
\Res[7]_INST_0\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => Op1(7),
      O => Res(7)
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity mb_design_util_vector_logic_0_0 is
  port (
    Op1 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    Res : out STD_LOGIC_VECTOR ( 7 downto 0 )
  );
  attribute NotValidForBitStream : boolean;
  attribute NotValidForBitStream of mb_design_util_vector_logic_0_0 : entity is true;
  attribute CHECK_LICENSE_TYPE : string;
  attribute CHECK_LICENSE_TYPE of mb_design_util_vector_logic_0_0 : entity is "mb_design_util_vector_logic_0_0,util_vector_logic_v2_0_1_util_vector_logic,{}";
  attribute DowngradeIPIdentifiedWarnings : string;
  attribute DowngradeIPIdentifiedWarnings of mb_design_util_vector_logic_0_0 : entity is "yes";
  attribute X_CORE_INFO : string;
  attribute X_CORE_INFO of mb_design_util_vector_logic_0_0 : entity is "util_vector_logic_v2_0_1_util_vector_logic,Vivado 2019.1";
end mb_design_util_vector_logic_0_0;

architecture STRUCTURE of mb_design_util_vector_logic_0_0 is
begin
inst: entity work.mb_design_util_vector_logic_0_0_util_vector_logic_v2_0_1_util_vector_logic
     port map (
      Op1(7 downto 0) => Op1(7 downto 0),
      Res(7 downto 0) => Res(7 downto 0)
    );
end STRUCTURE;
