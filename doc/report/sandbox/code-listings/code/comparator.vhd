----------------------------------------------------------------------------------
--
-- comparator.vhd
--
-- (c) 2015
-- L. Schrittwieser
-- N. Huesser
--
----------------------------------------------------------------------------------
-- 
-- Old descision piece for the trigger units; obsolete
--
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity comparator is
	generic (
		Width : integer := 14
	);
    port (
        AxDI : in unsigned(Width - 1 downto 0);
        BxDI : in unsigned(Width - 1 downto 0);
        GreaterxSO : out std_logic;
        EqualxSO : out std_logic;
        LowerxSO : out std_logic
    );
end comparator;

architecture Behavioral of comparator is
begin
    process(AxDI, BxDI)
    begin
        GreaterxSO <= '0';
        EqualxSO <= '0';
        LowerxSO <= '0';
        if AxDI > BxDI then
            GreaterxSO <= '1';
        elsif AxDI = BxDI then
            EqualxSO <= '1';
        else
            LowerxSO <= '1';
        end if;
    end process;
end Behavioral;
