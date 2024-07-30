module inst_decoder#(

parameter PA_INST_WIDTH = 32'd32,
parameter PA_IMME_OUT = 32'd16,
parameter PA_FNCT_SEL = 32'd9,
parameter PA_ALU_SEL = 32'd9,
parameter PA_ADDR_SEL = 32'd9,
parameter PA_DOB_SEL = 32'd9,
parameter PA_RTR_SEL = 32'd9,
parameter PA_HL_SEL = 32'd2,
parameter PA_IP_SEL = 32'd3,
parameter PA_IP_REG_SEL = 32'd9

)(

input wire        clk,
input wire        rst_b,
input wire [31:0] ir_in,
input wire        cf,
input wire        nf,
input wire        zf,
input wire        vf,
input wire        alu_ack,
input wire        reg_wr_ack,
input wire        mar_wr_ack,
input wire        ram_wr_ack,
input wire        ram_oe_ack,
input wire        dib_ack,

output wire        alu_req,
output wire [15:0] imme_out,
output wire [8:0]  alu_fnct_sel,
output wire [8:0]  alu_a_sel,
output wire [8:0]  alu_b_sel,
output wire [8:0]  addr_sel,
output wire [8:0]  dob_sel,
output wire [8:0]  rtr_sel,
output wire [1:0]  hl_sel,
output wire [2:0]  rb_ip_sel,
output wire [8:0]  rb_ip_reg_sel,
output wire [8:0]  rb_reg_clr_sel,
output wire        dib_sel,
output wire        reg_wr,
output wire        reg_clr,
output wire        pc_incr,
output wire        mar_wr,
output wire        ram_wr,
output wire        ram_oe,
output wire        halt

);

// Interal connection wires
wire [31:0] instr;
wire        ir_wr;
wire        ir_wr_ack;

// Instantiation of the instruction register
inst_reg#(

.PA_DATA_WIDTH(PA_INST_WIDTH)

) ir(

.clk(clk),
.rst_b(rst_b),
.data_in(ir_in),
.ir_wr(ir_wr),
.data_out(instr),
.ir_wr_ack(ir_wr_ack)

);

// Instantiation of the instruction decoder FSM
id_fsm#(

.PA_INST(PA_INST_WIDTH),
.PA_IMME(PA_IMME_OUT),
.PA_FNCT(PA_FNCT_SEL),
.PA_ALU(PA_ALU_SEL),
.PA_ADDR(PA_ADDR_SEL),
.PA_DOB(PA_DOB_SEL),
.PA_RTR(PA_RTR_SEL),
.PA_HL(PA_HL_SEL),
.PA_IP(PA_IP_SEL),
.PA_IP_REG(PA_IP_REG_SEL)

) id_fsm(

.clk(clk),
.rst_b(rst_b),
.instr(instr),
.cf(cf),
.nf(nf),
.zf(zf),
.vf(vf),
.alu_ack(alu_ack),
.reg_wr_ack(reg_wr_ack),
.mar_wr_ack(mar_wr_ack),
.ram_wr_ack(ram_wr_ack),
.ram_oe_ack(ram_oe_ack),
.ir_wr_ack(ir_wr_ack),
.dib_ack(dib_ack),
.ir_wr(ir_wr),
.alu_req(alu_req),
.imme_out(imme_out),
.alu_fnct_sel(alu_fnct_sel),
.alu_a_sel(alu_a_sel),
.alu_b_sel(alu_b_sel),
.addr_sel(addr_sel),
.dob_sel(dob_sel),
.rtr_sel(rtr_sel),
.hl_sel(hl_sel),
.rb_ip_sel(rb_ip_sel),
.rb_ip_reg_sel(rb_ip_reg_sel),
.rb_reg_clr_sel(rb_reg_clr_sel),
.dib_sel(dib_sel),
.reg_wr(reg_wr),
.reg_clr(reg_clr),
.pc_incr(pc_incr),
.mar_wr(mar_wr),
.ram_wr(ram_wr),
.ram_oe(ram_oe),
.halt(halt)

);

endmodule
