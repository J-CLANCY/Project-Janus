module gen_17_1_mux#(

  parameter PA_DATA = 32'd32,
  parameter PA_SEL = 32'd9

)
(

input wire                     clk,
input wire                     rst_b,
input wire [PA_SEL-1:0]        sel,
input wire [PA_DATA-1:0] reg0,
input wire [PA_DATA-1:0] reg1,
input wire [PA_DATA-1:0] reg2,
input wire [PA_DATA-1:0] reg3,
input wire [PA_DATA-1:0] reg4,
input wire [PA_DATA-1:0] reg5,
input wire [PA_DATA-1:0] reg6,
input wire [PA_DATA-1:0] reg7,
input wire [PA_DATA-1:0] reg8,
input wire [PA_DATA-1:0] reg9,
input wire [PA_DATA-1:0] reg10,
input wire [PA_DATA-1:0] reg11,
input wire [PA_DATA-1:0] reg12,
input wire [PA_DATA-1:0] reg13,
input wire [PA_DATA-1:0] reg14,
input wire [PA_DATA-1:0] reg15,
input wire [PA_DATA-1:0] pc,
output reg [PA_DATA-1:0] mux_out

);

// This is the general purpose multiplexer that the system will
// use to instantiate all of it's muxes of varying bus widths
reg [PA_DATA-1:0] cmb_mux_out;

// This is the state reg of the mux
always @(posedge clk or negedge rst_b)
begin: gen_17_1_mux_reg
  if(rst_b == 1'b0) begin
    mux_out <= {PA_DATA{1'b0}};
  end
  else begin
    mux_out <= cmb_mux_out;
  end
end

always @(*)
begin: gen_17_1_mux
  case(sel)
    9'h000: cmb_mux_out = reg0;
    9'h001: cmb_mux_out = reg1;
    9'h002: cmb_mux_out = reg2;
    9'h003: cmb_mux_out = reg3;
    9'h004: cmb_mux_out = reg4;
    9'h005: cmb_mux_out = reg5;
    9'h006: cmb_mux_out = reg6;
    9'h007: cmb_mux_out = reg7;
    9'h008: cmb_mux_out = reg8;
    9'h009: cmb_mux_out = reg9;
    9'h00A: cmb_mux_out = reg10;
    9'h00B: cmb_mux_out = reg11;
    9'h00C: cmb_mux_out = reg12;
    9'h00D: cmb_mux_out = reg13;
    9'h00E: cmb_mux_out = reg14;
    9'h00F: cmb_mux_out = reg15;
    9'h0FF: cmb_mux_out = pc;
    9'h100: cmb_mux_out = 32'd0; 
    default: cmb_mux_out = 32'd0;
  endcase
end


endmodule
