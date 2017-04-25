library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity axis_to_data_lanes is
port (
  AxiTDataxDI: in std_logic_vector(31 downto 0);
  AxiTValid: in std_logic;
  DataClkxCI: in std_logic;
  DataRstxRBI: in std_logic;
  Data0xDO: out std_logic_vector(13 downto 0);
  Data1xDO: out std_logic_vector(13 downto 0);
  DataStrobexDO: out std_logic;
  DataClkxCO: out std_logic
);
end axis_to_data_lanes;

architecture V1 of axis_to_data_lanes is
begin
    DataStrobexDO <= AxiTValid;
    DataClkxCO <= DataClkxCI;
end V1;