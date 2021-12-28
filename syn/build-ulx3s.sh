#!/bin/bash

set -e -x
yosys ulx3s-top.ys
nextpnr-ecp5 \
	--json hyperram-test.json \
	--textcfg hyperram-test.config \
	--lpf ulx3s.lpf \
	--25k

ecppack --idcode 0x21111043 hyperram-test.config hyperram-test.bit
