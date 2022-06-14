`ifndef DUALPORTMEM_SV
`define DUALPORTMEM_SV

/**
  @brief Interface for Dual Port Memory

  @modport ctrl  Controller port
  @modport prph  Peripheral port
*/
interface DualPortMem_If #(
    DataWidth = 32,
    AddrWidth = 10
);
  wire clk;
  wire w_enable;
  wire [AddrWidth - 1 : 0] w_addr;
  wire [DataWidth - 1 : 0] w_data;
  wire [AddrWidth - 1 : 0] r_addr;
  wire [DataWidth - 1 : 0] r_data;

  //  verilog_format: off
  modport ctrl(
    output clk, w_enable, w_addr, w_data, r_addr,
    input r_data
  );

  modport prph(
    input clk, w_enable, w_addr, w_data, r_addr,
    output r_data
  );
  //  verilog_format: on
endinterface

/**
  @brief Dual port memory peripheral module
*/
module DualPortMemPrph #(
    Depth = 1024,
    BottomAddr = 0
) (
    DualPortMem_If.prph dpm_if
);

  reg [dpm_if.DataWidth - 1 : 0] buffer;
  reg [dpm_if.DataWidth - 1 : 0] mem[BottomAddr + Depth - 1 : BottomAddr];

  // verilog_format: off
  always_ff @(posedge dpm_if.clk) begin
    buffer <= mem[dpm_if.r_addr];
    if(dpm_if.w_enable)
      mem[dpm_if.w_addr] <= dpm_if.w_data;
  end
  // verilog_format: on

  assign dpm_if.r_data = buffer;

endmodule

/**
  @brief Dual port memory module

  @param DataWidth  bit-width of a word
  @param AddrWidth  bit-width of an address
  @param Depth      number of memory cells
  @param BottomAddr index of lowest memory cell

  @input  clk      clock
  @input  w_enable write enable
  @input  w_addr   write address bus
  @input  w_data   write data bus
  @input  r_addr   read address bys
  @output r_data   read data bus

*/
module DualPortMem #(
    DataWidth = 32,
    AddrWidth = 10,
    Depth = 1024,
    BottomAddr = 0
) (
    input clk,
    input w_enable,
    input [AddrWidth - 1 : 0] w_addr,
    input [DataWidth - 1 : 0] w_data,
    input [AddrWidth - 1 : 0] r_addr,
    output [DataWidth - 1 : 0] r_data
);

  DualPortMem_If #(DataWidth, AddrWidth) dpm_if ();
  assign dpm_if.clk = clk;
  assign dpm_if.w_enable = w_enable;
  assign dpm_if.w_addr = w_addr;
  assign dpm_if.w_data = w_data;
  assign dpm_if.r_addr = r_addr;
  assign r_data = dpm_if.r_data;
  DualPortMemPrph #(Depth, BottomAddr) prph (.*);

endmodule


`endif  // DUALPORTMEM_SV
