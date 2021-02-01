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
  if rising_edge(CLK) then
  case monstate is 
   when S_MON_IDLE =>
        mon_SpiCsB <= '1';
        if (ctrlseqvalid = '1') then ctrlseq <= ctrl_seq; end if;  
        if (startchannelvalid = '1') then startchannel <= start_channel; end if; -- 8 channels to read for each chip 
        if (mon_start = '1') then  
          mon_data_valid_cntr <= "000";
          mon_cmdcounter8 <= "111";  -- 8 bit command control sequence 
          mon_rddata <= "0000"; -- 12 bit readback data
          mon_cmdreg8 <=  ctrlseq;  -- Write Enable
          mon_inprogress <= '1';
          monstate <= S_MON_ASSCS1;
         end if;
                       
-----------------   Send 8 bits control sequence -----------------------------------------------------
   when S_MON_ASSCS1 =>
        mon_SpiCsB <= '0';
        monstate <= S_MON_CTRLSEQ;
          
   when S_MON_CTRLSEQ =>    
        if (mon_cmdcounter8 /= 8) then mon_cmdcounter8 <= mon_cmdcounter8 - 1; 
          mon_cmdreg8 <= mon_cmdreg8(6 downto 0) & '0'; 
        else
          mon_cmdreg8 <=  Cmd4BMode  & X"00000000";  -- Flag Status register
          mon_cmdcounter8 <= "100111";  -- 40 bit command+addr
          mon_SpiCsB <= '0';   -- turn off SPI 
          monstate <= S_MON_WAIT; 
        end if;
        
   when S_S4BMode_ASSCS2 =>
        er_SpiCsB <= '0';
        erstate <= S_S4BMode_WR4BADDR;
                        
   when S_S4BMode_WR4BADDR =>    -- Set 4-Byte address Mode
        if (er_cmdcounter32 /= 32) then er_cmdcounter32 <= er_cmdcounter32 - 1;  
           er_cmdreg32 <= er_cmdreg32(38 downto 0) & '0';
        else 
          er_SpiCsB <= '1';   -- turn off SPI
          er_cmdcounter32 <= "100111";  -- 32 bit command
          er_cmdreg32 <=  CmdWE & X"00000000";  -- Write Enable 
          erstate <= S_ER_ASSCS1;  
        end if;  
-------------------------  end set 4 byte Mode

   when S_ER_ASSCS1 =>
        erstate <= S_ER_WRCMD;
        er_SpiCsB <= '0';
        er_status <= "11";
                  
   when S_ER_WRCMD =>    -- Set WE bit
         if (er_cmdcounter32 /= 32) then er_cmdcounter32 <= er_cmdcounter32 - 1;  
           er_cmdreg32 <= er_cmdreg32(38 downto 0) & '0';
         else 
           er_SpiCsB <= '1';   -- turn off SPI
           er_cmdreg32 <=  CmdSSE24 & er_current_sector_addr;  -- 4-Byte Sector erase 
           er_cmdcounter32 <= "100111";
           erstate <= S_ER_ASSCS2;        
         end if;
                   
   when S_ER_ASSCS2 =>
        er_SpiCsB <= '0';   
        erstate <= S_ER_ERASECMD;
                      
   when S_ER_ERASECMD =>     -- send erase command
        er_cmdreg32 <= er_cmdreg32(38 downto 0) & '0';
        if (er_cmdcounter32 /= 0) then er_cmdcounter32 <= er_cmdcounter32 - 1; -- send erase + 24 bit address
        else
          er_SpiCsB <= '1';   -- turn off SPI
          er_cmdcounter32 <= "100111";
          er_cmdreg32 <=  CmdStatus & X"00000000";  -- Read Status register
          erstate <= S_ER_ASSCS3;
        end if;
                                      
   when S_ER_ASSCS3 =>
        er_SpiCsB <= '0';   
        erstate <= S_ER_RDSTAT;
                  
   when S_ER_RDSTAT =>     -- read status register....X03 = Program/erase in progress 
        if (er_cmdcounter32 >= 31) then er_cmdcounter32 <= er_cmdcounter32 - 1;
            er_cmdreg32 <= er_cmdreg32(38 downto 0) & '0';
        else
          er_data_valid_cntr <= er_data_valid_cntr + 1;
          er_rddata <= er_rddata(1) & SpiMiso;  -- deser 1:8 
          if (er_data_valid_cntr = 7) then  -- Check Status after 8 bits (+1) of status read
            er_status <= er_rddata;   -- Check WE and ERASE in progress one cycle after er_rddate
            if (er_status = 0) then
              if (er_sector_count = 0) then 
                erstate <= S_ER_IDLE;   -- Done. All sectors erased
                erase_inprogress <= '0';
              else 
                er_current_sector_addr <= er_current_sector_addr + SubSectorSize;
                er_sector_count <= er_sector_count - 1;
                er_cmdreg32 <=  CmdWE & X"00000000";   
                er_cmdcounter32 <= "100111";
                er_SpiCsB <= '1';
                erstate <= S_ER_ASSCS1;
              end if;
            end if; -- if status
          end if;  -- if rddata valid
        end if; -- cmdcounter /= 32
   end case;  
 end if;  -- Clk
end process processmon;
end Behavioral;

