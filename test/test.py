import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, Timer


async def uart_send_bit(dut, bit):
    dut.ui_in.value = bit
    await ClockCycles(dut.clk, 32*14)


async def uart_send_byte(dut, data):

    # start bit
    await uart_send_bit(dut, 0)

    # data bits LSB first
    for i in range(8):
        await uart_send_bit(dut, (data >> i) & 1)

    # stop bit
    await uart_send_bit(dut, 1)


@cocotb.test()
async def test_project(dut):

    dut._log.info("Start")

    # 50 MHz clock
    clock = Clock(dut.clk, 20, units="ns")
    cocotb.start_soon(clock.start())


    # Reset
    dut.ena.value = 1
    dut.ui_in.value = 1
    dut.uio_in.value = 0

    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)

    dut.rst_n.value = 1
    await ClockCycles(dut.clk, 100)


    dut._log.info("Sending WRITE command")


    # WRITE command
    # AA = write opcode
    # address = 5
    # data = FF

    await uart_send_byte(dut, 0xAA)
    await uart_send_byte(dut, 0x05)
    await uart_send_byte(dut, 0xFF)


    await Timer(10, units="us")


    dut._log.info("Test complete")