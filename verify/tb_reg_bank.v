module tb_reg_bank();

reg        clk;
reg        rst_b;
reg [31:0] alu_out;
reg [31:0] dib;
reg [15:0] id_imme;
reg [8:0]  alu_a_sel;
reg [8:0]  alu_b_sel;
reg [8:0]  addr_sel;
reg [8:0]  dob_sel;
reg [8:0]  rtr_sel;
reg [1:0]  hl_sel;
reg [2:0]  ip_sel;
reg [8:0]  ip_reg_sel;
reg [8:0]  reg_clr_sel;
reg        reg_wr;
reg        reg_clr;
reg        pc_incr;

wire [31:0] alu_a;
wire [31:0] alu_b;
wire [31:0] addr_out;
wire [31:0] dob;
wire        reg_wr_ack; 

reg_bank rb(

.clk(clk),
.rst_b(rst_b),
.alu_out(alu_out),
.dib(dib),
.id_imme(id_imme),
.alu_a_sel(alu_a_sel),
.alu_b_sel(alu_b_sel),
.addr_sel(addr_sel),
.dob_sel(dob_sel),
.rtr_sel(rtr_sel),
.hl_sel(hl_sel),
.ip_sel(ip_sel),
.ip_reg_sel(ip_reg_sel),
.reg_clr_sel(reg_clr_sel),
.reg_wr(reg_wr),
.reg_clr(reg_clr),
.pc_incr(pc_incr),
.alu_a(alu_a),
.alu_b(alu_b),
.addr_out(addr_out),
.dob(dob),
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
  alu_out = 32'hAAAAAAAA;
  dib = 32'hBBBBBBBB;
  id_imme = 32'hCCCCCCCC;
  alu_a_sel = 9'h100;
  alu_b_sel = 9'h100;
  addr_sel = 9'h100;
  dob_sel = 9'h100;
  rtr_sel = 9'h100;
  hl_sel = 2'b0;
  ip_sel = 3'b0;
  ip_reg_sel = 9'h100;
  reg_clr_sel = 9'h100;
  reg_wr = 1'b0;
  reg_clr = 1'b0;
  pc_incr = 1'b0;

  #4 rst_b = 0;
  #2 rst_b = 1;
  #4 ip_sel = 3'b10;
     ip_reg_sel = 9'b0;
  #10 reg_wr = 1;
  #10 reg_wr = 0;
      ip_sel = 3'b11;
      ip_reg_sel = 9'b1;
  #10 reg_wr = 1;
  #10 reg_wr = 0;
      ip_sel = 3'b100;
      ip_reg_sel = 9'h2;
  #10 reg_wr = 1;
  #10 reg_wr = 0;
      ip_sel = 3'b01;
      ip_reg_sel = 9'h3;
      rtr_sel = 9'b1;
  #10 reg_wr = 1;
  #10 reg_wr = 0;
      reg_clr_sel = 9'h2;
      reg_clr = 1;
  #10 reg_clr = 0;
      pc_incr = 1;
  #10 pc_incr = 0;
      alu_a_sel = 9'h0;
      alu_b_sel = 9'h1;
      addr_sel = 9'h2;
      dob_sel = 9'h3;


  #10 $finish;  

end

initial
begin
  $recordfile("tb_reg_bank");
  $recordvars();
end

endmodule
