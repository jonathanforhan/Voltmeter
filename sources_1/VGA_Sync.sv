`timescale 1ns / 1ps  //
`default_nettype none


module VGA_Sync #(
    parameter H_DISPLAY = 640,  // horizontal display area
    parameter H_L_BORDER = 48,  // horizontal left border
    parameter H_R_BORDER = 16,  // horizontal right border
    parameter H_RETRACE = 96,  // horizontal retrace
    parameter V_DISPLAY = 480,  // vertical display area
    parameter V_T_BORDER = 10,  // vertical top border
    parameter V_B_BORDER = 33,  // vertical bottom border
    parameter V_RETRACE = 2  // vertical retrace
) (
    input wire clk,
    input wire [11:0] rgb_in,
    output wire vidstate,
    output wire hsync,
    output wire vsync,
    output wire [11:0] rgb_out,
    output logic [9:0] h,
    output logic [9:0] v
);
  localparam H_MAX = H_DISPLAY + H_L_BORDER + H_R_BORDER + H_RETRACE - 1;
  localparam START_H_RETRACE = H_DISPLAY + H_R_BORDER;
  localparam END_H_RETRACE = H_DISPLAY + H_R_BORDER + H_RETRACE - 1;

  localparam V_MAX = V_DISPLAY + V_T_BORDER + V_B_BORDER + V_RETRACE - 1;
  localparam START_V_RETRACE = V_DISPLAY + V_B_BORDER;
  localparam END_V_RETRACE = V_DISPLAY + V_B_BORDER + V_RETRACE - 1;

  // iterate left->right top->bottom
  always_ff @(posedge clk) begin
    h++;

    if (h == H_MAX) begin
      h <= 0;
      v++;

      if (v == V_MAX) v <= 0;
    end
  end

  // [h|v]sync are active LOW, so inactive when in retrace
  assign hsync = h >= START_H_RETRACE && h <= END_H_RETRACE;
  assign vsync = v >= START_V_RETRACE && v <= END_V_RETRACE;
  assign vidstate = (h < H_DISPLAY) && (v < V_DISPLAY);

  // VGA expects colors are low when not in screen bounds
  assign rgb_out = vidstate ? rgb_in : 12'b0;
endmodule