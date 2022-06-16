`ifndef CARRYSAVEADDER_SV
`define CARRYSAVEADDER_SV

`include "Compressors/Comp32.sv"

module CarrySaveAdder #(
    Width = 8
) (
    input  [Width - 1:0] a,
    input  [Width - 1:0] b,
    input  [Width - 1:0] c,
    output [Width - 1:0] sum,
    output [Width - 1:0] carry
);
  for (genvar i = 0; i < Width; i++) begin
    Comp32 fa (
        .in ({a[i], b[i], c[i]}),
        .out({carry[i], sum[i]})
    );
  end
endmodule

`endif  // CARRYSAVEADDER_SV
