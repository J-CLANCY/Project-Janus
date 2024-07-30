module tb_janus();

reg        clk_janus;
reg        rst_janus_b;

wire [31:0] dib_janus;
wire [2:0]  cb_in;
wire [31:0] dob;
wire [31:0] ab;
wire [2:0]  cb_out;
wire        halt;

integer j;

janus janus(

.clk_janus(clk_janus),
.rst_janus_b(rst_janus_b),
.dib_janus(dib_janus),
.cb_in(cb_in),
.dob(dob),
.ab(ab),
.cb_out(cb_out),
.halt(halt)

);

ram ram(

.clk(clk_janus),
.rst_b(rst_janus_b),
.cb_out(cb_out),
.ab(ab),
.dob(dob),
.cb_in(cb_in),
.dib(dib_janus)

);

initial
begin
  clk_janus = 1;
end

always 
  #5 clk_janus = !clk_janus;

initial
begin
   
  rst_janus_b = 1;

  #2 rst_janus_b = 0;
  #4 rst_janus_b = 1;
  #4
  #100000 $finish;  

end

initial
begin
  $recordfile("tb_janus");
  $recordvars();
  for(j=0;j<256;j=j+1) begin
    $recordvars(ram.mem[j]);
  end
end

endmodule
