`ifndef SINGLEPORTMEM_SV
`define SINGLEPORTMEM_SV

/**
  @brief Single port memory module

  @param DataWidth  bit-width of a word
  @param AddrWidth  bit-width of an address
  @param Depth      number of memory cells
  @param BottomAddr index of lowest memory cell

  @input clk      clock
  @input select   chip select
  @input o_enable output enable
  @input w_enable write enable
  @input addr     address bus
  @inout data     data bus
*/
module SinglePortMem #(
    DataWidth = 32,
    AddrWidth = 10,
    Depth = 1024,
    BottomAddr = 0
) (
    input clk,
    input select,
    input o_enable,
    input w_enable,
    input [AddrWidth - 1 : 0] addr,
    inout [DataWidth - 1 : 0] data
);

  reg [DataWidth - 1 : 0] r_data;
  reg [DataWidth - 1 : 0] mem[BottomAddr + Depth - 1 : BottomAddr];

  // verilog_format: off
  always_ff @(posedge clk) begin
    if(select) begin
      if(w_enable)
        mem[addr] <= data;
      else
        r_data <= mem[addr];
    end
  end  // verilog_format: on

  assign data = select & o_enable & !w_enable ? r_data : 'bz;

endmodule

/**
  @brief Interface for Single Port Memory

  @modport ctrl  Controller port
  @modport prph  Peripheral port
*/
interface SinglePortMem_If #(
    DataWidth = 32,
    AddrWidth = 10
);
  wire clk;
  wire select;
  wire o_enable;
  wire w_enable;
  wire [AddrWidth - 1 : 0] addr;
  wire [DataWidth - 1 : 0] data;

  //  verilog_format: off
  modport ctrl(
    output clk, select, o_enable, w_enable, addr,
    inout data
  );

  modport prph(
    input clk, select, o_enable, w_enable, addr,
    inout data
  );
  //  verilog_format: on
endinterface

/**
  @brief Single port memory peripheral module
*/
module SinglePortMemPrph #(
    Depth = 1024,
    BottomAddr = 0
) (
    SinglePortMem_If.prph port
);

  SinglePortMem #(
      .DataWidth(spm_if.DataWidth),
      .AddrWidth(spm_if.AddrWidth),
      .Depth(Depth),
      .BottomAddr(BottomAddr)
  ) mem (
      .clk(spm_if.clk),
      .select(spm_if.select),
      .o_enable(spm_if.o_enable),
      .w_enable(spm_if.w_enable),
      .addr(spm_if.addr),
      .data(spm_if.data)
  );

endmodule

`endif  // SINGLEPORTMEM_SV
