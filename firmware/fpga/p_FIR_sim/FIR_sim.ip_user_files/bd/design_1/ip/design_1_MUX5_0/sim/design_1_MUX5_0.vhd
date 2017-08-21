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

-- IP VLNV: raphael-frey:user:axis_multiplexer:1.0
-- IP Revision: 1

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY design_1_MUX5_0 IS
  PORT (
    ClkxCI : IN STD_LOGIC;
    RstxRBI : IN STD_LOGIC;
    SelectxDI : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    Data0xDI : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
    Data1xDI : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
    Valid0xSI : IN STD_LOGIC;
    Valid1xSI : IN STD_LOGIC;
    Ready0xSO : OUT STD_LOGIC;
    Ready1xSO : OUT STD_LOGIC;
    DataxDO : OUT STD_LOGIC_VECTOR(23 DOWNTO 0);
    ValidxSO : OUT STD_LOGIC;
    ReadyxSI : IN STD_LOGIC
  );
END design_1_MUX5_0;

ARCHITECTURE design_1_MUX5_0_arch OF design_1_MUX5_0 IS
  ATTRIBUTE DowngradeIPIdentifiedWarnings : STRING;
  ATTRIBUTE DowngradeIPIdentifiedWarnings OF design_1_MUX5_0_arch: ARCHITECTURE IS "yes";
  COMPONENT multiplexer IS
    GENERIC (
      C_AXIS_TDATA_WIDTH : INTEGER;
      C_AXIS_NUM_SI_SLOTS : INTEGER
    );
    PORT (
      ClkxCI : IN STD_LOGIC;
      RstxRBI : IN STD_LOGIC;
      SelectxDI : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
      Data0xDI : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
      Data1xDI : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
      Data2xDI : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
      Data3xDI : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
      Valid0xSI : IN STD_LOGIC;
      Valid1xSI : IN STD_LOGIC;
      Valid2xSI : IN STD_LOGIC;
      Valid3xSI : IN STD_LOGIC;
      Ready0xSO : OUT STD_LOGIC;
      Ready1xSO : OUT STD_LOGIC;
      Ready2xSO : OUT STD_LOGIC;
      Ready3xSO : OUT STD_LOGIC;
      DataxDO : OUT STD_LOGIC_VECTOR(23 DOWNTO 0);
      ValidxSO : OUT STD_LOGIC;
      ReadyxSI : IN STD_LOGIC
    );
  END COMPONENT multiplexer;
  ATTRIBUTE X_INTERFACE_INFO : STRING;
  ATTRIBUTE X_INTERFACE_INFO OF ClkxCI: SIGNAL IS "xilinx.com:signal:clock:1.0 SI_clk CLK";
  ATTRIBUTE X_INTERFACE_INFO OF RstxRBI: SIGNAL IS "xilinx.com:signal:reset:1.0 SI_rst RST";
  ATTRIBUTE X_INTERFACE_INFO OF Data0xDI: SIGNAL IS "xilinx.com:interface:axis:1.0 SI0 TDATA";
  ATTRIBUTE X_INTERFACE_INFO OF Data1xDI: SIGNAL IS "xilinx.com:interface:axis:1.0 SI1 TDATA";
  ATTRIBUTE X_INTERFACE_INFO OF Valid0xSI: SIGNAL IS "xilinx.com:interface:axis:1.0 SI0 TVALID";
  ATTRIBUTE X_INTERFACE_INFO OF Valid1xSI: SIGNAL IS "xilinx.com:interface:axis:1.0 SI1 TVALID";
  ATTRIBUTE X_INTERFACE_INFO OF Ready0xSO: SIGNAL IS "xilinx.com:interface:axis:1.0 SI0 TREADY";
  ATTRIBUTE X_INTERFACE_INFO OF Ready1xSO: SIGNAL IS "xilinx.com:interface:axis:1.0 SI1 TREADY";
  ATTRIBUTE X_INTERFACE_INFO OF DataxDO: SIGNAL IS "xilinx.com:interface:axis:1.0 MO TDATA";
  ATTRIBUTE X_INTERFACE_INFO OF ValidxSO: SIGNAL IS "xilinx.com:interface:axis:1.0 MO TVALID";
  ATTRIBUTE X_INTERFACE_INFO OF ReadyxSI: SIGNAL IS "xilinx.com:interface:axis:1.0 MO TREADY";
BEGIN
  U0 : multiplexer
    GENERIC MAP (
      C_AXIS_TDATA_WIDTH => 24,
      C_AXIS_NUM_SI_SLOTS => 2
    )
    PORT MAP (
      ClkxCI => ClkxCI,
      RstxRBI => RstxRBI,
      SelectxDI => SelectxDI,
      Data0xDI => Data0xDI,
      Data1xDI => Data1xDI,
      Data2xDI => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 24)),
      Data3xDI => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 24)),
      Valid0xSI => Valid0xSI,
      Valid1xSI => Valid1xSI,
      Valid2xSI => '0',
      Valid3xSI => '0',
      Ready0xSO => Ready0xSO,
      Ready1xSO => Ready1xSO,
      DataxDO => DataxDO,
      ValidxSO => ValidxSO,
      ReadyxSI => ReadyxSI
    );
END design_1_MUX5_0_arch;
