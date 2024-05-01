`timescale 1ns / 1ps  //
`default_nettype none


module Top (
    input wire clk,
    input wire [11:0] sw,
    input wire [7:0] JXADC,
    output wire Hsync,
    output wire Vsync,
    output wire [3:0] vgaRed,
    output wire [3:0] vgaBlue,
    output wire [3:0] vgaGreen,
    output wire [3:0] an
);
  assign an = 4'b1111;  // turn off 7-seg


  //--------------------------------------------------------------------------//
  // VGA timing
  //--------------------------------------------------------------------------//
  wire clk_vga;

  Clock_Conv #(
      .FREQ_IN (100_000_000),
      .FREQ_OUT(25_000_000)
  ) clock_conv (
      .clk_in (clk),
      .clk_out(clk_vga)
  );

  //--------------------------------------------------------------------------//
  // VGA sync
  //--------------------------------------------------------------------------//
  wire vidstate;
  logic [9:0] x, y;
  logic [11:0] rgb;

  VGA_Sync vga_sync (
      .clk(clk_vga),
      .rgb_in(rgb),
      .vidstate(vidstate),
      .hsync(Hsync),
      .vsync(Vsync),
      .rgb_out({vgaRed, vgaGreen, vgaBlue}),
      .h(x),
      .v(y)
  );

  //--------------------------------------------------------------------------//
  // ADC
  //--------------------------------------------------------------------------//
  wire [15:0] data;

  XADC_Mod xadc_mod (
      .clk   (clk),
      .vauxp6(JXADC[0]),
      .vauxn6(JXADC[4]),
      .data  (data)
  );

  localparam INT16_MAX = 65536;

  always_ff @(posedge clk_vga) begin
    if (y == (525 - ((data * 480) / INT16_MAX))) begin
      rgb <= 12'b1111_1111_1111;
    end else if (x % 60 == 0 || y % 48 == 0) begin
      rgb <= 12'b0001_0001_0001;
    end else begin
      rgb <= 12'b0;
    end
  end
endmodule
