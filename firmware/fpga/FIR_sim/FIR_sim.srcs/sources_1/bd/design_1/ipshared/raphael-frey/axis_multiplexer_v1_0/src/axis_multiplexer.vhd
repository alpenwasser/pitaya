----------------------------------------------------------------------------------
--
-- axis_multiplexer.vhd
--
-- (c) 2017
-- N. Huesser
-- R. Frey
--
----------------------------------------------------------------------------------
-- 
-- A multiplexer for multiple AXI Streams.
--
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity multiplexer is
  generic (
    C_AXIS_TDATA_WIDTH: integer  := 32;
    C_AXIS_NUM_SI_SLOTS: integer := 2
  );
  port (
    ClkxCI: in std_logic;
    RstxRBI: in std_logic;
    
    SelectxDI: in std_logic_vector (1 downto 0) := (others => '0');

    Data0xDI: in std_logic_vector(C_AXIS_TDATA_WIDTH - 1 downto 0) := (others => '0');
    Data1xDI: in std_logic_vector(C_AXIS_TDATA_WIDTH - 1 downto 0) := (others => '0');
    Data2xDI: in std_logic_vector(C_AXIS_TDATA_WIDTH - 1 downto 0) := (others => '0');
    Data3xDI: in std_logic_vector(C_AXIS_TDATA_WIDTH - 1 downto 0) := (others => '0');
    
    Valid0xSI: in std_logic := '0';
    Valid1xSI: in std_logic := '0';
    Valid2xSI: in std_logic := '0';
    Valid3xSI: in std_logic := '0';

    Ready0xSO: out std_logic := '0';
    Ready1xSO: out std_logic := '0';
    Ready2xSO: out std_logic := '0';
    Ready3xSO: out std_logic := '0';

    DataxDO: out std_logic_vector(C_AXIS_TDATA_WIDTH - 1 downto 0) := (others => '0');
    ValidxSO: out std_logic := '0';
    ReadyxSI: in std_logic := '0'
  );
end multiplexer;

architecture V1 of multiplexer is
begin
    p_converter: process(Data0xDI, Data1xDI, Data2xDI, Data3xDI, Valid0xSI, Valid1xSI, Valid2xSI, Valid3xSI, ReadyxSI ,SelectxDI)
    begin
        case SelectxDI is
            when "00" =>
              DataxDO <= Data0xDI;
              ValidxSO <= Valid0xSI;
              Ready0xSO <= ReadyxSI;
            when "01" =>
              DataxDO <= Data1xDI;
              ValidxSO <= Valid1xSI;
              Ready1xSO <= ReadyxSI;
            when "10" =>
              DataxDO <= Data2xDI;
              ValidxSO <= Valid2xSI;
              Ready2xSO <= ReadyxSI;
            when "11" => 
              DataxDO <= Data3xDI;
              ValidxSO <= Valid3xSI;
              Ready3xSO <= ReadyxSI;
            when others =>
              DataxDO <= Data0xDI;
              ValidxSO <= Valid0xSI;
              Ready0xSO <= ReadyxSI;
        end case;
    end process;
end V1;
