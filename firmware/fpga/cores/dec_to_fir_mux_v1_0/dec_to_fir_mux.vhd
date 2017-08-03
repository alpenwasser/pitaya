library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity dec_to_fir_mux is
  port (
    DecRate: in std_logic_vector(31 downto 0);

    Mux3: out std_logic_vector(1 downto 0);
    Mux2: out std_logic_vector(1 downto 0);
    Mux1: out std_logic_vector(1 downto 0);
    Mux0: out std_logic_vector(1 downto 0);
    MuxF: out std_logic_vector(1 downto 0)
  );
end dec_to_fir_mux;

architecture V1 of dec_to_fir_mux is
begin

    -- Persistent signal mappings

    p_converter: process(DecRate)
    begin
        case to_integer(unsigned(DecRate)) is
            when 5 =>
                Mux0 <= "00";
                Mux1 <= "00";
                Mux2 <= "00";
                Mux3 <= "00";
                MuxF <= "00";
            when 25 =>
                Mux0 <= "00";
                Mux1 <= "00";
                Mux2 <= "01";
                Mux3 <= "00";
                MuxF <= "00";
            when 125 =>
                Mux0 <= "00";
                Mux1 <= "00";
                Mux2 <= "00";
                Mux3 <= "01";
                MuxF <= "01";
            when 625 =>
                Mux0 <= "00";
                Mux1 <= "00";
                Mux2 <= "01";
                Mux3 <= "01";
                MuxF <= "01";
            when 1250 =>
                Mux0 <= "01";
                Mux1 <= "10";
                Mux2 <= "00";
                Mux3 <= "10";
                MuxF <= "01";
            when 2500 =>
                Mux0 <= "01";
                Mux1 <= "01";
                Mux2 <= "00";
                Mux3 <= "10";
                MuxF <= "01";
            when others =>
                Mux0 <= "00";
                Mux1 <= "00";
                Mux2 <= "00";
                Mux3 <= "00";
                MuxF <= "00";
        end case;
    end process;

end V1;
