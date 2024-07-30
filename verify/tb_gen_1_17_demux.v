module tb_gen_17_1_mux();

parameter PA_DATA_WIDTH = 32;


reg [PA_DATA_WIDTH-1:0] mux_in;
reg [8:0]               sel;
wire [PA_DATA_WIDTH-1:0] reg0;
wire [PA_DATA_WIDTH-1:0] reg1;
wire [PA_DATA_WIDTH-1:0] reg2;
wire [PA_DATA_WIDTH-1:0] reg3;
wire [PA_DATA_WIDTH-1:0] reg4;
wire [PA_DATA_WIDTH-1:0] reg5;
wire [PA_DATA_WIDTH-1:0] reg6;
wire [PA_DATA_WIDTH-1:0] reg7;
wire [PA_DATA_WIDTH-1:0] reg8;
wire [PA_DATA_WIDTH-1:0] reg9;
wire [PA_DATA_WIDTH-1:0] reg10;
wire [PA_DATA_WIDTH-1:0] reg11;
wire [PA_DATA_WIDTH-1:0] reg12;
wire [PA_DATA_WIDTH-1:0] reg13;
wire [PA_DATA_WIDTH-1:0] reg14;
wire [PA_DATA_WIDTH-1:0] reg15;
wire [PA_DATA_WIDTH-1:0] pc;

gen_1_17_demux#(PA_DATA_WIDTH) gen_1_17_demux(

.mux_in(mux_in),
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
.pc(pc)

);

initial
begin

  sel = 9'h100;
  mux_in = 32'hABCDEFAB;
  
  #10 sel = 9'h0;
  #10 sel = 9'h1;
  #10 sel = 9'h2;
  #10 sel = 9'h3;
  #10 sel = 9'h4;
  #10 sel = 9'h5;
  #10 sel = 9'h6;
  #10 sel = 9'h7;
  #10 sel = 9'h8;
  #10 sel = 9'h9;
  #10 sel = 9'hA;
  #10 sel = 9'hB;
  #10 sel = 9'hC;
  #10 sel = 9'hD;
  #10 sel = 9'hE;
  #10 sel = 9'hF;
  #10 sel = 9'hFF;
  

  #10 $finish;
 
end

initial
begin
  $recordfile("tb_gen_1_17_demux");
  $recordvars();
end

endmodule
