module tb_wr_req();

reg clk;
reg rst_b;
reg wr_req;

wire wr_out;

wr_req_fsm wr_req_fsm(

.clk(clk),
.rst_b(rst_b),
.wr_req(wr_req),
.wr_out(wr_out)

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
  wr_req = 0;

  #2 rst_b = 0;
  #4 rst_b = 1;
  #4 wr_req = 1;
  #10 wr_req = 0;

  #30 $finish;  

end

initial
begin
  $recordfile("tb_wr_req");
  $recordvars();
end

endmodule
