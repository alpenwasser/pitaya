set display_name {Generic Multiplexer}

set core [ipx::current_core]

set_property DISPLAY_NAME $display_name $core
set_property DESCRIPTION $display_name $core

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
