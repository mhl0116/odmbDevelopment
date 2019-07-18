-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /    Vendor: Xilinx
-- \   \   \/     Version : 1.7
--  \   \         Application : Virtex-6 FPGA GTX Transceiver Wizard
--  /   /         Filename : wrapper_gigalink_pc_gtx.vhd
-- /___/   /\     Timestamp :
-- \   \  /  \ 
--  \___\/\___\
--
--
-- Module WRAPPER_GIGALINK_PC_GTX (a GTX Wrapper)
-- Generated by Xilinx Virtex-6 FPGA GTX Transceiver Wizard
-- 
-- 
-- (c) Copyright 2009-2010 Xilinx, Inc. All rights reserved.
-- 
-- This file contains confidential and proprietary information
-- of Xilinx, Inc. and is protected under U.S. and
-- international copyright and other intellectual property
-- laws.
-- 
-- DISCLAIMER
-- This disclaimer is not a license and does not grant any
-- rights to the materials distributed herewith. Except as
-- otherwise provided in a valid license issued to you by
-- Xilinx, and to the maximum extent permitted by applicable
-- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
-- WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
-- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
-- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
-- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
-- (2) Xilinx shall not be liable (whether in contract or tort,
-- including negligence, or under any other theory of
-- liability) for any loss or damage of any kind or nature
-- related to, arising under or in connection with these
-- materials, including for any direct, or any indirect,
-- special, incidental, or consequential loss or damage
-- (including loss of data, profits, goodwill, or any type of
-- loss or damage suffered as a result of any action brought
-- by a third party) even if such damage or loss was
-- reasonably foreseeable or Xilinx had been advised of the
-- possibility of the same.
-- 
-- CRITICAL APPLICATIONS
-- Xilinx products are not designed or intended to be fail-
-- safe, or for use in any application requiring fail-safe
-- performance, such as life-support or safety devices or
-- systems, Class III medical devices, nuclear facilities,
-- applications related to the deployment of airbags, or any
-- other applications that could lead to death, personal
-- injury, or severe property or environmental damage
-- (individually and collectively, "Critical
-- Applications"). Customer assumes the sole risk and
-- liability of any use of Xilinx products in Critical
-- Applications, subject only to applicable laws and
-- regulations governing limitations on product liability.
-- 
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
-- PART OF THIS FILE AT ALL TIMES. 


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library UNISIM;
use UNISIM.VCOMPONENTS.all;

--***************************** Entity Declaration ****************************

entity WRAPPER_GIGALINK_PC_GTX is
  generic
    (
      -- Simulation attributes
      GTX_SIM_GTXRESET_SPEEDUP : integer := 0;  -- Set to 1 to speed up sim reset

      -- Share RX PLL parameter
      GTX_TX_CLK_SOURCE : string     := "TXPLL";
      -- Save power parameter
      GTX_POWER_SAVE    : bit_vector := "0000000000"
      );
  port
    (
      ------------------------ Loopback and Powerdown Ports ----------------------
      LOOPBACK_IN       : in  std_logic_vector(2 downto 0);
      RXPOWERDOWN_IN    : in  std_logic_vector(1 downto 0);
      ----------------------- Receive Ports - 8b10b Decoder ----------------------
      RXCHARISK_OUT     : out std_logic_vector(1 downto 0);
      RXDISPERR_OUT     : out std_logic_vector(1 downto 0);
      RXNOTINTABLE_OUT  : out std_logic_vector(1 downto 0);
      RXRUNDISP_OUT     : out std_logic_vector(1 downto 0);
      ------------------- Receive Ports - Clock Correction Ports -----------------
      RXCLKCORCNT_OUT   : out std_logic_vector(2 downto 0);
      --------------- Receive Ports - Comma Detection and Alignment --------------
      RXBYTEREALIGN_OUT : out std_logic;
      ------------------- Receive Ports - RX Data Path interface -----------------
      RXDATA_OUT        : out std_logic_vector(15 downto 0);
      RXVALID_OUT       : out std_logic;
      RXRESET_IN        : in  std_logic;
      RXUSRCLK2_IN      : in  std_logic;
      ------- Receive Ports - RX Driver,OOB signalling,Coupling and Eq.,CDR ------
      RXELECIDLE_OUT    : out std_logic;
      RXN_IN            : in  std_logic;
      RXP_IN            : in  std_logic;
      ------------------------ Receive Ports - RX PLL Ports ----------------------
      GTXRXRESET_IN     : in  std_logic;
      MGTREFCLKRX_IN    : in  std_logic_vector(1 downto 0);
      PLLRXRESET_IN     : in  std_logic;
      RXPLLLKDET_OUT    : out std_logic;
      RXRESETDONE_OUT   : out std_logic;
      ---------------- Transmit Ports - 8b10b Encoder Control Ports --------------
      TXCHARISK_IN      : in  std_logic_vector(1 downto 0);
      ------------------------- Transmit Ports - GTX Ports -----------------------
      GTXTEST_IN        : in  std_logic_vector(12 downto 0);
      ------------------ Transmit Ports - TX Data Path interface -----------------
      TXDATA_IN         : in  std_logic_vector(15 downto 0);
      TXOUTCLK_OUT      : out std_logic;
      TXRESET_IN        : in  std_logic;
      TXUSRCLK2_IN      : in  std_logic;
      ---------------- Transmit Ports - TX Driver and OOB signaling --------------
      TXDIFFCTRL_IN     : in  std_logic_vector(3 downto 0);
      TXN_OUT           : out std_logic;
      TXP_OUT           : out std_logic;
      --------------- Transmit Ports - TX Driver and OOB signalling --------------
      TXPREEMPHASIS_IN  : in  std_logic_vector(3 downto 0);
      ----------------------- Transmit Ports - TX PLL Ports ----------------------
      GTXTXRESET_IN     : in  std_logic;
      MGTREFCLKTX_IN    : in  std_logic_vector(1 downto 0);
      PLLTXRESET_IN     : in  std_logic;
      TXPLLLKDET_OUT    : out std_logic;
      TXRESETDONE_OUT   : out std_logic;
      -- PRBS Ports --------------------------------------------------------------
      PRBSCNTRESET_IN   : in  std_logic;
      ENTXPRBSTST_IN    : in  std_logic_vector(2 downto 0);
      ENRXPRBSTST_IN    : in  std_logic_vector(2 downto 0);
      -- DRP Ports ---------------------------------------------------------------
      DCLK_IN           : in  std_logic;
      DEN_IN            : in  std_logic;
      DRPDO_OUT         : out std_logic_vector(15 downto 0)
      );


end WRAPPER_GIGALINK_PC_GTX;

architecture RTL of WRAPPER_GIGALINK_PC_GTX is

--**************************** Signal Declarations ****************************

  -- ground and tied_to_vcc_i signals
  signal tied_to_ground_i     : std_logic;
  signal tied_to_ground_vec_i : std_logic_vector(63 downto 0);
  signal tied_to_vcc_i        : std_logic;



  -- RX Datapath signals
  signal rxdata_i              : std_logic_vector(31 downto 0);
  signal rxchariscomma_float_i : std_logic_vector(1 downto 0);
  signal rxcharisk_float_i     : std_logic_vector(1 downto 0);
  signal rxdisperr_float_i     : std_logic_vector(1 downto 0);
  signal rxnotintable_float_i  : std_logic_vector(1 downto 0);
  signal rxrundisp_float_i     : std_logic_vector(1 downto 0);



  -- TX Datapath signals
  signal txdata_i          : std_logic_vector(31 downto 0);
  signal txkerr_float_i    : std_logic_vector(1 downto 0);
  signal txrundisp_float_i : std_logic_vector(1 downto 0);

--******************************** Main Body of Code***************************
  
begin

  ---------------------------  Static signal Assignments ---------------------   

  tied_to_ground_i                  <= '0';
  tied_to_ground_vec_i(63 downto 0) <= (others => '0');
  tied_to_vcc_i                     <= '1';

  -------------------  GTX Datapath byte mapping  -----------------

  -- The GTX provides little endian data (first byte received on RXDATA(7 downto 0))
  RXDATA_OUT <= rxdata_i(15 downto 0);

  txdata_i <= (tied_to_ground_vec_i(15 downto 0) & TXDATA_IN);



  ----------------------------- GTX Instance  --------------------------   

  gtxe1_i : GTXE1
    generic map
    (

      --_______________________ Simulation-Only Attributes ___________________

      SIM_RECEIVER_DETECT_PASS => (true),

      SIM_GTXRESET_SPEEDUP => (GTX_SIM_GTXRESET_SPEEDUP),

      SIM_TX_ELEC_IDLE_LEVEL => ("X"),

      SIM_VERSION         => ("2.0"),
      SIM_TXREFCLK_SOURCE => ("000"),
      SIM_RXREFCLK_SOURCE => ("000"),


      ----------------------------TX PLL----------------------------
      TX_CLK_SOURCE      => (GTX_TX_CLK_SOURCE),
      TX_OVERSAMPLE_MODE => (false),
      TXPLL_COM_CFG      => (x"21680a"),
      TXPLL_CP_CFG       => (x"0D"),
      TXPLL_DIVSEL_FB    => (2),
      TXPLL_DIVSEL_OUT   => (2),
      TXPLL_DIVSEL_REF   => (1),
      TXPLL_DIVSEL45_FB  => (5),
      TXPLL_LKDET_CFG    => ("111"),
      TX_CLK25_DIVIDER   => (5),
      TXPLL_SATA         => ("00"),
      TX_TDCC_CFG        => ("00"),
      PMA_CAS_CLK_EN     => (false),
      POWER_SAVE         => (GTX_POWER_SAVE),

      -------------------------TX Interface-------------------------
      GEN_TXUSRCLK  => (true),
      TX_DATA_WIDTH => (20),
      TX_USRCLK_CFG => (x"00"),
      TXOUTCLK_CTRL => ("TXPLLREFCLK_DIV1"),
      TXOUTCLK_DLY  => ("0000000000"),

      --------------TX Buffering and Phase Alignment----------------
      TX_PMADATA_OPT          => ('0'),
      PMA_TX_CFG              => (x"80082"),
      TX_BUFFER_USE           => (true),
      TX_BYTECLK_CFG          => (x"00"),
      TX_EN_RATE_RESET_BUF    => (true),
      TX_XCLK_SEL             => ("TXOUT"),
      TX_DLYALIGN_CTRINC      => ("0100"),
      TX_DLYALIGN_LPFINC      => ("0110"),
      TX_DLYALIGN_MONSEL      => ("000"),
      TX_DLYALIGN_OVRDSETTING => ("10000000"),

      -------------------------TX Gearbox---------------------------
      GEARBOX_ENDEC => ("000"),
      TXGEARBOX_USE => (false),

      ----------------TX Driver and OOB Signalling------------------
      TX_DRIVE_MODE          => ("DIRECT"),
      TX_IDLE_ASSERT_DELAY   => ("100"),
      TX_IDLE_DEASSERT_DELAY => ("010"),
      TXDRIVE_LOOPBACK_HIZ   => (false),
      TXDRIVE_LOOPBACK_PD    => (false),

      --------------TX Pipe Control for PCI Express/SATA------------
      COM_BURST_VAL => ("1111"),

      ------------------TX Attributes for PCI Express---------------
      TX_DEEMPH_0      => ("11010"),
      TX_DEEMPH_1      => ("10000"),
      TX_MARGIN_FULL_0 => ("1001110"),
      TX_MARGIN_FULL_1 => ("1001001"),
      TX_MARGIN_FULL_2 => ("1000101"),
      TX_MARGIN_FULL_3 => ("1000010"),
      TX_MARGIN_FULL_4 => ("1000000"),
      TX_MARGIN_LOW_0  => ("1000110"),
      TX_MARGIN_LOW_1  => ("1000100"),
      TX_MARGIN_LOW_2  => ("1000010"),
      TX_MARGIN_LOW_3  => ("1000000"),
      TX_MARGIN_LOW_4  => ("1000000"),

      ----------------------------RX PLL----------------------------
      RX_OVERSAMPLE_MODE => (false),
      RXPLL_COM_CFG      => (x"21680a"),
      RXPLL_CP_CFG       => (x"0D"),
      RXPLL_DIVSEL_FB    => (2),
      RXPLL_DIVSEL_OUT   => (2),
      RXPLL_DIVSEL_REF   => (1),
      RXPLL_DIVSEL45_FB  => (5),
      RXPLL_LKDET_CFG    => ("111"),
      RX_CLK25_DIVIDER   => (5),

      -------------------------RX Interface-------------------------
      GEN_RXUSRCLK  => (true),
      RX_DATA_WIDTH => (20),
      RXRECCLK_CTRL => ("RXRECCLKPMA_DIV1"),
      RXRECCLK_DLY  => ("0000000000"),
      RXUSRCLK_DLY  => (x"0000"),

      ----------RX Driver,OOB signalling,Coupling and Eq.,CDR-------
      AC_CAP_DIS          => (true),
      CDR_PH_ADJ_TIME     => ("10100"),
      OOBDETECT_THRESHOLD => ("011"),
      PMA_CDR_SCAN        => (x"640404C"),
      PMA_RX_CFG          => (x"05ce008"),
      RCV_TERM_GND        => (false),
      RCV_TERM_VTTRX      => (true),
      RX_EN_IDLE_HOLD_CDR => (false),
      RX_EN_IDLE_RESET_FR => (true),
      RX_EN_IDLE_RESET_PH => (true),
      TX_DETECT_RX_CFG    => (x"1832"),
      TERMINATION_CTRL    => ("00000"),
      TERMINATION_OVRD    => (false),
      CM_TRIM             => ("01"),
      PMA_RXSYNC_CFG      => (x"00"),
      PMA_CFG             => (x"0040000040000000003"),
      BGTEST_CFG          => ("00"),
      BIAS_CFG            => (x"00000"),

      --------------RX Decision Feedback Equalizer(DFE)-------------
      DFE_CAL_TIME        => ("01100"),
      DFE_CFG             => ("00011011"),
      RX_EN_IDLE_HOLD_DFE => (true),
      RX_EYE_OFFSET       => (x"4C"),
      RX_EYE_SCANMODE     => ("00"),

      -------------------------PRBS Detection-----------------------
      RXPRBSERR_LOOPBACK => ('0'),

      ------------------Comma Detection and Alignment---------------
      ALIGN_COMMA_WORD     => (2),
      COMMA_10B_ENABLE     => ("0001111111"),
      COMMA_DOUBLE         => (false),
      DEC_MCOMMA_DETECT    => (false),
      DEC_PCOMMA_DETECT    => (false),
      DEC_VALID_COMMA_ONLY => (false),
      MCOMMA_10B_VALUE     => ("1010000011"),
      MCOMMA_DETECT        => (true),
      PCOMMA_10B_VALUE     => ("0101111100"),
      PCOMMA_DETECT        => (true),
      RX_DECODE_SEQ_MATCH  => (true),
      RX_SLIDE_AUTO_WAIT   => (5),
      RX_SLIDE_MODE        => ("OFF"),
      SHOW_REALIGN_COMMA   => (false),

      -----------------RX Loss-of-sync State Machine----------------
      RX_LOS_INVALID_INCR => (1),
      RX_LOS_THRESHOLD    => (4),
      RX_LOSS_OF_SYNC_FSM => (false),

      -------------------------RX Gearbox---------------------------
      RXGEARBOX_USE => (false),

      -------------RX Elastic Buffer and Phase alignment------------
      RX_BUFFER_USE            => (true),
      RX_EN_IDLE_RESET_BUF     => (true),
      RX_EN_MODE_RESET_BUF     => (true),
      RX_EN_RATE_RESET_BUF     => (true),
      RX_EN_REALIGN_RESET_BUF  => (false),
      RX_EN_REALIGN_RESET_BUF2 => (false),
      RX_FIFO_ADDR_MODE        => ("FULL"),
      RX_IDLE_HI_CNT           => ("1000"),
      RX_IDLE_LO_CNT           => ("0000"),
      RX_XCLK_SEL              => ("RXREC"),
      RX_DLYALIGN_CTRINC       => ("1110"),
      RX_DLYALIGN_EDGESET      => ("00010"),
      RX_DLYALIGN_LPFINC       => ("1110"),
      RX_DLYALIGN_MONSEL       => ("000"),
      RX_DLYALIGN_OVRDSETTING  => ("10000000"),

      ------------------------Clock Correction----------------------
      CLK_COR_ADJ_LEN          => (2),
      CLK_COR_DET_LEN          => (2),
      CLK_COR_INSERT_IDLE_FLAG => (false),
      CLK_COR_KEEP_IDLE        => (false),
      CLK_COR_MAX_LAT          => (18),
      CLK_COR_MIN_LAT          => (14),
      CLK_COR_PRECEDENCE       => (true),
      CLK_COR_REPEAT_WAIT      => (0),
      CLK_COR_SEQ_1_1          => ("0110111100"),
      CLK_COR_SEQ_1_2          => ("0001010000"),
      CLK_COR_SEQ_1_3          => ("0100000000"),
      CLK_COR_SEQ_1_4          => ("0100000000"),
      CLK_COR_SEQ_1_ENABLE     => ("1111"),
      CLK_COR_SEQ_2_1          => ("0110111100"),
      CLK_COR_SEQ_2_2          => ("0010110101"),
      CLK_COR_SEQ_2_3          => ("0100000000"),
      CLK_COR_SEQ_2_4          => ("0100000000"),
      CLK_COR_SEQ_2_ENABLE     => ("1111"),
      CLK_COR_SEQ_2_USE        => (false),
      CLK_CORRECT_USE          => (true),

      ------------------------Channel Bonding----------------------
      CHAN_BOND_1_MAX_SKEW   => (1),
      CHAN_BOND_2_MAX_SKEW   => (1),
      CHAN_BOND_KEEP_ALIGN   => (false),
      CHAN_BOND_SEQ_1_1      => ("0000000000"),
      CHAN_BOND_SEQ_1_2      => ("0000000000"),
      CHAN_BOND_SEQ_1_3      => ("0000000000"),
      CHAN_BOND_SEQ_1_4      => ("0000000000"),
      CHAN_BOND_SEQ_1_ENABLE => ("1111"),
      CHAN_BOND_SEQ_2_1      => ("0000000000"),
      CHAN_BOND_SEQ_2_2      => ("0000000000"),
      CHAN_BOND_SEQ_2_3      => ("0000000000"),
      CHAN_BOND_SEQ_2_4      => ("0000000000"),
      CHAN_BOND_SEQ_2_CFG    => ("00000"),
      CHAN_BOND_SEQ_2_ENABLE => ("1111"),
      CHAN_BOND_SEQ_2_USE    => (false),
      CHAN_BOND_SEQ_LEN      => (1),
      PCI_EXPRESS_MODE       => (false),

      -------------RX Attributes for PCI Express/SATA/SAS----------
      SAS_MAX_COMSAS     => (52),
      SAS_MIN_COMSAS     => (40),
      SATA_BURST_VAL     => ("100"),
      SATA_IDLE_VAL      => ("100"),
      SATA_MAX_BURST     => (9),
      SATA_MAX_INIT      => (27),
      SATA_MAX_WAKE      => (9),
      SATA_MIN_BURST     => (5),
      SATA_MIN_INIT      => (15),
      SATA_MIN_WAKE      => (5),
      TRANS_TIME_FROM_P2 => (x"03c"),
      TRANS_TIME_NON_P2  => (x"19"),
      TRANS_TIME_RATE    => (x"ff"),
      TRANS_TIME_TO_P2   => (x"064")


      )
    port map
    (
      ------------------------ Loopback and Powerdown Ports ----------------------
      LOOPBACK                 => LOOPBACK_IN,
      RXPOWERDOWN              => RXPOWERDOWN_IN,
      TXPOWERDOWN              => "00",
      -------------- Receive Ports - 64b66b and 64b67b Gearbox Ports -------------
      RXDATAVALID              => open,
      RXGEARBOXSLIP            => tied_to_ground_i,
      RXHEADER                 => open,
      RXHEADERVALID            => open,
      RXSTARTOFSEQ             => open,
      ----------------------- Receive Ports - 8b10b Decoder ----------------------
      RXCHARISCOMMA            => open,
      RXCHARISK(3 downto 2)    => rxcharisk_float_i,
      RXCHARISK(1 downto 0)    => RXCHARISK_OUT,
      RXDEC8B10BUSE            => tied_to_vcc_i,
      RXDISPERR(3 downto 2)    => rxdisperr_float_i,
      RXDISPERR(1 downto 0)    => RXDISPERR_OUT,
      RXNOTINTABLE(3 downto 2) => rxnotintable_float_i,
      RXNOTINTABLE(1 downto 0) => RXNOTINTABLE_OUT,
      RXRUNDISP(3 downto 2)    => rxrundisp_float_i,
      RXRUNDISP(1 downto 0)    => RXRUNDISP_OUT,
      USRCODEERR               => tied_to_ground_i,
      ------------------- Receive Ports - Channel Bonding Ports ------------------
      RXCHANBONDSEQ            => open,
      RXCHBONDI                => tied_to_ground_vec_i(3 downto 0),
      RXCHBONDLEVEL            => tied_to_ground_vec_i(2 downto 0),
      RXCHBONDMASTER           => tied_to_ground_i,
      RXCHBONDO                => open,
      RXCHBONDSLAVE            => tied_to_ground_i,
      RXENCHANSYNC             => tied_to_ground_i,
      ------------------- Receive Ports - Clock Correction Ports -----------------
      RXCLKCORCNT              => RXCLKCORCNT_OUT,
      --------------- Receive Ports - Comma Detection and Alignment --------------
      RXBYTEISALIGNED          => open,
      RXBYTEREALIGN            => RXBYTEREALIGN_OUT,
      RXCOMMADET               => open,
      RXCOMMADETUSE            => tied_to_vcc_i,
      RXENMCOMMAALIGN          => tied_to_vcc_i,
      RXENPCOMMAALIGN          => tied_to_vcc_i,
      RXSLIDE                  => tied_to_ground_i,
      ----------------------- Receive Ports - PRBS Detection ---------------------
      PRBSCNTRESET             => PRBSCNTRESET_IN,
      RXENPRBSTST              => ENRXPRBSTST_IN(2 downto 0),
      RXPRBSERR                => open,
      ------------------- Receive Ports - RX Data Path interface -----------------
      RXDATA                   => rxdata_i,
      RXRECCLK                 => open,
      RXRECCLKPCS              => open,
      RXRESET                  => RXRESET_IN,
      RXUSRCLK                 => tied_to_ground_i,
      RXUSRCLK2                => RXUSRCLK2_IN,
      ------------ Receive Ports - RX Decision Feedback Equalizer(DFE) -----------
      DFECLKDLYADJ             => tied_to_ground_vec_i(5 downto 0),
      DFECLKDLYADJMON          => open,
      DFEDLYOVRD               => tied_to_vcc_i,
      DFEEYEDACMON             => open,
      DFESENSCAL               => open,
      DFETAP1                  => tied_to_ground_vec_i(4 downto 0),
      DFETAP1MONITOR           => open,
      DFETAP2                  => tied_to_ground_vec_i(4 downto 0),
      DFETAP2MONITOR           => open,
      DFETAP3                  => tied_to_ground_vec_i(3 downto 0),
      DFETAP3MONITOR           => open,
      DFETAP4                  => tied_to_ground_vec_i(3 downto 0),
      DFETAP4MONITOR           => open,
      DFETAPOVRD               => tied_to_vcc_i,
      ------- Receive Ports - RX Driver,OOB signalling,Coupling and Eq.,CDR ------
      GATERXELECIDLE           => tied_to_vcc_i,
      IGNORESIGDET             => tied_to_vcc_i,
      RXCDRRESET               => tied_to_ground_i,
      RXELECIDLE               => RXELECIDLE_OUT,
      RXEQMIX                  => "0000000111",
      RXN                      => RXN_IN,
      RXP                      => RXP_IN,
      -------- Receive Ports - RX Elastic Buffer and Phase Alignment Ports -------
      RXBUFRESET               => tied_to_ground_i,
      RXBUFSTATUS              => open,
      RXCHANISALIGNED          => open,
      RXCHANREALIGN            => open,
      RXDLYALIGNDISABLE        => tied_to_ground_i,
      RXDLYALIGNMONENB         => tied_to_ground_i,
      RXDLYALIGNMONITOR        => open,
      RXDLYALIGNOVERRIDE       => tied_to_vcc_i,
      RXDLYALIGNRESET          => tied_to_ground_i,
      RXDLYALIGNSWPPRECURB     => tied_to_vcc_i,
      RXDLYALIGNUPDSW          => tied_to_ground_i,
      RXENPMAPHASEALIGN        => tied_to_ground_i,
      RXPMASETPHASE            => tied_to_ground_i,
      RXSTATUS                 => open,
      --------------- Receive Ports - RX Loss-of-sync State Machine --------------
      RXLOSSOFSYNC             => open,
      ---------------------- Receive Ports - RX Oversampling ---------------------
      RXENSAMPLEALIGN          => tied_to_ground_i,
      RXOVERSAMPLEERR          => open,
      ------------------------ Receive Ports - RX PLL Ports ----------------------
      GREFCLKRX                => tied_to_ground_i,
      GTXRXRESET               => GTXRXRESET_IN,
      MGTREFCLKRX              => MGTREFCLKRX_IN,
      NORTHREFCLKRX            => tied_to_ground_vec_i(1 downto 0),
      PERFCLKRX                => tied_to_ground_i,
      PLLRXRESET               => PLLRXRESET_IN,
      RXPLLLKDET               => RXPLLLKDET_OUT,
      RXPLLLKDETEN             => tied_to_vcc_i,
      RXPLLPOWERDOWN           => tied_to_ground_i,
      RXPLLREFSELDY            => tied_to_ground_vec_i(2 downto 0),
      RXRATE                   => tied_to_ground_vec_i(1 downto 0),
      RXRATEDONE               => open,
      RXRESETDONE              => RXRESETDONE_OUT,
      SOUTHREFCLKRX            => tied_to_ground_vec_i(1 downto 0),
      -------------- Receive Ports - RX Pipe Control for PCI Express -------------
      PHYSTATUS                => open,
      RXVALID                  => rxvalid_out,
      ----------------- Receive Ports - RX Polarity Control Ports ----------------
      RXPOLARITY               => tied_to_ground_i,
      --------------------- Receive Ports - RX Ports for SATA --------------------
      COMINITDET               => open,
      COMSASDET                => open,
      COMWAKEDET               => open,
      ------------- Shared Ports - Dynamic Reconfiguration Port (DRP) ------------
      DADDR                    => x"82",
      DCLK                     => DCLK_IN,
      DEN                      => DEN_IN,
      DI                       => tied_to_ground_vec_i(15 downto 0),
      DRPDO                    => DRPDO_OUT,
      DWE                      => tied_to_ground_i,
      -------------- Transmit Ports - 64b66b and 64b67b Gearbox Ports ------------
      TXGEARBOXREADY           => open,
      TXHEADER                 => tied_to_ground_vec_i(2 downto 0),
      TXSEQUENCE               => tied_to_ground_vec_i(6 downto 0),
      TXSTARTSEQ               => tied_to_ground_i,
      ---------------- Transmit Ports - 8b10b Encoder Control Ports --------------
      TXBYPASS8B10B            => tied_to_ground_vec_i(3 downto 0),
      TXCHARDISPMODE           => tied_to_ground_vec_i(3 downto 0),
      TXCHARDISPVAL            => tied_to_ground_vec_i(3 downto 0),
      TXCHARISK(3 downto 2)    => tied_to_ground_vec_i(1 downto 0),
      TXCHARISK(1 downto 0)    => TXCHARISK_IN,
      TXENC8B10BUSE            => tied_to_vcc_i,
      TXKERR                   => open,
      TXRUNDISP                => open,
      ------------------------- Transmit Ports - GTX Ports -----------------------
      GTXTEST                  => GTXTEST_IN,
      MGTREFCLKFAB             => open,
      TSTCLK0                  => tied_to_ground_i,
      TSTCLK1                  => tied_to_ground_i,
      TSTIN                    => "11111111111111111111",
      TSTOUT                   => open,
      ------------------ Transmit Ports - TX Data Path interface -----------------
      TXDATA                   => txdata_i,
      TXOUTCLK                 => TXOUTCLK_OUT,
      TXOUTCLKPCS              => open,
      TXRESET                  => TXRESET_IN,
      TXUSRCLK                 => tied_to_ground_i,
      TXUSRCLK2                => TXUSRCLK2_IN,
      ---------------- Transmit Ports - TX Driver and OOB signaling --------------
      TXBUFDIFFCTRL            => "100",
      TXDIFFCTRL               => TXDIFFCTRL_IN,
      TXINHIBIT                => tied_to_ground_i,
      TXN                      => TXN_OUT,
      TXP                      => TXP_OUT,
      TXPOSTEMPHASIS           => "00000",
      --------------- Transmit Ports - TX Driver and OOB signalling --------------
      TXPREEMPHASIS            => TXPREEMPHASIS_IN,
      ----------- Transmit Ports - TX Elastic Buffer and Phase Alignment ---------
      TXBUFSTATUS              => open,
      -------- Transmit Ports - TX Elastic Buffer and Phase Alignment Ports ------
      TXDLYALIGNDISABLE        => tied_to_vcc_i,
      TXDLYALIGNMONENB         => tied_to_ground_i,
      TXDLYALIGNMONITOR        => open,
      TXDLYALIGNOVERRIDE       => tied_to_ground_i,
      TXDLYALIGNRESET          => tied_to_ground_i,
      TXDLYALIGNUPDSW          => tied_to_vcc_i,
      TXENPMAPHASEALIGN        => tied_to_ground_i,
      TXPMASETPHASE            => tied_to_ground_i,
      ----------------------- Transmit Ports - TX PLL Ports ----------------------
      GREFCLKTX                => tied_to_ground_i,
      GTXTXRESET               => GTXTXRESET_IN,
      MGTREFCLKTX              => MGTREFCLKTX_IN,
      NORTHREFCLKTX            => tied_to_ground_vec_i(1 downto 0),
      PERFCLKTX                => tied_to_ground_i,
      PLLTXRESET               => PLLTXRESET_IN,
      SOUTHREFCLKTX            => tied_to_ground_vec_i(1 downto 0),
      TXPLLLKDET               => TXPLLLKDET_OUT,
      TXPLLLKDETEN             => tied_to_vcc_i,
      TXPLLPOWERDOWN           => tied_to_ground_i,
      TXPLLREFSELDY            => tied_to_ground_vec_i(2 downto 0),
      TXRATE                   => tied_to_ground_vec_i(1 downto 0),
      TXRATEDONE               => open,
      TXRESETDONE              => TXRESETDONE_OUT,
      --------------------- Transmit Ports - TX PRBS Generator -------------------
      TXENPRBSTST              => ENTXPRBSTST_IN(2 downto 0),
      TXPRBSFORCEERR           => tied_to_ground_i,
      -------------------- Transmit Ports - TX Polarity Control ------------------
      TXPOLARITY               => tied_to_ground_i,
      ----------------- Transmit Ports - TX Ports for PCI Express ----------------
      TXDEEMPH                 => tied_to_ground_i,
      TXDETECTRX               => tied_to_ground_i,
      TXELECIDLE               => tied_to_ground_i,
      TXMARGIN                 => tied_to_ground_vec_i(2 downto 0),
      TXPDOWNASYNCH            => tied_to_ground_i,
      TXSWING                  => tied_to_ground_i,
      --------------------- Transmit Ports - TX Ports for SATA -------------------
      COMFINISH                => open,
      TXCOMINIT                => tied_to_ground_i,
      TXCOMSAS                 => tied_to_ground_i,
      TXCOMWAKE                => tied_to_ground_i
      );
end RTL;



