library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity axis_to_data_lanes is
  generic (
    Decimation: integer := 125;
    Offset: integer := 8192
  );
  port (
    ClkxCI: in std_logic;
    RstxRBI: in std_logic;
    AxiTDataxDI: in std_logic_vector(31 downto 0) := (others => '0');
    AxiTValid: in std_logic := '0';

    AxiTReady: out std_logic;
    Data0xDO: out std_logic_vector(15 downto 0);
    Data1xDO: out std_logic_vector(15 downto 0);
    DataStrobexDO: out std_logic
  );
end axis_to_data_lanes;

architecture V1 of axis_to_data_lanes is
  signal DataxDP, DataxDN : std_logic_vector(31 downto 0) := (others => '0');
  signal StrobexDP, StrobexDN : std_logic := '0';
  signal CntxDP, CntxDN: unsigned(16 downto 0) := (others => '0');
begin

    -- Persistent signal mappings
    Data0xDO <= DataxDP(15 downto 0);
    Data1xDO <= DataxDP(31 downto 16);
    DataStrobexDO <= StrobexDP;

      -- FF logic
    process(ClkxCI)
    begin
      if rising_edge(ClkxCI) then
        if RstxRBI = '0' then
          -- Reset Signals
          DataxDP <= (others => '0');
          StrobexDP <= '0';
          CntxDP <= (others => '0');
          AxiTReady <= '0';
        else
          -- Advance signals by 1
          DataxDP <= DataxDN;
          StrobexDP <= StrobexDN;
          CntxDP <= CntxDN;
          AxiTReady <= '1';
        end if;
      end if;
    end process;

    p_Converter: process(AxiTValid, CntxDP, AxiTDataxDI)
      variable X: std_logic_vector(15 downto 0);
      variable Y: std_logic_vector(15 downto 0);
      variable A: std_logic_vector(15 downto 0);
      variable B: std_logic_vector(15 downto 0);
    begin
      --if AxiTValid = '1' then
        -- receive every nth sample
        if CntxDP = Decimation - 1 then
          A := AxiTDataxDI(15 downto 0);
          B := AxiTDataxDI(31 downto 16);
          X := std_logic_vector(signed(A) + Offset);
          Y := std_logic_vector(signed(B) + Offset);
          DataxDN <= Y & X;
--          DataxDN <= AxiTDataxDI;
          StrobexDN <= '1';
          CntxDN <= (others => '0');
        else
          DataxDN <= DataxDP;
          CntxDN <= CntxDP + 1;
          StrobexDN <= '0';
        end if;
      --end if;
    end process;
end V1;