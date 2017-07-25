-- (c) Copyright 1995-2017 Xilinx, Inc. All rights reserved.
-- 
-- This file contains confidential and proprietary information
-- of Xilinx, Inc. and is protected under U.S. and
-- international copyright and other intellectual property
-- laws.
-- 
-- DISCLAIMER
-- This disclaimer is not a license and does not grant any
-- rights to the materials distributed herewith. Except as
-- otherwise provided in a valid license issued to you by
-- Xilinx, and to the maximum extent permitted by applicable
-- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
-- WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
-- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
-- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
-- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
-- (2) Xilinx shall not be liable (whether in contract or tort,
-- including negligence, or under any other theory of
-- liability) for any loss or damage of any kind or nature
-- related to, arising under or in connection with these
-- materials, including for any direct, or any indirect,
-- special, incidental, or consequential loss or damage
-- (including loss of data, profits, goodwill, or any type of
-- loss or damage suffered as a result of any action brought
-- by a third party) even if such damage or loss was
-- reasonably foreseeable or Xilinx had been advised of the
-- possibility of the same.
-- 
-- CRITICAL APPLICATIONS
-- Xilinx products are not designed or intended to be fail-
-- safe, or for use in any application requiring fail-safe
-- performance, such as life-support or safety devices or
-- systems, Class III medical devices, nuclear facilities,
-- applications related to the deployment of airbags, or any
-- other applications that could lead to death, personal
-- injury, or severe property or environmental damage
-- (individually and collectively, "Critical
-- Applications"). Customer assumes the sole risk and
-- liability of any use of Xilinx products in Critical
-- Applications, subject only to applicable laws and
-- regulations governing limitations on product liability.
-- 
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
-- PART OF THIS FILE AT ALL TIMES.
-- 
-- DO NOT MODIFY THIS FILE.

-- IP VLNV: noah-huesser:user:axis_to_data_lanes:1.0
-- IP Revision: 1

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY design_1_axis_to_data_lanes_0_0 IS
  PORT (
    ClkxCI : IN STD_LOGIC;
    RstxRBI : IN STD_LOGIC;
    AxiTDataxDI : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    AxiTValid : IN STD_LOGIC;
    AxiTReady : OUT STD_LOGIC;
    Data0xDO : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    Data1xDO : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    DataStrobexDO : OUT STD_LOGIC
  );
END design_1_axis_to_data_lanes_0_0;

ARCHITECTURE design_1_axis_to_data_lanes_0_0_arch OF design_1_axis_to_data_lanes_0_0 IS
  ATTRIBUTE DowngradeIPIdentifiedWarnings : STRING;
  ATTRIBUTE DowngradeIPIdentifiedWarnings OF design_1_axis_to_data_lanes_0_0_arch: ARCHITECTURE IS "yes";
  COMPONENT axis_to_data_lanes IS
    GENERIC (
      Decimation : INTEGER;
      Offset : INTEGER
    );
    PORT (
      ClkxCI : IN STD_LOGIC;
      RstxRBI : IN STD_LOGIC;
      AxiTDataxDI : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      AxiTValid : IN STD_LOGIC;
      AxiTReady : OUT STD_LOGIC;
      Data0xDO : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
      Data1xDO : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
      DataStrobexDO : OUT STD_LOGIC
    );
  END COMPONENT axis_to_data_lanes;
  ATTRIBUTE X_INTERFACE_INFO : STRING;
  ATTRIBUTE X_INTERFACE_INFO OF ClkxCI: SIGNAL IS "xilinx.com:signal:clock:1.0 SI_clk CLK";
  ATTRIBUTE X_INTERFACE_INFO OF RstxRBI: SIGNAL IS "xilinx.com:signal:reset:1.0 SI_rst RST";
  ATTRIBUTE X_INTERFACE_INFO OF AxiTDataxDI: SIGNAL IS "xilinx.com:interface:axis:1.0 SI TDATA";
  ATTRIBUTE X_INTERFACE_INFO OF AxiTValid: SIGNAL IS "xilinx.com:interface:axis:1.0 SI TVALID";
  ATTRIBUTE X_INTERFACE_INFO OF AxiTReady: SIGNAL IS "xilinx.com:interface:axis:1.0 SI TREADY";
BEGIN
  U0 : axis_to_data_lanes
    GENERIC MAP (
      Decimation => 1,
      Offset => 32768
    )
    PORT MAP (
      ClkxCI => ClkxCI,
      RstxRBI => RstxRBI,
      AxiTDataxDI => AxiTDataxDI,
      AxiTValid => AxiTValid,
      AxiTReady => AxiTReady,
      Data0xDO => Data0xDO,
      Data1xDO => Data1xDO,
      DataStrobexDO => DataStrobexDO
    );
END design_1_axis_to_data_lanes_0_0_arch;
