module tb_alu();

reg clk;
reg rst_b;
reg [31:0] inp_a;
reg [31:0] inp_b;
reg [8:0]  fnct_sel;

wire [31:0] out;
wire        cf;
wire        nf;
wire        zf;
wire        vf;
wire        alu_ack;

alu alu(

.clk(clk),
.rst_b(rst_b),
.inp_a(inp_a),
.inp_b(inp_b),
.fnct_sel(fnct_sel),
.out(out),
.cf(cf),
.nf(nf),
.zf(zf),
.vf(vf),
.alu_ack(alu_ack)

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
  inp_a = 32'h00000008;
  inp_b = 32'h00000004;
  fnct_sel = 9'h100;

  #4 rst_b = 0;
  #2 rst_b = 1;
  #4 fnct_sel = 9'b0;
  #10
  #10 fnct_sel = 9'b001000000;
  #10
  #10 fnct_sel = 9'b001000001;
  #10
  #10 fnct_sel = 9'b010000000;
  #10
  #10 fnct_sel = 9'b010000001;
  #10
  #10 fnct_sel = 9'b010000010;
  #10
  #10 fnct_sel = 9'b010000011;
  #10
  #10 fnct_sel = 9'b010000100;
  
  #10 $finish;  

end

initial
begin
  $recordfile("tb_alu");
  $recordvars();
end

endmodule
