set display_name {AXI4-Stream To Normal Data Lanes Converter}

set core [ipx::current_core]

set_property DISPLAY_NAME $display_name $core
set_property DESCRIPTION $display_name $core

# Definde new AXI interface
ipx::add_bus_interface SI [ipx::current_core]
set_property abstraction_type_vlnv xilinx.com:interface:axis_rtl:1.0 [ipx::get_bus_interfaces SI -of_objects [ipx::current_core]]
set_property bus_type_vlnv xilinx.com:interface:axis:1.0 [ipx::get_bus_interfaces SI -of_objects [ipx::current_core]]
set_property display_name SI [ipx::get_bus_interfaces SI -of_objects [ipx::current_core]]
set_property description {AXI Stream Data In} [ipx::get_bus_interfaces SI -of_objects [ipx::current_core]]

# Define new port TDATA
ipx::add_port_map TDATA [ipx::get_bus_interfaces SI -of_objects [ipx::current_core]]
set_property physical_name AxiTDataxDI [ipx::get_port_maps TDATA -of_objects [ipx::get_bus_interfaces SI -of_objects [ipx::current_core]]]

# Define new port TVALID
ipx::add_port_map TVALID [ipx::get_bus_interfaces SI -of_objects [ipx::current_core]]
set_property physical_name AxiTValid [ipx::get_port_maps TVALID -of_objects [ipx::get_bus_interfaces SI -of_objects [ipx::current_core]]]

# Add new Clock Interface
ipx::add_bus_interface SI_clk [ipx::current_core]
set_property abstraction_type_vlnv xilinx.com:signal:clock_rtl:1.0 [ipx::get_bus_interfaces SI_clk -of_objects [ipx::current_core]]
set_property bus_type_vlnv xilinx.com:signal:clock:1.0 [ipx::get_bus_interfaces SI_clk -of_objects [ipx::current_core]]
set_property interface_mode slave [ipx::get_bus_interfaces SI_clk -of_objects [ipx::current_core]]
ipx::add_port_map CLK [ipx::get_bus_interfaces SI_clk -of_objects [ipx::current_core]]
set_property physical_name DataClkxCI [ipx::get_port_maps CLK -of_objects [ipx::get_bus_interfaces SI_clk -of_objects [ipx::current_core]]]

# Add new Reset Interface
ipx::add_bus_interface SI_rst [ipx::current_core]
set_property abstraction_type_vlnv xilinx.com:signal:reset_rtl:1.0 [ipx::get_bus_interfaces SI_rst -of_objects [ipx::current_core]]
set_property bus_type_vlnv xilinx.com:signal:reset:1.0 [ipx::get_bus_interfaces SI_rst -of_objects [ipx::current_core]]
set_property interface_mode slave [ipx::get_bus_interfaces SI_rst -of_objects [ipx::current_core]]
ipx::add_port_map RST [ipx::get_bus_interfaces SI_rst -of_objects [ipx::current_core]]
set_property physical_name DataRstxRBI [ipx::get_port_maps RST -of_objects [ipx::get_bus_interfaces SI_rst -of_objects [ipx::current_core]]]

set_property VENDOR {noah-huesser} $core
set_property VENDOR_DISPLAY_NAME {Noah Huesser} $core
set_property COMPANY_URL {https://github.com/Yatekii} $core
