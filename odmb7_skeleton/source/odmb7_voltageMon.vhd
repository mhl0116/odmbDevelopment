-- WOrk for MAX1271B
-- https://datasheets.maximintegrated.com/en/ds/MAX1270-MAX1271B.pdf 

library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_misc.all;
use ieee.std_logic_unsigned.all;

library unisim;
use unisim.vcomponents.all;

entity odmb7_voltageMon is
    port (
        CLK      : in  std_logic;
        CLK_div2 : in  std_logic;
        CS       : out std_logic;
        DIN      : out std_logic;
        SCK      : out std_logic;
        DOUT     : in  std_logic;
        DATA     : out std_logic_vector(11 downto 0);

        startchannelvalid  : in std_logic
    );
end odmb7_voltageMon;

architecture Behavioral of odmb7_voltageMon is

    component ila_0 is
        port (
            clk : in std_logic := '0';
            probe0 : in std_logic_vector(7 downto 0) := (others=> '0');
            probe1 : in std_logic := '0';
            probe2 : in std_logic := '0';
            probe3 : in std_logic := '0';
            probe4 : in std_logic_vector(11 downto 0) := (others=> '0');
            probe5 : in std_logic_vector(2 downto 0) := (others=> '0');
            probe6 : in std_logic_vector(4 downto 0) := (others=> '0');
            probe7 : in std_logic_vector(7 downto 0) := (others=> '0');
            probe8 : in std_logic_vector(7 downto 0) := (others=> '0');
            probe9 : in std_logic_vector(7 downto 0) := (others=> '0');
            probe10 : in std_logic_vector(7 downto 0) := (others=> '0');
            probe11 : in std_logic := '0'

        );
    end component;


    signal current_channel : std_logic_vector(2 downto 0) := "000";
    signal mon_SpiCsB : std_logic := '1';
    --signal startchannelvalid : std_logic := '0';
    signal mon_start : std_logic := '0';
    signal mon_cmdcounter  : std_logic_vector(7 downto 0) := x"00";  
    signal mon_cmdreg  : std_logic_vector(7 downto 0) := x"00";  
    signal mon_inprogress  : std_logic := '0';  
    signal ctrlseq_done : std_logic := '0';
    signal data_done : std_logic := '0';
    signal data_valid : std_logic := '0';
    signal data_valid_cntr : std_logic_vector(7 downto 0) := x"00";
    signal dout_data : std_logic_vector(11 downto 0) := x"000"; 
    signal dout_counter: std_logic_vector(7 downto 0) := x"00";
    signal variousflags: std_logic_vector(4 downto 0) := "00000";
    signal ila_trigger1: std_logic_vector(7 downto 0) := x"00";


    -- check table 1 of datasheet
    constant START  : std_logic := '1'; 
    constant STARTCHANNEL  : std_logic_vector(2 downto 0) := "000"; -- 3 bits for 8-channel selection 
    constant RNG : std_logic := '1';
    constant BIP : std_logic := '0';
    constant PD1 : std_logic := '0';
    constant PD0 : std_logic := '1';

    type monstates is 
        (S_MON_IDLE, S_MON_ASSCS1, S_MON_CTRLSEQ, S_MON_WAIT);
    signal monstate  : monstates := S_MON_IDLE;

    type doutstates is 
        (S_DOUT_IDLE, S_DOUT_WAIT, S_DOUT_DATA);
    signal doutstate  : doutstates := S_DOUT_IDLE;

begin

SCK <= CLK;
DIN <= mon_cmdreg(0);
CS <= mon_SpiCsB;
DATA <= dout_data;

processmon : process (CLK)
begin
    -- this part only controls sending ctrl sequence
    if rising_edge(CLK) then
    case monstate is 
        when S_MON_IDLE =>
        mon_SpiCsB <= '1';
        if (startchannelvalid = '1') then current_channel <= STARTCHANNEL; end if; -- 8 channels to read for each chip 
        if (mon_start = '1') then  
            mon_cmdcounter <= x"11";  -- 18 clks conversion  
            mon_inprogress <= '1';
            monstate <= S_MON_ASSCS1;
        end if;
        -- send 8 bits control sequence 
        when S_MON_ASSCS1 =>
            mon_SpiCsB <= '0';
            mon_cmdreg <=  START & current_channel & RNG & BIP & PD1 & PD0; 
            monstate <= S_MON_CTRLSEQ;
          
        when S_MON_CTRLSEQ =>    
            if (mon_cmdcounter /= 17) then mon_cmdcounter <= mon_cmdcounter - 1; 
                mon_cmdreg <= mon_cmdreg(6 downto 0) & '0'; 
            else
                if (current_channel = "111") then 
                    current_channel <= STARTCHANNEL;
                    monstate <= S_MON_WAIT; 
                    mon_inprogress <= '0';
                    ctrlseq_done <= '1';
                else 
                    current_channel <= current_channel + 1;
                    monstate <= S_MON_ASSCS1;
                    mon_cmdcounter <= x"11";
                end if;
            end if;

        -- wait for data finish
        when S_MON_WAIT =>
        if (data_done = '1') then
            monstate <= S_MON_IDLE;
        end if;
   end case;  
 end if;  -- Clk
end process processmon;


----
processdout : process (CLK)
    begin
    -- this part only takes care of get data from dout 
    if rising_edge(CLK) then
    case doutstate is 
    when S_DOUT_IDLE =>
        if (mon_start = '1') then  
            dout_counter <= x"0d";  -- 18 clks conversion, after cs goes low for 13 clk, data starts to arrive  
            data_done <= '0';
            data_valid_cntr <= x"11";
            data_valid <= '0';
            doutstate <= S_DOUT_WAIT;
        end if;

    when S_DOUT_WAIT =>    
        if (dout_counter /= 13) then
         dout_counter <= dout_counter - 1; 
        else
            doutstate <= S_DOUT_DATA;
        end if;
                       
    when S_DOUT_DATA =>    
        data_valid_cntr <= data_valid_cntr + 1;
        if (data_valid_cntr < 12) then -- 12 bits of valid data 
            dout_data <= dout_data(11 downto 1) & DOUT;  
            data_valid <= '0';
        elsif (data_valid_cntr /= 17) then 
            data_valid <= '1';
        else
            data_valid <= '0';
            dout_data <= x"000"; 
            if (ctrlseq_done = '1') then
                doutstate <= S_DOUT_IDLE;
                data_done <= '1';
            end if;  -- if ctrl sequence is done
         end if;
    end case;  
    end if;  -- Clk
end process processdout;

variousflags(0) <= mon_start;
variousflags(1) <= mon_inprogress;
variousflags(2) <= ctrlseq_done;
variousflags(3) <= data_done;
variousflags(4) <= data_valid;

ila_trigger(0) <= mon_start;
ila_trigger(1) <= mon_inprogress;
ila_trigger(2) <= data_done;
ila_trigger(3) <= ctrlseq_done;

i_ila : ila_0
    port map(
        clk => CLK_div2,
        probe0 => ila_trigger1,
        probe1 => mon_SpiCsB,  
        probe2 => mon_cmdreg(0),  
        probe3 => DOUT,  
        probe4 => dout_data,  
        probe5 => current_channel,  
        probe6 => variousflags,  
        probe7 => mon_cmdcounter,  
        probe8 => mon_cmdreg,  
        probe9 => data_valid_cntr,  
        probe10 => dout_counter,  
        probe11 => CLK  
);

end Behavioral;
