module janus#(

parameter PA_JANUS_INST_WIDTH = 32'd32,
parameter PA_JANUS_IMME_OUT = 32'd16,
parameter PA_JANUS_FNCT_SEL = 32'd9,
parameter PA_JANUS_HL_SEL = 32'd2,
parameter PA_JANUS_IP_SEL = 32'd3,
parameter PA_JANUS_IP_REG_SEL = 32'd9,
parameter PA_JANUS_DATA_WIDTH = 32'd32,
parameter PA_JANUS_ADDER_WIDTH = 32'd8

)(

input wire         clk_janus,
input wire         rst_janus_b,
input wire  [31:0] dib_janus,
input wire  [2:0]  cb_in,
output wire [31:0] dob,
output wire [31:0] ab,
output wire [2:0]  cb_out,
output wire        halt

);

// Wires that connect all the modules
wire [31:0] alu_a;
wire [31:0] alu_b;
wire [8:0]  alu_fnct_sel;
wire [31:0] alu_out;
wire        cf;
wire        zf;
wire        nf;
wire        vf;
wire        alu_ack;
wire        alu_request;
wire [15:0] imme_out;
wire [8:0]  alu_a_sel;
wire [8:0]  alu_b_sel;
wire [8:0]  addr_sel;
wire [8:0]  dob_sel;
wire [8:0]  rtr_sel;
wire [1:0]  hl_sel;
wire [2:0]  rb_ip_sel;
wire [8:0]  rb_ip_reg_sel;
wire [8:0]  rb_reg_clr_sel;
wire        dib_sel;
wire        reg_wr;
wire        reg_clr;
wire        pc_incr;
wire        reg_wr_ack;
wire        dib_ack;

// Regs for the little demux
wire [31:0]  dib_id;
wire [31:0]  dib_rb;

// 1-to-2 Demux that controls where the data input bus goes
dib_demux#(

.PA_DATA_WIDTH(PA_JANUS_DATA_WIDTH)

) dib_demux(

.clk(clk_janus),
.rst_b(rst_janus_b),
.dib(dib_janus),
.dib_sel(dib_sel),
.ram_oe_ack(cb_in[2]),
.dib_id(dib_id),
.dib_rb(dib_rb),
.dib_ack(dib_ack)

);

// Instantiation of the ALU
alu#(

.PA_DATA_WIDTH(PA_JANUS_DATA_WIDTH),
.PA_FNCT_SEL(PA_JANUS_FNCT_SEL),
.PA_ADDER_WIDTH(PA_JANUS_ADDER_WIDTH)

) alu(

.clk(clk_janus),
.rst_b(rst_janus_b),
.inp_a(alu_a),
.inp_b(alu_b),
.fnct_sel(alu_fnct_sel),
.alu_req(alu_request),
.alu_output(alu_out),
.cf(cf),
.zf(zf),
.nf(nf),
.vf(vf),
.alu_ack(alu_ack)

);

// Instantiation of the register bank
reg_bank#(

.PA_DATA_WIDTH(PA_JANUS_DATA_WIDTH),
.PA_HL_SEL(PA_JANUS_HL_SEL),
.PA_IP_SEL(PA_JANUS_IP_SEL),
.PA_IMME_VAL(PA_JANUS_IMME_OUT),
.PA_IP_REG(PA_JANUS_IP_REG_SEL)

) reg_bank(

.clk(clk_janus),
.rst_b(rst_janus_b),
.alu_out(alu_out),
.dib(dib_rb),
.id_imme(imme_out),
.alu_a_sel(alu_a_sel),
.alu_b_sel(alu_b_sel),
.addr_sel(addr_sel),
.dob_sel(dob_sel),
.rtr_sel(rtr_sel),
.hl_sel(hl_sel),
.ip_sel(rb_ip_sel),
.ip_reg_sel(rb_ip_reg_sel),
.reg_clr_sel(rb_reg_clr_sel),
.reg_wr(reg_wr),
.reg_clr(reg_clr),
.pc_incr(pc_incr),
.alu_a(alu_a),
.alu_b(alu_b),
.addr_out(ab),
.dob(dob),
.reg_wr_ack(reg_wr_ack)

);

// Instantiation of the instruction decoder
inst_decoder#(

.PA_INST_WIDTH(PA_JANUS_INST_WIDTH),
.PA_IMME_OUT(PA_JANUS_IMME_OUT),
.PA_FNCT_SEL(PA_JANUS_FNCT_SEL),
.PA_ALU_SEL(PA_JANUS_IP_REG_SEL),
.PA_ADDR_SEL(PA_JANUS_IP_REG_SEL),
.PA_DOB_SEL(PA_JANUS_IP_REG_SEL),
.PA_RTR_SEL(PA_JANUS_IP_REG_SEL),
.PA_HL_SEL(PA_JANUS_HL_SEL),
.PA_IP_SEL(PA_JANUS_IP_SEL),
.PA_IP_REG_SEL(PA_JANUS_IP_REG_SEL)

) inst_decoder(

.clk(clk_janus),
.rst_b(rst_janus_b),
.ir_in(dib_id),
.cf(cf),
.nf(nf),
.zf(zf),
.vf(vf),
.alu_ack(alu_ack),
.reg_wr_ack(reg_wr_ack),
.mar_wr_ack(cb_in[0]),
.ram_wr_ack(cb_in[1]),
.ram_oe_ack(cb_in[2]),
.dib_ack(dib_ack),
.alu_req(alu_request),
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
.mar_wr(cb_out[0]),
.ram_wr(cb_out[1]),
.ram_oe(cb_out[2]),
.halt(halt)

);


endmodule
