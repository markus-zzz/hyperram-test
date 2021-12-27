/*
 * Copyright (C) 2019-2021 Markus Lavin (https://www.zzzconsulting.se/)
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

/* verilator lint_off WIDTH */
/* verilator lint_off PINMISSING */

`default_nettype none

module top(
  input i_rst,
  input i_clk,
  output reg [31:0] o_port_0,
  output reg [31:0] o_port_1,
  output reg [31:0] o_port_2
);

  wire cpu_mem_valid;
  wire cpu_mem_instr;
  reg  cpu_mem_ready;
  wire [31:0] cpu_mem_addr;
  wire [31:0] cpu_mem_wdata;
  wire [ 3:0] cpu_mem_wstrb;
  reg [31:0] cpu_mem_rdata;
  wire [31:0] ram_rdata, rom_rdata;

  wire [9:0] ram_addr;
  wire [31:0] ram_wdata;
  wire [3:0] ram_wstrb;

  assign ram_addr  = cpu_mem_addr[9:0];
  assign ram_wdata = cpu_mem_wdata;
  assign ram_wstrb = cpu_mem_wstrb;

  always @* begin
    case (cpu_mem_addr[31:28])
      4'h0: cpu_mem_rdata = rom_rdata;
      4'h1: cpu_mem_rdata = ram_rdata;
      default: cpu_mem_rdata = 0;
    endcase
  end

  wire clk, rst;
  assign clk = i_clk;
  assign rst = i_rst;

  always @(posedge clk) begin
    if (rst) cpu_mem_ready <= 0;
    else begin
      case (cpu_mem_addr[31:28])
        4'h0: cpu_mem_ready <= ~cpu_mem_ready & cpu_mem_valid;
        4'h1: cpu_mem_ready <= ~cpu_mem_ready & cpu_mem_valid;
        4'h2: cpu_mem_ready <= ~cpu_mem_ready & cpu_mem_valid;
        4'h3: cpu_mem_ready <= ~cpu_mem_ready & cpu_mem_valid;
        default: cpu_mem_ready <= 0;
      endcase
    end
  end

  // ROM - CPU code.
  sprom #(
    .aw(10),
    .dw(32),
    .MEM_INIT_FILE("rom.vh")
  ) u_rom(
    .clk(clk),
    .rst(rst),
    .ce(cpu_mem_valid && cpu_mem_addr[31:28] == 4'h0),
    .oe(1'b1),
    .addr(cpu_mem_addr[11:2]),
    .do(rom_rdata)
  );

  // RAM - shared between CPU and USB. USB has priority.
  genvar gi;
  generate
    for (gi=0; gi<4; gi=gi+1) begin
      spram #(
        .aw(10),
        .dw(8)
      ) u_ram(
        .clk(clk),
        .rst(rst),
        .ce(cpu_mem_valid && cpu_mem_addr[31:28] == 4'h1),
        .oe(1'b1),
        .addr(ram_addr[9:2]),
        .do(ram_rdata[(gi+1)*8-1:gi*8]),
        .di(ram_wdata[(gi+1)*8-1:gi*8]),
        .we(ram_wstrb[gi])
      );
    end
  endgenerate

  picorv32 #(
    .COMPRESSED_ISA(1)
  ) u_cpu(
    .clk(clk),
    .resetn(~rst),
    .mem_valid(cpu_mem_valid),
    .mem_instr(cpu_mem_instr),
    .mem_ready(cpu_mem_ready),
    .mem_addr(cpu_mem_addr),
    .mem_wdata(cpu_mem_wdata),
    .mem_wstrb(cpu_mem_wstrb),
    .mem_rdata(cpu_mem_rdata)
  );

  always @(posedge clk) begin
    if (rst) begin
      o_port_0 <= 0;
      o_port_1 <= 0;
      o_port_2 <= 0;
    end
    else if (cpu_mem_wstrb == 4'hf && cpu_mem_addr[31:28] == 4'h3) begin
      case (cpu_mem_addr[3:0])
        4'h0: o_port_0 <= cpu_mem_wdata;
        4'h4: o_port_1 <= cpu_mem_wdata;
        4'h8: o_port_2 <= cpu_mem_wdata;
        default: /* do nothing */;
      endcase
    end
  end

/*
  hyper_xface u_hyperctrl(
  input  wire         reset,
  input  wire         clk,
  input  wire         rd_req,
  input  wire         wr_req,
  input  wire         mem_or_reg,
  input  wire [3:0]   wr_byte_en,
  input  wire [5:0]   rd_num_dwords,
  input  wire [31:0]  addr,
  input  wire [31:0]  wr_d,
  output reg  [31:0]  rd_d,
  output reg          rd_rdy,
  output reg          busy,
  output reg          burst_wr_rdy,
  input  wire [7:0]   latency_1x,
  input  wire [7:0]   latency_2x,

  input  wire [7:0]   dram_dq_in,
  output reg  [7:0]   dram_dq_out,
  output reg          dram_dq_oe_l,

  input  wire         dram_rwds_in,
  output reg          dram_rwds_out,
  output reg          dram_rwds_oe_l,

  output reg          dram_ck,
  output wire         dram_rst_l,
  output wire         dram_cs_l,
  output wire [7:0]   sump_dbg);
*/

endmodule
