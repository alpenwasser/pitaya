----------------------------------------------------------------------------------
--
-- trigger.vhd
--
-- (c) 2015 - 2016
--  L. Schrittwieser
--  N. Huesser
--  D. Walser
--
----------------------------------------------------------------------------------
-- 
-- Trigger logic piece which compares two values
-- and triggers if it matches the configuration (higher, lower).
-- The module has programmable comparison values and modes (higher, lower)
-- The module also features pulse-width triggering
--
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity trigger is

  generic (
    DataWidth      : integer := 14;
    TimeStampWidth : integer := 48;
    TimerWidth     : integer := 14
    );

  port (
    ClkxCI : in std_logic;
    RstxRI : in std_logic;

    DataxDI   : in unsigned(DataWidth - 1 downto 0);
    TimexDI   : in unsigned(TimeStampWidth - 1 downto 0);
    Word1xDI  : in unsigned(DataWidth - 1 downto 0);
    Mode1xSI  : in std_logic;           -- 1 => higher, 0 => lower
    Word2xDI  : in unsigned(TimerWidth - 1 downto 0);
    Mode2xSI  : in unsigned(1 downto 0);  -- 00 => none, 01 => pulse-width-longer, 10 => pulse-width-shorter
    HysterxDI : in unsigned(DataWidth - 1 downto 0);
    ArmxSI    : in std_logic;
    StrobexSI : in std_logic;

    StrobexSO : out std_logic                             := '0';
    FirexSO   : out std_logic                             := '0';
    DataxDO   : out unsigned(DataWidth - 1 downto 0)      := (others => '0');
    TimexDO   : out unsigned(TimeStampWidth - 1 downto 0) := (others => '0')
    );

end trigger;

architecture Behavioral of trigger is

  constant TIMER_MAX : unsigned(TimerWidth - 1 downto 0) := (others => '1');

  signal DataxDP, DataxDN                 : unsigned(DataWidth - 1 downto 0)      := (others => '0');
  signal TimexDP, TimexDN                 : unsigned(TimeStampWidth - 1 downto 0) := (others => '0');
  signal Word1xDN, Word1xDP               : unsigned(DataWidth - 1 downto 0)      := (others => '0');
  signal Mode1xSN, Mode1xSP               : std_logic                             := '0';
  signal Word2xDN, Word2xDP               : unsigned(TimerWidth - 1 downto 0)     := (others => '0');
  signal Mode2xSN, Mode2xSP               : unsigned(1 downto 0)                  := (others => '0');
  signal HysterxDN, HysterxDP             : unsigned(DataWidth - 1 downto 0)      := (others => '0');
  signal FirexS                           : std_logic                             := '0';
  signal FirexSN                          : std_logic                             := '0';
  signal StrobexSN, StrobexSP             : std_logic                             := '0';
  signal ArmedxSP, ArmedxSN               : std_logic                             := '0';
  signal FiredxSN, FiredxSP               : std_logic                             := '0';
  signal TmrCntxDN, TmrCntxDP             : unsigned(TimerWidth - 1 downto 0)     := (others => '0');
  signal WasFulfilledxSN, WasFulfilledxSP : std_logic                             := '0';
  signal RuntStatexSN, RuntStatexSP       : unsigned(2 downto 0)                  := (others => '0');

  signal Greater1xS : std_logic := '0';
  signal Lower1xS   : std_logic := '0';
  signal Greater2xS : std_logic := '0';
  signal Lower2xS   : std_logic := '0';
  
