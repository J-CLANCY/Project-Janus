module tb_gp_reg();

reg        clk;
reg        rst_b;
reg [31:0] data_in;
reg [1:0]  hl_sel;
reg        reg_wr;
reg        reg_clr;

wire [31:0] data_out;
wire        reg_wr_ack;

gp_reg gp_reg(

.clk(clk),
.rst_b(rst_b),
.data_in(data_in),
.hl_sel(hl_sel),
.reg_wr(reg_wr),
.reg_clr(reg_clr),
.data_out(data_out),
.reg_wr_ack(reg_wr_ack)

);

initial
begin
  clk = 1;
end

always
  #5 clk = !clk;

initial
begin
  rst_b = 1;
  data_in = 32'hAAAAAAAA;
  hl_sel = 2'b0;
  reg_wr = 0;
  reg_clr = 0;
  
  #4 rst_b = 0;
  #2 rst_b = 1;
  #4 reg_wr = 1;
  #10 reg_wr = 0;
      data_in = 32'hBBBBBBBB;
  #10 hl_sel = 2'b01; 
      reg_wr = 1;
  #10 reg_wr = 0;
      data_in = 32'hCCCCCCCC;
  #10 hl_sel = 2'b10;
      reg_wr = 1;
  #10 reg_wr = 0;
  #10 reg_clr = 1;
  #10 reg_clr = 0;

  #10 $finish;  

end

initial
begin
  $recordfile("tb_gp_reg");
  $recordvars();
end

endmodule
