library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_misc.all;

library unisim;
use unisim.vcomponents.all;

entity odmb7_voltageMon_wrapper is
    port (
      CLK            : in  std_logic;
      ADC_CS0_18     : out std_logic;
      ADC_CS1_18     : out std_logic;
      ADC_CS2_18     : out std_logic;
      ADC_CS3_18     : out std_logic;
      ADC_CS4_18     : out std_logic;
      ADC_DIN_18     : out std_logic;
      ADC_SCK_18     : out std_logic; 
      ADC_DOUT_18    : in  std_logic
    );
end odmb7_voltageMon_wrapper;

architecture Behavioral of odmb7_voltageMon_wrapper is
  component odmb7_voltageMon is
    port (
        CLK    : in  std_logic;
        CS     : out std_logic;
        DIN    : out std_logic;
        SCK    : out std_logic;
        DOUT   : in  std_logic;
        DATA   : out std_logic_vector(11 downto 0)
   );
  end component;

  -- add ILA and VIO here
  signal CS   : std_logic := '0';
  signal dout_data : std_logic_vector(11 downto 0) := x"000"; 

begin

    -- depend on input value from VIO or VME command, decide which CS to use
    ADC_CS0_18 <= CS; -- for now

    u_voltageMon : odmb7_voltageMon
        port map (
            CLK  => CLK,
            CS   => CS,
            DIN  => ADC_DIN_18,
            SCK  => ADC_SCK_18,
            DOUT => ADC_DOUT_18,
            DATA => dout_data
    );

end Behavioral;
