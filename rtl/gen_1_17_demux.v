module gen_1_17_demux
#(

parameter PA_DATA = 32'd32,
parameter PA_SEL = 32'd9

)
(

input wire                     clk,
input wire                     rst_b,
input wire [PA_DATA-1:0] mux_in,
input wire [PA_SEL-1:0]        sel,
output reg [PA_DATA-1:0] reg0,
output reg [PA_DATA-1:0] reg1,
output reg [PA_DATA-1:0] reg2,
output reg [PA_DATA-1:0] reg3,
output reg [PA_DATA-1:0] reg4,
output reg [PA_DATA-1:0] reg5,
output reg [PA_DATA-1:0] reg6,
output reg [PA_DATA-1:0] reg7,
output reg [PA_DATA-1:0] reg8,
output reg [PA_DATA-1:0] reg9,
output reg [PA_DATA-1:0] reg10,
output reg [PA_DATA-1:0] reg11,
output reg [PA_DATA-1:0] reg12,
output reg [PA_DATA-1:0] reg13,
output reg [PA_DATA-1:0] reg14,
output reg [PA_DATA-1:0] reg15,
output reg [PA_DATA-1:0] pc

);

// This is the general purpose demultiplexer that the system will
// use to instantiate demuxes of varying bus widths in the register
// bank
reg [PA_DATA-1:0] cmb_reg0;
reg [PA_DATA-1:0] cmb_reg1;
reg [PA_DATA-1:0] cmb_reg2;
reg [PA_DATA-1:0] cmb_reg3;
reg [PA_DATA-1:0] cmb_reg4;
reg [PA_DATA-1:0] cmb_reg5;
reg [PA_DATA-1:0] cmb_reg6;
reg [PA_DATA-1:0] cmb_reg7;
reg [PA_DATA-1:0] cmb_reg8;
reg [PA_DATA-1:0] cmb_reg9;
reg [PA_DATA-1:0] cmb_reg10;
reg [PA_DATA-1:0] cmb_reg11;
reg [PA_DATA-1:0] cmb_reg12;
reg [PA_DATA-1:0] cmb_reg13;
reg [PA_DATA-1:0] cmb_reg14;
reg [PA_DATA-1:0] cmb_reg15;
reg [PA_DATA-1:0] cmb_pc;

// This is the state reg of the demux
always @(posedge clk or negedge rst_b)
begin: gen_1_17_demux_reg
  if(rst_b == 1'b0) begin
    reg0 <= {PA_DATA{1'b0}}; 
    reg1 <= {PA_DATA{1'b0}};
    reg2 <= {PA_DATA{1'b0}};
    reg3 <= {PA_DATA{1'b0}};
    reg4 <= {PA_DATA{1'b0}};
    reg5 <= {PA_DATA{1'b0}};
    reg6 <= {PA_DATA{1'b0}};
    reg7 <= {PA_DATA{1'b0}};
    reg8 <= {PA_DATA{1'b0}};
    reg9 <= {PA_DATA{1'b0}};
    reg10 <= {PA_DATA{1'b0}};
    reg11 <= {PA_DATA{1'b0}};
    reg12 <= {PA_DATA{1'b0}};
    reg13 <= {PA_DATA{1'b0}};
    reg14 <= {PA_DATA{1'b0}};
    reg15 <= {PA_DATA{1'b0}};
    pc <= {PA_DATA{1'b0}};
  end
  else begin
    reg0 <= cmb_reg0;
    reg1 <= cmb_reg1;
    reg2 <= cmb_reg2;
    reg3 <= cmb_reg3;
    reg4 <= cmb_reg4;
    reg5 <= cmb_reg5;
    reg6 <= cmb_reg6;
    reg7 <= cmb_reg7;
    reg8 <= cmb_reg8;
    reg9 <= cmb_reg9;
    reg10 <= cmb_reg10;
    reg11 <= cmb_reg11;
    reg12 <= cmb_reg12;
    reg13 <= cmb_reg13;
    reg14 <= cmb_reg14;
    reg15 <= cmb_reg15;
    pc <= cmb_pc;
  end
end

always @(*)
begin: gen_1_17_demux
  cmb_reg0 = {PA_DATA{1'b0}}; 
  cmb_reg1 = {PA_DATA{1'b0}};
  cmb_reg2 = {PA_DATA{1'b0}};
  cmb_reg3 = {PA_DATA{1'b0}};
  cmb_reg4 = {PA_DATA{1'b0}};
  cmb_reg5 = {PA_DATA{1'b0}};
  cmb_reg6 = {PA_DATA{1'b0}};
  cmb_reg7 = {PA_DATA{1'b0}};
  cmb_reg8 = {PA_DATA{1'b0}};
  cmb_reg9 = {PA_DATA{1'b0}};
  cmb_reg10 = {PA_DATA{1'b0}};
  cmb_reg11 = {PA_DATA{1'b0}};
  cmb_reg12 = {PA_DATA{1'b0}};
  cmb_reg13 = {PA_DATA{1'b0}};
  cmb_reg14 = {PA_DATA{1'b0}};
  cmb_reg15 = {PA_DATA{1'b0}};
  cmb_pc = {PA_DATA{1'b0}};

  case(sel)
    9'h000:cmb_reg0 = mux_in;
    9'h001:cmb_reg1 = mux_in;
    9'h002:cmb_reg2 = mux_in;
    9'h003:cmb_reg3 = mux_in;
    9'h004:cmb_reg4 = mux_in;
    9'h005:cmb_reg5 = mux_in;
    9'h006:cmb_reg6 = mux_in;
    9'h007:cmb_reg7 = mux_in;
    9'h008:cmb_reg8 = mux_in;
    9'h009:cmb_reg9 = mux_in;
    9'h00A:cmb_reg10 = mux_in;
    9'h00B:cmb_reg11 = mux_in;
    9'h00C:cmb_reg12 = mux_in;
    9'h00D:cmb_reg13 = mux_in;
    9'h00E:cmb_reg14 = mux_in;
    9'h00F:cmb_reg15 = mux_in;
    9'h0FF:cmb_pc = mux_in;
  endcase
end
    
endmodule
