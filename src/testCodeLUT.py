import cocotb
from cocotb.triggers import Timer
from cocotb.triggers import FallingEdge, RisingEdge
from cocotb.clock import Clock

from collections import defaultdict

async def reset(dut):
    for i in range(10):
        await RisingEdge(dut.CLK)
        dut.RST.value = 1
    await RisingEdge(dut.CLK)
    dut.RST.value = 0
    await RisingEdge(dut.CLK)


@cocotb.test()
async def my_first_test(dut):
    """Try accessing the design."""

    cocotb.start_soon(Clock(dut.CLK, 1, units='ns').start())
    await reset(dut)

    await RisingEdge(dut.CLK)
    axis_out = []
    for i in range(7):
        axis_out.append(dut.axis.value)
        await RisingEdge(dut.CLK)
        
    assert axis_out == [0, 1, 2, 3, 1, 2, 3], f"design should output all axis corrections, got {axis_out}"
    
    expected_output_x = defaultdict(lambda: int(0)) # should have no corrections unless needed
    expected_output_x[int("0001", 2)] = int("10000", 2)
    expected_output_x[int("1000", 2)] = int("01000", 2)
    expected_output_x[int("1100", 2)] = int("00100", 2)
    expected_output_x[int("0110", 2)] = int("00010", 2)
    expected_output_x[int("0011", 2)] = int("00001", 2)   

    expected_output_y = defaultdict(lambda: int(0)) # should have no corrections unless needed
    expected_output_y[int("1011", 2)] = int("10000", 2)
    expected_output_y[int("1101", 2)] = int("01000", 2)
    expected_output_y[int("1110", 2)] = int("00100", 2)
    expected_output_y[int("1111", 2)] = int("00010", 2)
    expected_output_y[int("0111", 2)] = int("00001", 2)        
        
    expected_output_z = defaultdict(lambda: int(0)) # should have no corrections unless needed
    expected_output_z[int("1010", 2)] = int("10000", 2)
    expected_output_z[int("0101", 2)] = int("01000", 2)
    expected_output_z[int("0010", 2)] = int("00100", 2)
    expected_output_z[int("1001", 2)] = int("00010", 2)
    expected_output_z[int("0100", 2)] = int("00001", 2)
    
    axis_result_lookup = {1: expected_output_x, 2:expected_output_y, 3:expected_output_z}
    
    for ancilla_measurement in range(0, int("1111", 2)+1):
        dut.ancilla.value = ancilla_measurement
        await RisingEdge(dut.CLK)
        await RisingEdge(dut.CLK)
        await RisingEdge(dut.CLK)
        for _ in range(3):
            assert dut.correction.value == axis_result_lookup[int(dut.axis.value)][ancilla_measurement], f"for ancilla measurement {dut.ancilla.value}=?{ancilla_measurement}, dut output {dut.correction.value} for axis {int(dut.axis.value)} did not match {axis_result_lookup[int(dut.axis.value)][ancilla_measurement]}"
            await RisingEdge(dut.CLK)