begin

  FirexSO   <= FirexS;
  DataxDO   <= DataxDP;
  TimexDO   <= TimexDP;
  StrobexSN <= StrobexSI;
  StrobexSO <= StrobexSP;
  -- TODO: Map system time to TimexDN

 
  COMP1 : entity work.schmitttrigger
    generic map(
      Width => DataWidth
      )
    port map(
      SigxDI     => DataxDP,
      DeltaxDI   => HysterxDP,
      BotxDI     => Word1xDP,
      GreaterxSO => Greater1xS,
      LowerxSO   => Lower1xS
      );
      
  COMP2 : entity work.schmitttrigger
    generic map(
      Width => DataWidth
      )
    port map(
      SigxDI     => DataxDP,
      DeltaxDI   => HysterxDP,
      BotxDI     => Word2xDP,
      GreaterxSO => Greater2xS,
      LowerxSO   => Lower2xS
      );
      

  process(ArmedxSP, ArmxSI, Word1xDI, Word1xDP, Mode1xSI, Mode1xSP, Mode2xSI,
          Mode2xSP, Word2xDI, Word2xDP, HysterxDI, HysterxDP)
  begin
    ArmedxSN  <= ArmedxSP;               -- default: do nothing
    Word2xDN  <= Word2xDP;
    Word1xDN  <= Word1xDP;
    Mode1xSN  <= Mode1xSP;
    Mode2xSN  <= Mode2xSP;
    HysterxDN <= HysterxDP;

    if ArmxSI = '1' then
      ArmedxSN  <= '1';
      Word1xDN  <= Word1xDI;
      Mode1xSN  <= Mode1xSI;
      Word2xDN  <= Word2xDI;
      Mode2xSN  <= Mode2xSI;
      HysterxDN <= HysterxDI;
    end if;
  end process;

  process(ClkxCI)
  begin
    
    if rising_edge(ClkxCI) then
      DataxDP <= DataxDN;

      if RstxRI = '1' then
        StrobexSP <= StrobexSN;
        Mode1xSP  <= '0';
        Mode2xSP  <= (others => '0');
        Word1xDP  <= (others => '0');

        TimexDP <= (others => '0');

        TmrCntxDP <= (others => '0');
        Word2xDP  <= (others => '0');
        HysterxDP <= (others => '0');

        ArmedxSP <= '0';
        FiredxSP <= '0';

        WasFulfilledxSP <= '0';
        RuntStatexSP <= (others => '0');

      else

        StrobexSP <= StrobexSN;
        Mode1xSP  <= Mode1xSN;
        Mode2xSP  <= Mode2xSN;
        Word1xDP  <= Word1xDN;

        TimexDP <= TimexDN;

        TmrCntxDP <= TmrCntxDN;
        Word2xDP  <= Word2xDN;
        HysterxDP <= HysterxDN;

        ArmedxSP <= ArmedxSN;
        FiredxSP <= FiredxSN;

        WasFulfilledxSP <= WasFulfilledxSN;
        RuntStatexSP <= RuntStatexSN;
      end if;
    end if;
    
  end process;

  process(ArmedxSP, DataxDI, DataxDP, FiredxSP, Greater1xS, Lower1xS, Greater2xS, Lower2xS, Mode1xSP,
          Mode2xSP, StrobexSP, Word2xDP, TmrCntxDP, HysterxDP, WasFulfilledxSP, RuntStatexSP)
  begin
    
    FirexS          <= '0';
    FiredxSN        <= FiredxSP;
    TmrCntxDN       <= TmrCntxDP;
    WasFulfilledxSN <= WasFulfilledxSP;
    RuntStatexSN    <= RuntStatexSP;
    DataxDN         <= DataxDP;

    if StrobexSP = '1' then
      DataxDN <= DataxDI;
    end if;

    -- if trigger is active and has not yet triggered
    if ArmedxSP = '1' and FiredxSP = '0' then
    
      -- if Slope timer is running and precondition for a slope was fulfilled
      if Mode2xSP = "00" and Word2xDP > 0 and WasFulfilledxSP = '1' then
        if Word2xDP <= TmrCntxDP then -- Fire Slope trigger
            FirexS   <= '1';
            FiredxSN <= '1';
        end if;
      end if;
    
      -- Runt / OoW Trigger
      if Mode2xSP = "11" then
        -- Out of Window
        if Word2xDP <= Word1xDP and (Greater1xS = '1' or Lower2xS = '1') then
            FirexS   <= '1';
            FiredxSN <= '1';
            
        -- Runt Trigger Logic
        else
            case RuntStatexSP is
                when "000" => -- not armed yet
                    if Lower1xS = '1' then -- below low level => ready for positive runt pulse
                        RuntStatexSN <= "101";
                    elsif Greater2xS = '1' then -- above high level => ready for negative runt pulse
                        RuntStatexSN <= "100";
                    end if;
                when "101" => -- ready for positive runt pulse
                    if Greater1xS = '1' then -- passing low level for positive runt pulse => ready to fire trigger
                        RuntStatexSN <= "111";
                    end if;
                when "100" => -- ready for negative runt pulse
                    if Lower2xS = '1' then -- passing high level for negative runt pulse => ready to fire trigger
                        RuntStatexSN <= "110";
                    end if;
                when "111" => -- ready to fire trigger for positive runt pulse
                        if Lower1xS = '1' then -- below low level => we have a positive runt pulse!
                            if Mode1xSP = '1' then -- we are indeed looking for a positive runt pulse
                                FirexS   <= '1';
                                FiredxSN <= '1';
                            else -- ignore it and be ready for an additional positive runt pulse
                                RuntStatexSN <= "101";
                            end if;
                        elsif Greater2xS = '1' then -- above high level => was no positive runt pulse => be ready for negative runt pulse
                            RuntStatexSN <= "100";
                        end if;
                when "110" => -- ready to fire trigger for negative runt pulse
                        if Greater2xS = '1' then -- above high level => we have a negative runt pulse!
                            if Mode1xSP = '0' then -- we are indeed looking for a negative runt pulse
                                FirexS   <= '1';
                                FiredxSN <= '1';
                            else -- ignore it and be ready for an additional negative runt pulse
                                RuntStatexSN <= "100";
                            end if;
                        elsif Lower1xS = '1' then -- below low level => was no negative runt pulse => be ready for positive runt pulse
                            RuntStatexSN <= "101";
                        end if;
                when others => null;
            end case;
        end if;
        
      -- Signal stays in between levels for slope measurement
      elsif Mode2xSP = "00" and Lower1xS = '0' and Greater1xS = '0' then
        -- count for slope if possible
        if TmrCntxDP < TIMER_MAX then
            TmrCntxDN <= TmrCntxDP + 1;
        end if;

      -- other Trigger
      elsif (Mode1xSP = '1' and Greater1xS = '1') or (Mode1xSP = '0' and Lower1xS = '1') then

        -- count for pulse-width if possible
        if (Mode2xSP = "10" or Mode2xSP = "01") and TmrCntxDP < TIMER_MAX then
          TmrCntxDN <= TmrCntxDP + 1;
        end if;

        -- Edge trigger
        if Mode2xSP = "00" then
          if Word2xDP > 0 then             -- slope timer mode active
            TmrCntxDN <= (others => '0');  -- "reset" trigger to restart slope timer at next edge and do not! fire the trigger yet
            WasFulfilledxSN <= '0';        -- it has to start a new edge first
          elsif WasFulfilledxSP = '1' then -- usual edge Trigger
            FirexS   <= '1';
            FiredxSN <= '1';
          end if;
          
        -- pulse width longer
        elsif Mode2xSP = "01" then
          if Word2xDP <= TmrCntxDP then
            FirexS   <= '1';
            FiredxSN <= '1';
          end if;

        -- pulse width shorter
        elsif Mode2xSP = "10" then
          WasFulfilledxSN <= '1'; -- start of pulse was reached
        end if;

        -- no Trigger
      elsif (Mode1xSP = '0' and Greater1xS = '1') or (Mode1xSP = '1' and Lower1xS = '1') then
        
        TmrCntxDN <= (others => '0'); -- reset pulse-width timer and set slope timer to zero for start as soon as intended

        if Mode2xSP = "00" then -- Signal is ready to start an edge
            WasFulfilledxSN <= '1';
        end if;

        -- pulse width shorter
        if Mode2xSP = "10" then
          if Word2xDP > TmrCntxDP and WasFulfilledxSP = '1' then -- pulse was indeed shorter!
            FirexS   <= '1';
            FiredxSN <= '1';
          else -- (reset counter and) demand a new pulse
            WasFulfilledxSN <= '0';
          end if;
        end if;
      end if;
    end if;

  end process;

end Behavioral;
