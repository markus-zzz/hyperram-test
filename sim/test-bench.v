`timescale 1 ns / 1 ps

`default_nettype none

module tb;
  reg clk;
  reg rst;

  wire [7:0] dram_dq_in;
  wire [7:0] dram_dq_out;
  wire       dram_dq_oe_l;

  wire dram_rwds_in;
  wire dram_rwds_out;
  wire dram_rwds_oe_l;

  wire dram_ck;
  wire dram_rst_l;
  wire dram_cs_l;

  wire [7:0] DQ;
  wire RWDS;
  wire CK;
  wire CS;
  wire RST;

  assign dram_dq_in = DQ;
  assign DQ = dram_dq_oe_l ? 8'hzz : dram_dq_out;
  assign dram_rwds_in = RWDS;
  assign RWDS = dram_rwds_oe_l ? 1'bz : dram_rwds_out;

  top u_top(
    .i_rst(rst),
    .i_clk(clk),

    .o_port_0(),
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

  s27kl0642 u_dram(
    .DQ7(DQ[7]),
    .DQ6(DQ[6]),
    .DQ5(DQ[5]),
    .DQ4(DQ[4]),
    .DQ3(DQ[3]),
    .DQ2(DQ[2]),
    .DQ1(DQ[1]),
    .DQ0(DQ[0]),
    .RWDS(RWDS),

    .CSNeg(dram_cs_l),
    .CK(dram_ck),
    .CKn(~dram_ck),
    .RESETNeg(dram_rst_l)
  );

  initial begin
    $dumpvars;
    clk = 0;
    rst = 1;
    #200 rst = 0;
    #200000 $finish;
  end

  always #40 clk <= ~clk;

endmodule
