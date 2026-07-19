# ==========================================
# 1. CLOCK DEFINITION & TIMING CONSTRAINTS
# ==========================================
# Creates a 10ns (100MHz) primary clock constraint on the incoming board clock pin
create_clock -period 10.000 -name sys_clk [get_ports clk]

# Account for clock jitter and distribution characteristics
set_input_jitter sys_clk 0.100

# ==========================================
# 2. INPUT / OUTPUT DELAY CONSTRAINTS
# ==========================================
# Constrain peripheral IO assuming a standard 60/40 budget rule of the clock period
set_input_delay -clock sys_clk -max 3.000 [get_ports {reset_n data_in[*]}]
set_input_delay -clock sys_clk -min 0.500 [get_ports {reset_n data_in[*]}]

set_output_delay -clock sys_clk -max 3.000 [get_ports {data_out[*] error_flag}]
set_output_delay -clock sys_clk -min 0.500 [get_ports {data_out[*] error_flag}]

# ==========================================
# 3. PHYSICAL PIN ALLOCATION MAPPING (TEMPLATE)
# ==========================================
# NOTE: Replace the pin locations (e.g., E19, AV12) with your specific board's schematics
set_property PACKAGE_PIN E19 [get_ports clk]
set_property IOSTANDARD LVCMOS18 [get_ports clk]

set_property PACKAGE_PIN AV12 [get_ports reset_n]
set_property IOSTANDARD LVCMOS18 [get_ports reset_n]
