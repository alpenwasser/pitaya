----------------------------------------------------------------------------------
--
-- full_tb.vhd
--
-- (c) 2015
-- L. Schrittwieser
-- N. Huesser
--
----------------------------------------------------------------------------------
-- 
-- A testbench to test the logger core with real inputs.
--
----------------------------------------------------------------------------------


library UNISIM;
use UNISIM.VCOMPONENTS.all;
library UNIMACRO;
use UNIMACRO.VCOMPONENTS.all;
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use IEEE.math_real.all;

entity full_tb is
end full_tb;

architecture Behavioral of full_tb is

    -- TODO:
    -- create testsignals here
    signal tbClkxC : std_logic := '0';
    signal tbRstxRB : std_logic := '0';
    signal tbDataxD : std_logic_vector(31 downto 0) := (others => '0');
    signal tbCntxD: signed(15 downto 0) := to_signed(-430, 16);
    signal tbValidxS : std_logic := '0';
    signal tbReadyxS: std_logic := '0';
    signal tbData0xDO: std_logic_vector(15 downto 0) := (others => '0');
    signal tbData1xDO: std_logic_vector(15 downto 0) := (others => '0');
    signal tbStrobexS: std_logic := '0';
    
begin
    
    -- generate clock
    tbClkxC <= not tbClkxC after 1ns;
    tbDataxD <= std_logic_vector(tbCntxD) & std_logic_vector(tbCntxD);

    DUT : entity work.axis_to_data_lanes
    generic map (
      Decimation => 3
    )
    port map (
        ClkxCI => tbClkxC,
        RstxRBI => tbRstxRB,
        AxiTDataxDI=> tbDataxD,
        AxiTValid => tbValidxS,

        AxiTReady => tbReadyxS,
        Data0xDO => tbData0xDO,
        Data1xDO => tbData1xDO,
        DataStrobexDO => tbStrobexS
    );

    process
    begin

        -- TODO:
        -- write chain of events here
        tbRstxRB <= '0';
        wait until rising_edge(tbClkxC);
        wait until rising_edge(tbClkxC);
        tbRstxRB <= '1';
        wait until rising_edge(tbClkxC);

        tbValidxS <= '0';
        for i in 0 to 30 loop
          wait until rising_edge(tbClkxC);
        end loop;

        tbValidxS <= '1';
        for i in 0 to 30 loop
          wait until rising_edge(tbClkxC);
        end loop;

        wait;
    end process;

    process(tbClkxC, tbRstxRB, tbCntxD)
    begin
        if rising_edge(tbClkxC) then
            tbCntxD <= to_signed(-430, 16);
            if tbRstxRB = '1' then
                tbCntxD <= tbCntxD + 1;
            end if;
        end if;
    end process;

end Behavioral;
