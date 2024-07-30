module alu#( 

parameter PA_ADDER_WIDTH = 32'd8,
parameter PA_DATA_WIDTH = 32'd32,
parameter PA_FNCT_SEL = 32'd9

)(

input wire                      clk,
input wire                      rst_b,
input wire  [PA_DATA_WIDTH-1:0] inp_a,
input wire  [PA_DATA_WIDTH-1:0] inp_b,
input wire  [PA_FNCT_SEL-1:0]   fnct_sel,
input wire                      alu_req,
output wire [PA_DATA_WIDTH-1:0] alu_output,
output wire                     cf,
output wire                     zf,
output wire                     nf,
output wire                     vf,
output wire                     alu_ack

);

wire [7:0] adder_a;
wire [7:0] adder_b;
wire       cy_in;
wire [7:0] adder_o;
wire       cy_out;

// Instantiation of the ALU finite state machine
alu_fsm
#(

.PA_DATA(PA_DATA_WIDTH),
.PA_FNCT(PA_FNCT_SEL),
.PA_ADDER_DATA(PA_ADDER_WIDTH)

) fsm(

.clk(clk),
.rst_b(rst_b),
.inp_a(inp_a),
.inp_b(inp_b),
.fnct_sel(fnct_sel),
.adder_out(adder_o),
.carry_out(cy_out),
.alu_req(alu_req),
.alu_out(alu_output),
.alu_ack(alu_ack),
.adder_in_a(adder_a),
.adder_in_b(adder_b),
.carry_in(cy_in),
.cf(cf),
.zf(zf),
.nf(nf),
.vf(vf)

);

// Instantiation of the 8-bit adder
adder_8_bit#(

.PA_DATA_WIDTH(PA_ADDER_WIDTH)

) adder(

.clk(clk),
.rst_b(rst_b),
.adder_in_a(adder_a),
.adder_in_b(adder_b),
.carry_in(cy_in),
.adder_out(adder_o),
.carry_out(cy_out)

);

endmodule
