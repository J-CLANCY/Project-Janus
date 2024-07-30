module tb_alu_fnct();

reg [31:0] inp_a;
reg [31:0] inp_b;

wire [31:0] add_out;
wire [31:0] sub_out;
wire [31:0] and_out;
wire [31:0] or_out;
wire [31:0] xor_out;
wire [31:0] sfl_out;
wire [31:0] sfr_out;
wire [31:0] chk_out;
wire        cf;
wire        nf;
wire        zf;
wire        vf;

alu_functions alu_fnct(

.inp_a(inp_a),
.inp_b(inp_b),
.add_out(add_out),
.sub_out(sub_out),
.and_out(and_out),
.or_out(or_out),
.xor_out(xor_out),
.sfl_out(sfl_out),
.sfr_out(sfr_out),
.chk_out(chk_out),
.cf(cf),
.nf(nf),
.zf(zf),
.vf(vf)

);

initial 
begin

  inp_a = 32'h00000004;
  inp_b = 32'h0000000A;
  
  #10 $finish; 

end

initial
begin
  $recordfile("tb_alu_fnct");
  $recordvars();
end

endmodule
