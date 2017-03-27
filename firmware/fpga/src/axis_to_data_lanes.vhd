library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity axis_to_data_lanes is
port (
  AxiTDataxDI: in std_logic_vector(13 downto 0);
  AxiTValid: in std_logic;
  DataxDO: out std_logic(13 downto 0);
  DataStrobexDO: out std_logic
);
end axis_to_data_lanes;

architecture V1 of axis_to_data_lanes is
begin
    DataStrobexDO <= AxiTValid;
    DataxDo <= AxiTDataxDI;
end V1;