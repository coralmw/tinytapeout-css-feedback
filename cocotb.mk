# cocotb defines
SIM ?= icarus
TOPLEVEL_LANG ?= verilog
VERILOG_SOURCES += src/user_module_339800239192932947.v
TOPLEVEL = mkAdder
MODULE = hardware.simulation.sim
SIM_BUILD = build

-include $(shell cocotb-config --makefiles)/Makefile.sim
