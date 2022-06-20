`ifndef COMP32_SV
`define COMP32_SV

module Comp32 (
    input  [2:0] in,
    output [1:0] out
);
  assign out[0] = ^in;
  assign out[1] = (in[0] & in[1]) | (in[0] & in[2]) | (in[1] & in[2]);
endmodule

`endif  // COMP32_SV
