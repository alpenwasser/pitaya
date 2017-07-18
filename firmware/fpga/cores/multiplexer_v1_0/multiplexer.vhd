library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

package multiplexer_pkg is
    type multiplexer_channel_type is record
        data : std_logic_vector(31 downto 0);
        valid: std_logic;
        ready: std_logic;
    end record multiplexer_channel_type;
end package;

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use work.multiplexer_pkg.all;

entity multiplexer is
  port (
    ClkxCI: in std_logic;
    RstxRBI: in std_logic;
    SelectxDI: in std_logic_vector (1 downto 0) := (others => '0');

    DataIn0xDI: in multiplexer_channel_type;
    DataIn1xDI: in multiplexer_channel_type;
    DataIn2xDI: in multiplexer_channel_type;
    DataIn3xDI: in multiplexer_channel_type;
    DataOutxDO: out multiplexer_channel_type
  );
end multiplexer;

architecture V1 of multiplexer is
  signal DataxDP, DataxDN : multiplexer_channel_type;
begin

    -- Persistent signal mappings
    DataOutxDO <= DataxDP;

    -- FF logic
    process(ClkxCI)
    begin
      if rising_edge(ClkxCI) then
        if RstxRBI = '0' then
          -- Reset Signals
          DataxDP <= (
              data => (others => '0'),
              valid => '0',
              ready => '0'
          );
        else
          -- Advance signals by 1
          DataxDP <= DataxDN;
        end if;
      end if;
    end process;

    p_converter: process(DataIn0xDI, DataIn1xDI, DataIn2xDI, DataIn3xDI, SelectxDI)
    begin
        case SelectxDI is
            when "00" => DataxDN <= DataIn0xDI;
            when "01" => DataxDN <= DataIn1xDI;
            when "10" => DataxDN <= DataIn2xDI;
            when "11" => DataxDN <= DataIn3xDI;
            when others => DataxDN <= DataIn0xDI;
        end case;
    end process;
end V1;
