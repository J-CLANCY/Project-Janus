module alu_functions(

input wire [31:0]  inp_a,
input wire [31:0]  inp_b,
output wire [31:0] add_out,
output wire [31:0] sub_out,
output reg [31:0]  and_out,
output reg [31:0]  or_out,
output reg [31:0]  xor_out,
output reg [31:0]  sfl_out,
output reg [31:0]  sfr_out,
output reg [31:0]  chk_out,
output reg         cf,
output reg        nf,
output reg        zf,
output reg        vf

);

reg [32:0] add_inter;
reg [32:0] sub_inter;

// This module contains all of the functions the ALU
// can perform and it generates all of the corresponding
// flags, i.e, carry, negative, zero, overflow

always @(*)
begin: alu_fnct
  add_inter = inp_a + inp_b;
  sub_inter = inp_a - inp_b;
  and_out = inp_a & inp_b;
  or_out = inp_a | inp_b;
  xor_out = inp_a ^ inp_b;
  sfl_out = inp_a << 1;
  sfr_out = inp_a >> 1;
  chk_out = inp_a;
  
  cf = add_inter[32] | sub_inter[32]; // Carry generation
  zf = (chk_out == 0); // Zero flag generation
  nf = (chk_out < 0); // Negative flag generations
  vf = ((inp_a[31] == 1'b1) && (inp_b[31] == 1'b 1)); // Overflow flag generation
end

assign add_out = add_inter[31:0];
assign sub_out = sub_inter[31:0];

endmodule
