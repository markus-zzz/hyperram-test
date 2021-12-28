/*
 * Copyright (C) 2019-2020 Markus Lavin (https://www.zzzconsulting.se/)
 *
 * All rights reserved.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 *
 */


/*
    -    +
27 DQ5  DQ4
26 DQ3  DQ2
25 DQ0  RST
24 RWDS CS
23
22 CLK DQ1
21 DQ7 DQ6
*/

module ulx3s_top(
  input clk_25mhz,
  input [6:0] btn,
  output [7:0] led,
  inout [27:0] gp,
  inout [27:0] gn,
  inout usb_fpga_bd_dp,
  inout usb_fpga_bd_dn,
  output usb_fpga_pu_dp,
  output usb_fpga_pu_dn
);


  wire [7:0] dram_dq_in;
  wire [7:0] dram_dq_out;
  wire       dram_dq_oe_l;

  wire dram_rwds_in;
  wire dram_rwds_out;
  wire dram_rwds_oe_l;

  wire dram_ck;
  wire dram_rst_l;
  wire dram_cs_l;

  wire [31:0] port_0;

  assign led = port_0[7:0];

  assign gn[22] = dram_ck;
  assign gp[25] = dram_rst_l;
  assign gp[24] = dram_cs_l;

  assign gn[21] = dram_dq_oe_l ? 1'bz : dram_dq_out[7]; // DQ7
  assign gp[21] = dram_dq_oe_l ? 1'bz : dram_dq_out[6]; // DQ6
  assign gn[27] = dram_dq_oe_l ? 1'bz : dram_dq_out[5]; // DQ5
  assign gp[27] = dram_dq_oe_l ? 1'bz : dram_dq_out[4]; // DQ4
  assign gn[26] = dram_dq_oe_l ? 1'bz : dram_dq_out[3]; // DQ3
  assign gp[26] = dram_dq_oe_l ? 1'bz : dram_dq_out[2]; // DQ2
  assign gp[22] = dram_dq_oe_l ? 1'bz : dram_dq_out[1]; // DQ1
  assign gn[25] = dram_dq_oe_l ? 1'bz : dram_dq_out[0]; // DQ0
  assign dram_dq_in = {gn[21], gp[21], gn[27], gp[27], gn[26], gp[26], gp[22], gn[25]};

  assign dram_rwds_out = dram_rwds_oe_l ? 1'bz : gn[24];
  assign dram_rwds_in = gn[24];

  top u_top(
    .i_rst(btn[6]),
    .i_clk(clk_25mhz),

    .o_port_0(port_0),
    .o_port_1(),
    .o_port_2(),

    .dram_dq_in(dram_dq_in),
    .dram_dq_out(dram_dq_out),
    .dram_dq_oe_l(dram_dq_oe_l),

    .dram_rwds_in(dram_rwds_in),
    .dram_rwds_out(dram_rwds_out),
    .dram_rwds_oe_l(dram_rwds_oe_l),

    .dram_ck(dram_ck),
    .dram_rst_l(dram_rst_l),
    .dram_cs_l(dram_cs_l)
  );

endmodule
