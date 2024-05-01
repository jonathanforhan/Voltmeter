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

  wire clk_vga;

  Clock_Conv #(
      .FREQ_IN (100_000_000),
      .FREQ_OUT(25_000_000)
  ) clock_conv (
      .clk_in (clk),
      .clk_out(clk_vga)
  );

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

  wire enable, ready;
  wire  [15:0] data;
  logic [ 6:0] addr_in = 8'h16;

  xadc_wiz_0 XLXI_7 (
      .di_in              (0),         // input wire [15 : 0] di_in
      .daddr_in           (addr_in),   // input wire [6 : 0] daddr_in
      .den_in             (enable),    // input wire den_in
      .dwe_in             (0),         // input wire dwe_in
      .drdy_out           (ready),     // output wire drdy_out
      .do_out             (data),      // output wire [15 : 0] do_out
      .dclk_in            (clk),       // input wire dclk_in
      .reset_in           (0),         // input wire reset_in
      .vp_in              (0),         // input wire vp_in
      .vn_in              (0),         // input wire vn_in
      .vauxp6             (JXADC[0]),  // input wire vauxp6
      .vauxn6             (JXADC[4]),  // input wire vauxn6
      .user_temp_alarm_out(0),         // output wire user_temp_alarm_out
      .vccint_alarm_out   (0),         // output wire vccint_alarm_out
      .vccaux_alarm_out   (0),         // output wire vccaux_alarm_out
      .ot_out             (0),         // output wire ot_out
      .channel_out        (0),         // output wire [4 : 0] channel_out
      .eoc_out            (enable),    // output wire eoc_out
      .alarm_out          (0),         // output wire alarm_out
      .eos_out            (0),         // output wire eos_out
      .busy_out           (0)          // output wire busy_out
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
