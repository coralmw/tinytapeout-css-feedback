# cocotb defines
SIM ?= icarus
TOPLEVEL_LANG ?= verilog
VERILOG_SOURCES += src/minimal-code-LUT.v src/coralmw_manual_verilog.v
TOPLEVEL = mkAdder
MODULE = hardware.simulation.sim
SIM_BUILD = build

-include $(shell cocotb-config --makefiles)/Makefile.sim
