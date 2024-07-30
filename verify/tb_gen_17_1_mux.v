module tb_gen_17_1_mux();

parameter PA_DATA_WIDTH = 32;

reg                     clk;
reg                     rst_b;
reg [8:0]               sel;
reg [PA_DATA_WIDTH-1:0] reg0;
reg [PA_DATA_WIDTH-1:0] reg1;
reg [PA_DATA_WIDTH-1:0] reg2;
reg [PA_DATA_WIDTH-1:0] reg3;
reg [PA_DATA_WIDTH-1:0] reg4;
reg [PA_DATA_WIDTH-1:0] reg5;
reg [PA_DATA_WIDTH-1:0] reg6;
reg [PA_DATA_WIDTH-1:0] reg7;
reg [PA_DATA_WIDTH-1:0] reg8;
reg [PA_DATA_WIDTH-1:0] reg9;
reg [PA_DATA_WIDTH-1:0] reg10;
reg [PA_DATA_WIDTH-1:0] reg11;
reg [PA_DATA_WIDTH-1:0] reg12;
reg [PA_DATA_WIDTH-1:0] reg13;
reg [PA_DATA_WIDTH-1:0] reg14;
reg [PA_DATA_WIDTH-1:0] reg15;
reg [PA_DATA_WIDTH-1:0] pc;

wire [PA_DATA_WIDTH-1:0] mux_out;
wire                     mux_ack;

gen_17_1_mux#(.PA_DATA_WIDTH(32)) gen_17_1_mux(

.clk(clk),
.rst_b(rst_b),
.sel(sel),
.reg0(reg0),
.reg1(reg1),
.reg2(reg2),
.reg3(reg3),
.reg4(reg4),
.reg5(reg5),
.reg6(reg6),
.reg7(reg7),
.reg8(reg8),
.reg9(reg9),
.reg10(reg10),
.reg11(reg11),
.reg12(reg12),
.reg13(reg13),
.reg14(reg14),
.reg15(reg15),
.pc(pc),
.mux_out(mux_out),
.mux_ack(mux_ack)

);

initial
begin
  clk = 1;
end

always 
  #5 clk = !clk;

initial
begin

  sel = 9'h100;
  reg0 = 32'h0;
  reg1 = 32'h11111111;
  reg2 = 32'h22222222;
  reg3 = 32'h33333333;
  reg4 = 32'h44444444;
  reg5 = 32'h55555555;
  reg6 = 32'h66666666;
  reg7 = 32'h77777777;
  reg8 = 32'h88888888;
  reg9 = 32'h99999999;
  reg10 = 32'hAAAAAAAA;
  reg11 = 32'hBBBBBBBB;
  reg12 = 32'hCCCCCCCC;
  reg13 = 32'hDDDDDDDD;
  reg14 = 32'hEEEEEEEE;
  reg15 = 32'hFFFFFFFF;
  pc = 32'hABABABAB; 
  rst_b = 1'b1;
  
  #2 rst_b = 1'b0;
  #4 rst_b = 1'b1;
  #4
  #10 sel = 9'h0;
 
  

  #100 $finish;
 
end

initial
begin
  $recordfile("tb_gen_17_1_mux");
  $recordvars();
end

endmodule
