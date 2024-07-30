module tb_alu_mux();

reg [31:0] add_out;
reg [31:0] sub_out;
reg [31:0] and_out;
reg [31:0] or_out;
reg [31:0] xor_out;
reg [31:0] sfl_out;
reg [31:0] sfr_out;
reg [31:0] chk_out;
reg [8:0]  fnct_sel;

wire [31:0] mux_out;

alu_mux alu_mux(

.add_out(add_out),
.sub_out(sub_out),
.and_out(and_out),
.or_out(or_out),
.xor_out(xor_out),
.sfl_out(sfl_out),
.sfr_out(sfr_out),
.chk_out(chk_out),
.fnct_sel(fnct_sel),
.mux_out(mux_out)

);

initial
begin

  add_out = 32'hAAAAAAAA;
  sub_out = 32'hBBBBBBBB;
  and_out = 32'hCCCCCCCC;
  or_out = 32'hDDDDDDDD;
  xor_out = 32'hEEEEEEEE;
  sfl_out = 32'hFFFFFFFF;
  sfr_out = 32'hABCDABCD;
  chk_out = 32'hABABABAB;
  fnct_sel = 9'h100;

  #10 fnct_sel = 9'h0;
  #10 fnct_sel = 9'b001000000;
  #10 fnct_sel = 9'b001000001;
  #10 fnct_sel = 9'b010000000;
  #10 fnct_sel = 9'b010000001;
  #10 fnct_sel = 9'b010000010;
  #10 fnct_sel = 9'b010000011;
  #10 fnct_sel = 9'b010000100;

  #10 $finish;  

end

initial
begin
  $recordfile("tb_alu_mux");
  $recordvars();
end

endmodule
