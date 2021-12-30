# A simple test-bench for my ULX3S HyperRAM expansion board (not a PMOD)

Using the portable Verilog HyperRAM controller from
https://github.com/blackmesalabs/hyperram and the PicoRV32 RISC-V core from
https://github.com/YosysHQ/picorv32 a simple system is built to test the
HyperRAM boards I assembled some time ago.

The test consists of writing (as dwords) the Fibonacci sequence to all 2M dword
locations of the memory and then reading back again comparing to the computed
sequence.

The purpose of this basic test is simply to verify that the electrical
connections are reasonably sound and that the part survived the assembly
process.
