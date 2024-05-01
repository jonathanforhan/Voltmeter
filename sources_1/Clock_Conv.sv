`timescale 1ns / 1ps  //
`default_nettype none


/// Clock conversion FREQ_IN -> FREQ_OUT
/// FREQ_OUT must be lower than FREQ_IN
module Clock_Conv #(
    parameter FREQ_IN  = 100_000_000,
    parameter FREQ_OUT = 25_175_000
) (
    input  wire  clk_in,
    output logic clk_out
);
  localparam TICKS = FREQ_IN / (FREQ_OUT * 2);

  logic [31:0] i;

  always_ff @(posedge clk_in) begin
    i++;

    if (i == TICKS) begin
      i <= 0;
      clk_out <= ~clk_out;
    end
  end
endmodule
