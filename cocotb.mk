# cocotb defines
SIM ?= icarus
TOPLEVEL_LANG ?= verilog
VERILOG_SOURCES += src/user_module_341710255833481812.v
TOPLEVEL = mkAdder
MODULE = hardware.simulation.sim
SIM_BUILD = build

-include $(shell cocotb-config --makefiles)/Makefile.sim
