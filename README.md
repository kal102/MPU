## MPU

This is a project of HW unit dedicated for typical operations used in neural networks. It uses systolic array architecture to perform matrix multiplication in a fast and parallel way, also allows to apply basic activation functions or pooling on data.

Project has been implemented on Intel Cyclone 10 LP FPGA device, where input matrices and commands were sent from host PC via Gigabit Ethernet. After the calculations were completed, the system sent back operation results.

Project components:  
/quartus - Quartus project with Ethernet communication    
/scripts - simulation scripts  
/src - HDL models of MPU blocks and features  
/tb - SystemVerilog testbenches and classes  
/vivado - Vivado project with Microblaze

Common file types:  
*block_name*_beh.v - Behavioral model  
*block_name*_str.v - Structural model  
*block_name*_tb.sv - Testbench  
*block_name*.do - ModelSim/Questa script for simulation  
