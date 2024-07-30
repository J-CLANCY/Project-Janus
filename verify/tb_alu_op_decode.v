module tb_alu_op_decode();

reg         clk;
reg         rst_b;
reg [31:0]  fnct_out;
reg         cf_curr;
reg         nf_curr;
reg         zf_curr;
reg         vf_curr;

wire [31:0] alu_out;
wire        alu_ack;
wire        cf;
wire        nf;
wire        zf;
wire        vf;

alu_op_decode alu_op_decode(

.clk(clk),
.rst_b(rst_b),
.fnct_out(fnct_out),
.cf_curr(cf_curr),
.nf_curr(nf_curr),
.zf_curr(zf_curr),
.vf_curr(vf_curr),
.alu_out(alu_out),
.alu_ack(alu_ack),
.cf(cf),
.nf(nf),
.zf(zf),
.vf(vf)

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
  fnct_out = 32'h0;
  cf_curr = 0;
  nf_curr = 0;
  zf_curr = 0;
  vf_curr = 0;

  #4 rst_b = 0;
  #2 rst_b = 1;
  #4 fnct_out = 32'hAAAAAAAA;
     cf_curr = 1;
     nf_curr = 1;

  #20 $finish;  

end

initial
begin
  $recordfile("tb_alu_op_decode");
  $recordvars();
end

endmodule
