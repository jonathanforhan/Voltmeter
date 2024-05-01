`timescale 1ns / 1ps  //
`default_nettype none


/// XADC module wrapper
module XADC_Mod (
    input wire clk,  // 100MHz
    input wire vauxp6,
    input wire vauxn6,
    output wire [15:0] data
);
  wire enable, ready;
  logic [6:0] addr_in = 8'h16;  // obtained through datasheet

  //--- IP generated
  xadc_wiz_0 XLXI_7 (
      .di_in              (0),        // input wire [15 : 0] di_in
      .daddr_in           (addr_in),  // input wire [6 : 0] daddr_in
      .den_in             (enable),   // input wire den_in
      .dwe_in             (0),        // input wire dwe_in
      .drdy_out           (ready),    // output wire drdy_out
      .do_out             (data),     // output wire [15 : 0] do_out
      .dclk_in            (clk),      // input wire dclk_in
      .reset_in           (0),        // input wire reset_in
      .vp_in              (0),        // input wire vp_in
      .vn_in              (0),        // input wire vn_in
      .vauxp6             (vauxp6),   // input wire vauxp6
      .vauxn6             (vauxn6),   // input wire vauxn6
      .user_temp_alarm_out(0),        // output wire user_temp_alarm_out
      .vccint_alarm_out   (0),        // output wire vccint_alarm_out
      .vccaux_alarm_out   (0),        // output wire vccaux_alarm_out
      .ot_out             (0),        // output wire ot_out
      .channel_out        (0),        // output wire [4 : 0] channel_out
      .eoc_out            (enable),   // output wire eoc_out
      .alarm_out          (0),        // output wire alarm_out
      .eos_out            (0),        // output wire eos_out
      .busy_out           (0)         // output wire busy_out
  );
endmodule
