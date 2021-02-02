-- work for MAX1271B
-- https://datasheets.maximintegrated.com/en/ds/MAX1270-MAX1271B.pdf 

library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_misc.all;

library unisim;
use unisim.vcomponents.all;

entity odmb7_voltageMon is
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
end odmb7_voltageMon;

architecture Behavioral of odmb7_voltageMon is

  component clockManager is
    port (
      clk_in1    : in std_logic;
      clk_out10  : out std_logic;
      clk_out40  : out std_logic;
      clk_out80  : out std_logic;
      clk_out160 : out std_logic
      );
  end component;

  --signal mgtrefclk0_224_odiv2 : std_logic;
  --constant  AddrWidth        : integer   := 32;  -- 24 or 32 (3 or 4 byte addr mode)
  type monstates is 
      (S_MON_IDLE, S_MON_ASSCS1, S_MON_CTRLSEQ, S_MON_WAIT);
  signal monstate  : monstates := S_MON_IDLE;

begin

processmon : process (CLK)
  begin
  -- this part only controls sending ctrl sequence
  if rising_edge(CLK) then
  case monstate is 
   when S_MON_IDLE =>
        mon_SpiCsB <= '1';
        if (ctrlseqvalid = '1') then ctrlseq <= "1" & current_channel & "0101"; end if; -- external clk, normal operation 
        if (startchannelvalid = '1') then current_channel <= start_channel; end if; -- 8 channels to read for each chip 
        if (mon_start = '1') then  
          mon_data_valid_cntr <= "000";
          mon_cmdcounter <= x"11";  -- 18 clks conversion  
          mon_rddata <= x"0"; -- 12 bit readback data
          mon_inprogress <= '1';
          monstate <= S_MON_ASSCS1;
         end if;
                       
-----------------   Send 8 bits control sequence -----------------------------------------------------
   when S_MON_ASSCS1 =>
        mon_SpiCsB <= '0';
        mon_cmdreg <=  "1" & current_channel & "0101";  -- Write Enable
        monstate <= S_MON_CTRLSEQ;
          
   when S_MON_CTRLSEQ =>    
        if (mon_cmdcounter /= 18) then mon_cmdcounter <= mon_cmdcounter - 1; 
          mon_cmdreg <= mon_cmdreg(6 downto 0) & '0'; 
        else
          if (current_channel = 7) then 
            current_channel <= start_channel;
            monstate <= S_MON_WAIT; 
            mon_inprogress <= '0';
          else 
            current_channel <= current_channel + 1;
            monstate <= S_MON_ASSCS1;
            mon_cmdcounter <= x"11";
          end if;
        end if;

   when S_MON_WAIT =>
        er_SpiCsB <= '0';
        erstate <= S_S4BMode_WR4BADDR;
                        
   end case;  
 end if;  -- Clk
end process processmon;
end Behavioral;

