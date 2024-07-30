module tb_ip_mux();

reg [2:0] ip_sel;
reg [1:0] hl_sel;
reg [31:0] rtr_out;
reg [31:0] alu_out;
reg [31:0] dib;
reg [15:0] id_imme;

wire [31:0] mux_out;

ip_mux ip_mux(

.ip_sel(ip_sel),
.hl_sel(hl_sel),
.rtr_out(rtr_out),
.alu_out(alu_out),
.dib(dib),
.id_imme(id_imme),
.mux_out(mux_out)

);

initial
begin

  ip_sel = 3'b0;
  hl_sel = 2'b0;
  rtr_out = 32'hAAAAAAAA;
  alu_out = 32'hBBBBBBBB;
  dib = 32'hCCCCCCCC;
  id_imme = 16'hDDDD;
  
  #10 ip_sel = 3'b1;
  #10 ip_sel = 3'b10;
  #10 ip_sel = 3'b11;
  #10 ip_sel = 3'b100;
  #10 hl_sel = 2'b10;
  #10 hl_sel = 2'b01;
  #10 ip_sel = 3'b0;

  #10 $finish;
 
end

initial
begin
  $recordfile("tb_ip_mux");
  $recordvars();
end

endmodule
