----------------------------------------------------------------------------------
--
-- full_tb.vhd
--
-- (c) 2017
-- N. Huesser
-- R. Frey
--
----------------------------------------------------------------------------------
-- 
-- A testbench to test the multiplexer with real inputs.
--
----------------------------------------------------------------------------------

use work.multiplexer_pkg.all;

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

    signal tbClkxC: std_logic := '0';
    signal tbRstxRB: std_logic := '0';
    signal tbSelectxDI: std_logic_vector(1 downto 0) := (others => '0');
    signal tbData0xDI: multiplexer_channel_type := (
        data => (others => '0'),
        valid => '0',
        ready => '0'
    );
    signal tbData1xDI: multiplexer_channel_type := (
        data => (0 => '1', others => '0'),
        valid => '1',
        ready => '1'
    );
    signal tbData2xDI: multiplexer_channel_type := (
        data => (others => '0'),
        valid => '0',
        ready => '0'
    );
    signal tbData3xDI: multiplexer_channel_type := (
        data => (others => '0'),
        valid => '0',
        ready => '0'
    ); 
    
    signal tbDataxDO: multiplexer_channel_type := (
        data => (others => '0'),
        valid => '0',
        ready => '0'
    );

begin
    
    -- generate clock
    tbClkxC <= not tbClkxC after 1ns;

    DUT : entity work.multiplexer
    port map (
        ClkxCI => tbClkxC,
        RstxRBI => tbRstxRB,
        DataIn0xDI => tbData0xDI,
        DataIn1xDI => tbData1xDI,
        DataIn2xDI => tbData2xDI,
        DataIn3xDI => tbData3xDI,
        SelectxDI => tbSelectxDI,
        DataOutxDO => tbDataxDO
    );

    process
    begin

        -- write chain of events here
        tbRstxRB <= '0';
        wait until rising_edge(tbClkxC);
        wait until rising_edge(tbClkxC);
        tbRstxRB <= '1';

        -- wait 3 clk cycles
        for i in 0 to 3 loop
          wait until rising_edge(tbClkxC);
        end loop;

        tbSelectxDI <= (0 => '1', others => '0');
        wait;
    end process;
end Behavioral;
