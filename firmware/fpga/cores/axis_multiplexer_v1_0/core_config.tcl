set display_name {Generic AXI Stream Multiplexer}

set core [ipx::current_core]

set_property DISPLAY_NAME $display_name $core
set_property DESCRIPTION $display_name $core

# Define 4 new AXI slave interface
ipx::add_bus_interface SI0 [ipx::current_core]
set_property abstraction_type_vlnv xilinx.com:interface:axis_rtl:1.0 [ipx::get_bus_interfaces SI0 -of_objects [ipx::current_core]]
set_property bus_type_vlnv xilinx.com:interface:axis:1.0 [ipx::get_bus_interfaces SI0 -of_objects [ipx::current_core]]
set_property display_name SI0 [ipx::get_bus_interfaces SI0 -of_objects [ipx::current_core]]
set_property description {AXI Stream Data In 0} [ipx::get_bus_interfaces SI0 -of_objects [ipx::current_core]]

ipx::add_bus_interface SI1 [ipx::current_core]
set_property abstraction_type_vlnv xilinx.com:interface:axis_rtl:1.0 [ipx::get_bus_interfaces SI1 -of_objects [ipx::current_core]]
set_property bus_type_vlnv xilinx.com:interface:axis:1.0 [ipx::get_bus_interfaces SI1 -of_objects [ipx::current_core]]
set_property display_name SI1 [ipx::get_bus_interfaces SI1 -of_objects [ipx::current_core]]
set_property description {AXI Stream Data In 1} [ipx::get_bus_interfaces SI1 -of_objects [ipx::current_core]]

ipx::add_bus_interface SI2 [ipx::current_core]
set_property abstraction_type_vlnv xilinx.com:interface:axis_rtl:1.0 [ipx::get_bus_interfaces SI2 -of_objects [ipx::current_core]]
set_property bus_type_vlnv xilinx.com:interface:axis:1.0 [ipx::get_bus_interfaces SI2 -of_objects [ipx::current_core]]
set_property display_name SI2 [ipx::get_bus_interfaces SI2 -of_objects [ipx::current_core]]
set_property description {AXI Stream Data In 2} [ipx::get_bus_interfaces SI2 -of_objects [ipx::current_core]]
set_property enablement_dependency {$C_AXIS_NUM_SI_SLOTS>=3} [ipx::get_bus_interfaces SI2 -of_objects [ipx::current_core]]

ipx::add_bus_interface SI3 [ipx::current_core]
set_property abstraction_type_vlnv xilinx.com:interface:axis_rtl:1.0 [ipx::get_bus_interfaces SI3 -of_objects [ipx::current_core]]
set_property bus_type_vlnv xilinx.com:interface:axis:1.0 [ipx::get_bus_interfaces SI3 -of_objects [ipx::current_core]]
set_property display_name SI3 [ipx::get_bus_interfaces SI3 -of_objects [ipx::current_core]]
set_property description {AXI Stream Data In 3} [ipx::get_bus_interfaces SI3 -of_objects [ipx::current_core]]
set_property enablement_dependency {$C_AXIS_NUM_SI_SLOTS>=4} [ipx::get_bus_interfaces SI3 -of_objects [ipx::current_core]]

# Define new AXI master interface
ipx::add_bus_interface MO [ipx::current_core]
set_property abstraction_type_vlnv xilinx.com:interface:axis_rtl:1.0 [ipx::get_bus_interfaces MO -of_objects [ipx::current_core]]
set_property bus_type_vlnv xilinx.com:interface:axis:1.0 [ipx::get_bus_interfaces MO -of_objects [ipx::current_core]]
set_property interface_mode master [ipx::get_bus_interfaces MO -of_objects [ipx::current_core]]
set_property display_name MO [ipx::get_bus_interfaces MO -of_objects [ipx::current_core]]
set_property description {AXI Stream Data Out} [ipx::get_bus_interfaces MO -of_objects [ipx::current_core]]

# Define 4 new ports TDATA
ipx::add_port_map TDATA [ipx::get_bus_interfaces SI0 -of_objects [ipx::current_core]]
set_property physical_name Data0xDI [ipx::get_port_maps TDATA -of_objects [ipx::get_bus_interfaces SI0 -of_objects [ipx::current_core]]]

ipx::add_port_map TDATA [ipx::get_bus_interfaces SI1 -of_objects [ipx::current_core]]
set_property physical_name Data1xDI [ipx::get_port_maps TDATA -of_objects [ipx::get_bus_interfaces SI1 -of_objects [ipx::current_core]]]

ipx::add_port_map TDATA [ipx::get_bus_interfaces SI2 -of_objects [ipx::current_core]]
set_property physical_name Data2xDI [ipx::get_port_maps TDATA -of_objects [ipx::get_bus_interfaces SI2 -of_objects [ipx::current_core]]]

ipx::add_port_map TDATA [ipx::get_bus_interfaces SI3 -of_objects [ipx::current_core]]
set_property physical_name Data3xDI [ipx::get_port_maps TDATA -of_objects [ipx::get_bus_interfaces SI3 -of_objects [ipx::current_core]]]

