module tb_alu_fnct();

reg a;
reg b;

wire o;
wire co;

example ex(

.a(a),
.b(b),
.o(o),
.co(co)

);

initial 
begin

  a = 1'b0;
  b = 1'b0;
  #10 a = 1'b0;
      b = 1'b1;
  #10 a = 1'b1;
      b = 1'b0;
  #10 a = 1'b1;
      b = 1'b1;
  
  #50 $finish; 

end

initial
begin
  $recordfile("tb_example");
  $recordvars();
end

endmodule
