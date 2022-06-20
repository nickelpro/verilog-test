`ifndef PARTIALPRODUCT_SV
`define PARTIALPRODUCT_SV


module PartialProduct #(
    Width = 8
) (
    input [Width - 1 : 0] a,
    input [Width - 1 : 0] b,
    output [Width - 1 : 0][Width - 1 : 0] pp
);

  for (genvar i = 0; i < Width; i++) begin
    for (genvar j = 0; j < Width; j++) begin
      assign pp[i][j] = a[i] & b[j];
    end
  end

endmodule

`endif  // PARTIALPRODUCT_SV
