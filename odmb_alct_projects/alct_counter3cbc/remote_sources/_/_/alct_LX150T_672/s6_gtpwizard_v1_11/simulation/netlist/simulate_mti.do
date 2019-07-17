   
################################################################################
##   ____  ____ 
##  /   /\/   / 
## /___/  \  /    Vendor: Xilinx 
## \   \   \/     Version : 1.11
##  \   \         Application : Spartan-6 GTP Wizard 
##  /   /         Filename : simulate_mti.do
## /___/   /\     
## \   \  /  \ 
##  \___\/\___\ 
##
##
## Script SIMULATE_MTI.DO
## Generated by Xilinx Spartan-6 GTP Wizard


##***************************** Beginning of Script ***************************

        
## If MTI_LIBS is defined, map unisim and simprim directories using MTI_LIBS
## This mode of mapping the unisims libraries is provided for backward 
## compatibility with previous wizard releases. If you don't set MTI_LIBS
## the unisim libraries will be loaded from the paths set up by compxlib in
## your modelsim.ini file

set XILINX   $env(XILINX)
if [info exists env(MTI_LIBS)] {    
    set MTI_LIBS $env(MTI_LIBS)
    vlib SIMPRIMS_VER
    vlib SECUREIP
    vmap SIMPRIMS_VER $MTI_LIBS/simprims_ver
    vmap SECUREIP $MTI_LIBS/secureip
   
}

## Create and map work directory
vlib work
vmap work work


##Other modules
vlog -work work $XILINX/verilog/src/glbl.v;
vlog -work work  ../../implement/results/routed.v;
vlog -work work  ../demo_tb_imp.v;

##Load Design
vsim -t 1ps -L SECUREIP -L SIMPRIMS_VER -sdftyp /DEMO_TB_IMP/s6_gtpwizard_v1_11_top_i=../../implement/results/routed.sdf +no_notifier +notimingchecks work.DEMO_TB_IMP work.glbl -voptargs="+acc"


##Run simulation
run 200 us