# Define new port TDATA
ipx::add_port_map TDATA [ipx::get_bus_interfaces MO -of_objects [ipx::current_core]]
set_property physical_name DataxDO [ipx::get_port_maps TDATA -of_objects [ipx::get_bus_interfaces MO -of_objects [ipx::current_core]]]

# Define 4 new ports TVALID
ipx::add_port_map TVALID [ipx::get_bus_interfaces SI0 -of_objects [ipx::current_core]]
set_property physical_name Valid0xSI [ipx::get_port_maps TVALID -of_objects [ipx::get_bus_interfaces SI0 -of_objects [ipx::current_core]]]

ipx::add_port_map TVALID [ipx::get_bus_interfaces SI1 -of_objects [ipx::current_core]]
set_property physical_name Valid1xSI [ipx::get_port_maps TVALID -of_objects [ipx::get_bus_interfaces SI1 -of_objects [ipx::current_core]]]

ipx::add_port_map TVALID [ipx::get_bus_interfaces SI2 -of_objects [ipx::current_core]]
set_property physical_name Valid2xSI [ipx::get_port_maps TVALID -of_objects [ipx::get_bus_interfaces SI2 -of_objects [ipx::current_core]]]

ipx::add_port_map TVALID [ipx::get_bus_interfaces SI3 -of_objects [ipx::current_core]]
set_property physical_name Valid3xSI [ipx::get_port_maps TVALID -of_objects [ipx::get_bus_interfaces SI3 -of_objects [ipx::current_core]]]

# Define new port TVALID
ipx::add_port_map TVALID [ipx::get_bus_interfaces MO -of_objects [ipx::current_core]]
set_property physical_name ValidxSO [ipx::get_port_maps TVALID -of_objects [ipx::get_bus_interfaces MO -of_objects [ipx::current_core]]]

# Define 4 new ports TREADY
ipx::add_port_map TREADY [ipx::get_bus_interfaces SI0 -of_objects [ipx::current_core]]
set_property physical_name Ready0xSO [ipx::get_port_maps TREADY -of_objects [ipx::get_bus_interfaces SI0 -of_objects [ipx::current_core]]]

ipx::add_port_map TREADY [ipx::get_bus_interfaces SI1 -of_objects [ipx::current_core]]
set_property physical_name Ready1xSO [ipx::get_port_maps TREADY -of_objects [ipx::get_bus_interfaces SI1 -of_objects [ipx::current_core]]]

ipx::add_port_map TREADY [ipx::get_bus_interfaces SI2 -of_objects [ipx::current_core]]
set_property physical_name Ready2xSO [ipx::get_port_maps TREADY -of_objects [ipx::get_bus_interfaces SI2 -of_objects [ipx::current_core]]]

ipx::add_port_map TREADY [ipx::get_bus_interfaces SI3 -of_objects [ipx::current_core]]
set_property physical_name Ready3xSO [ipx::get_port_maps TREADY -of_objects [ipx::get_bus_interfaces SI3 -of_objects [ipx::current_core]]]

# Define new port TREADY
ipx::add_port_map TREADY [ipx::get_bus_interfaces MO -of_objects [ipx::current_core]]
set_property physical_name ReadyxSI [ipx::get_port_maps TREADY -of_objects [ipx::get_bus_interfaces MO -of_objects [ipx::current_core]]]

# Add new Clock Interface
ipx::add_bus_interface SI_clk [ipx::current_core]
set_property abstraction_type_vlnv xilinx.com:signal:clock_rtl:1.0 [ipx::get_bus_interfaces SI_clk -of_objects [ipx::current_core]]
set_property bus_type_vlnv xilinx.com:signal:clock:1.0 [ipx::get_bus_interfaces SI_clk -of_objects [ipx::current_core]]
set_property interface_mode slave [ipx::get_bus_interfaces SI_clk -of_objects [ipx::current_core]]
ipx::add_port_map CLK [ipx::get_bus_interfaces SI_clk -of_objects [ipx::current_core]]
set_property physical_name ClkxCI [ipx::get_port_maps CLK -of_objects [ipx::get_bus_interfaces SI_clk -of_objects [ipx::current_core]]]

# Add new Reset Interface
ipx::add_bus_interface SI_rst [ipx::current_core]
set_property abstraction_type_vlnv xilinx.com:signal:reset_rtl:1.0 [ipx::get_bus_interfaces SI_rst -of_objects [ipx::current_core]]
set_property bus_type_vlnv xilinx.com:signal:reset:1.0 [ipx::get_bus_interfaces SI_rst -of_objects [ipx::current_core]]
set_property interface_mode slave [ipx::get_bus_interfaces SI_rst -of_objects [ipx::current_core]]
ipx::add_port_map RST [ipx::get_bus_interfaces SI_rst -of_objects [ipx::current_core]]
set_property physical_name RstxRBI [ipx::get_port_maps RST -of_objects [ipx::get_bus_interfaces SI_rst -of_objects [ipx::current_core]]]

set_property VENDOR {raphael-frey} $core
set_property VENDOR_DISPLAY_NAME {Raphael Frey} $core
set_property COMPANY_URL {https://github.com/alpenwasser} $core
