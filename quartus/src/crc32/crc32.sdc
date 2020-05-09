
set  CLK                "CLK"


# Frequency of control and status interface clock
set DEFAULT_SYSTEM_CLOCK_SPEED "125 MHz"    

#**************************************************************
# Create Clock
#**************************************************************
      
create_clock -period "$DEFAULT_SYSTEM_CLOCK_SPEED" -name CRC_CLK [ get_ports  $CLK]
