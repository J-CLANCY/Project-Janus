module reg_bank#(

parameter PA_DATA_WIDTH = 32'd32,
parameter PA_HL_SEL = 32'd2,
parameter PA_IP_SEL = 32'd3,
parameter PA_IMME_VAL = 32'd16,
parameter PA_IP_REG = 32'd9

)(

input wire        clk,
input wire        rst_b,
input wire [31:0] alu_out,
input wire [31:0] dib,
input wire [15:0] id_imme,
input wire [8:0]  alu_a_sel,
input wire [8:0]  alu_b_sel,
input wire [8:0]  addr_sel,
input wire [8:0]  dob_sel,
input wire [8:0]  rtr_sel,
input wire [1:0]  hl_sel,
input wire [2:0]  ip_sel,
input wire [8:0]  ip_reg_sel,
input wire [8:0]  reg_clr_sel,
input wire        reg_wr,
input wire        reg_clr,
input wire        pc_incr,
output wire [31:0] alu_a,
output wire [31:0] alu_b,
output wire [31:0] addr_out,
output wire [31:0] dob,
output wire        reg_wr_ack 

);

// All of the wires that connect the modules together

wire [31:0] rtr_out;
wire [31:0] ipsel_ipreg;
wire        wr_out;

wire [31:0] pc_data_in;
wire [1:0]  pc_hl_sel;
wire        pc_reg_wr;
wire        pc_reg_clr;
wire [31:0] pc_data_out;
wire        pc_reg_wr_ack;

wire [31:0] reg0_data_in;
wire [1:0]  reg0_hl_sel;
wire        reg0_reg_wr;
wire        reg0_reg_clr;
wire [31:0] reg0_data_out;
wire        reg0_reg_wr_ack;

wire [31:0] reg1_data_in;
wire [1:0]  reg1_hl_sel;
wire        reg1_reg_wr;
wire        reg1_reg_clr;
wire [31:0] reg1_data_out;
wire        reg1_reg_wr_ack;

wire [31:0] reg2_data_in;
wire [1:0]  reg2_hl_sel;
wire        reg2_reg_wr;
wire        reg2_reg_clr;
wire [31:0] reg2_data_out;
wire        reg2_reg_wr_ack;

wire [31:0] reg3_data_in;
wire [1:0]  reg3_hl_sel;
wire        reg3_reg_wr;
wire        reg3_reg_clr;
wire [31:0] reg3_data_out;
wire        reg3_reg_wr_ack;

wire [31:0] reg4_data_in;
wire [1:0]  reg4_hl_sel;
wire        reg4_reg_wr;
wire        reg4_reg_clr;
wire [31:0] reg4_data_out;
wire        reg4_reg_wr_ack;

wire [31:0] reg5_data_in;
wire [1:0]  reg5_hl_sel;
wire        reg5_reg_wr;
wire        reg5_reg_clr;
wire [31:0] reg5_data_out;
wire        reg5_reg_wr_ack;

wire [31:0] reg6_data_in;
wire [1:0]  reg6_hl_sel;
wire        reg6_reg_wr;
wire        reg6_reg_clr;
wire [31:0] reg6_data_out;
wire        reg6_reg_wr_ack;

wire [31:0] reg7_data_in;
wire [1:0]  reg7_hl_sel;
wire        reg7_reg_wr;
wire        reg7_reg_clr;
wire [31:0] reg7_data_out;
wire        reg7_reg_wr_ack;

wire [31:0] reg8_data_in;
wire [1:0]  reg8_hl_sel;
wire        reg8_reg_wr;
wire        reg8_reg_clr;
wire [31:0] reg8_data_out;
wire        reg8_reg_wr_ack;

wire [31:0] reg9_data_in;
wire [1:0]  reg9_hl_sel;
wire        reg9_reg_wr;
wire        reg9_reg_clr;
wire [31:0] reg9_data_out;
wire        reg9_reg_wr_ack;

wire [31:0] reg10_data_in;
wire [1:0]  reg10_hl_sel;
wire        reg10_reg_wr;
wire        reg10_reg_clr;
wire [31:0] reg10_data_out;
wire        reg10_reg_wr_ack;

wire [31:0] reg11_data_in;
wire [1:0]  reg11_hl_sel;
wire        reg11_reg_wr;
wire        reg11_reg_clr;
wire [31:0] reg11_data_out;
wire        reg11_reg_wr_ack;

wire [31:0] reg12_data_in;
wire [1:0]  reg12_hl_sel;
wire        reg12_reg_wr;
wire        reg12_reg_clr;
wire [31:0] reg12_data_out;
wire        reg12_reg_wr_ack;

wire [31:0] reg13_data_in;
wire [1:0]  reg13_hl_sel;
wire        reg13_reg_wr;
wire        reg13_reg_clr;
wire [31:0] reg13_data_out;
wire        reg13_reg_wr_ack;

wire [31:0] reg14_data_in;
wire [1:0]  reg14_hl_sel;
wire        reg14_reg_wr;
wire        reg14_reg_clr;
wire [31:0] reg14_data_out;
wire        reg14_reg_wr_ack;

wire [31:0] reg15_data_in;
wire [1:0]  reg15_hl_sel;
wire        reg15_reg_wr;
wire        reg15_reg_clr;
wire [31:0] reg15_data_out;
wire        reg15_reg_wr_ack;

//Instantiation of the write request FSM
wr_req_fsm wr_fsm(

.clk(clk),
.rst_b(rst_b),
.wr_req(reg_wr),
.wr_out(wr_out)

);

// Instantiation of the program counter
program_counter#(

.PA_DATA(PA_DATA_WIDTH),
.PA_HL(PA_HL_SEL)

) pc(

.clk(clk),
.rst_b(rst_b),
.data_in(pc_data_in),
.hl_sel(pc_hl_sel),
.reg_wr(pc_reg_wr),
.reg_clr(pc_reg_clr),
.pc_incr(pc_incr),
.data_out(pc_data_out),
.reg_wr_ack(pc_reg_wr_ack)

);

// Instantiation of register 0
gp_reg#(

.PA_DATA(PA_DATA_WIDTH),
.PA_HL(PA_HL_SEL)

) reg0(

.clk(clk),
.rst_b(rst_b),
.data_in(reg0_data_in),
.hl_sel(reg0_hl_sel),
.reg_wr(reg0_reg_wr),
.reg_clr(reg0_reg_clr),
.data_out(reg0_data_out),
.reg_wr_ack(reg0_reg_wr_ack)

);

// Instantiation of register 1
gp_reg#(

.PA_DATA(PA_DATA_WIDTH),
.PA_HL(PA_HL_SEL)

) reg1(

.clk(clk),
.rst_b(rst_b),
.data_in(reg1_data_in),
.hl_sel(reg1_hl_sel),
.reg_wr(reg1_reg_wr),
.reg_clr(reg1_reg_clr),
.data_out(reg1_data_out),
.reg_wr_ack(reg1_reg_wr_ack)

);

// Instantiation of register 2
gp_reg#(

.PA_DATA(PA_DATA_WIDTH),
.PA_HL(PA_HL_SEL)

) reg2(

.clk(clk),
.rst_b(rst_b),
.data_in(reg2_data_in),
.hl_sel(reg2_hl_sel),
.reg_wr(reg2_reg_wr),
.reg_clr(reg2_reg_clr),
.data_out(reg2_data_out),
.reg_wr_ack(reg2_reg_wr_ack)

);

// Instantiation of register 3
gp_reg#(

.PA_DATA(PA_DATA_WIDTH),
.PA_HL(PA_HL_SEL)

) reg3(

.clk(clk),
.rst_b(rst_b),
.data_in(reg3_data_in),
.hl_sel(reg3_hl_sel),
.reg_wr(reg3_reg_wr),
.reg_clr(reg3_reg_clr),
.data_out(reg3_data_out),
.reg_wr_ack(reg3_reg_wr_ack)

);

// Instantiation of register 4
gp_reg#(

.PA_DATA(PA_DATA_WIDTH),
.PA_HL(PA_HL_SEL)

) reg4(

.clk(clk),
.rst_b(rst_b),
.data_in(reg4_data_in),
.hl_sel(reg4_hl_sel),
.reg_wr(reg4_reg_wr),
.reg_clr(reg4_reg_clr),
.data_out(reg4_data_out),
.reg_wr_ack(reg4_reg_wr_ack)

);

// Instantiation of register 5
gp_reg#(

.PA_DATA(PA_DATA_WIDTH),
.PA_HL(PA_HL_SEL)

) reg5(

.clk(clk),
.rst_b(rst_b),
.data_in(reg5_data_in),
.hl_sel(reg5_hl_sel),
.reg_wr(reg5_reg_wr),
.reg_clr(reg5_reg_clr),
.data_out(reg5_data_out),
.reg_wr_ack(reg5_reg_wr_ack)

);

// Instantiation of register 6
gp_reg#(

.PA_DATA(PA_DATA_WIDTH),
.PA_HL(PA_HL_SEL)

) reg6(

.clk(clk),
.rst_b(rst_b),
.data_in(reg6_data_in),
.hl_sel(reg6_hl_sel),
.reg_wr(reg6_reg_wr),
.reg_clr(reg6_reg_clr),
.data_out(reg6_data_out),
.reg_wr_ack(reg6_reg_wr_ack)

);

// Instantiation of register 7
gp_reg#(

.PA_DATA(PA_DATA_WIDTH),
.PA_HL(PA_HL_SEL)

) reg7(

.clk(clk),
.rst_b(rst_b),
.data_in(reg7_data_in),
.hl_sel(reg7_hl_sel),
.reg_wr(reg7_reg_wr),
.reg_clr(reg7_reg_clr),
.data_out(reg7_data_out),
.reg_wr_ack(reg7_reg_wr_ack)

);

// Instantiation of register 8
gp_reg#(

.PA_DATA(PA_DATA_WIDTH),
.PA_HL(PA_HL_SEL)

) reg8(

.clk(clk),
.rst_b(rst_b),
.data_in(reg8_data_in),
.hl_sel(reg8_hl_sel),
.reg_wr(reg8_reg_wr),
.reg_clr(reg8_reg_clr),
.data_out(reg8_data_out),
.reg_wr_ack(reg8_reg_wr_ack)

);

// Instantiation of register 9
gp_reg#(

.PA_DATA(PA_DATA_WIDTH),
.PA_HL(PA_HL_SEL)

) reg9(

.clk(clk),
.rst_b(rst_b),
.data_in(reg9_data_in),
.hl_sel(reg9_hl_sel),
.reg_wr(reg9_reg_wr),
.reg_clr(reg9_reg_clr),
.data_out(reg9_data_out),
.reg_wr_ack(reg9_reg_wr_ack)

);

// Instantiation of register 10
gp_reg#(

.PA_DATA(PA_DATA_WIDTH),
.PA_HL(PA_HL_SEL)

) reg10(

.clk(clk),
.rst_b(rst_b),
.data_in(reg10_data_in),
.hl_sel(reg10_hl_sel),
.reg_wr(reg10_reg_wr),
.reg_clr(reg10_reg_clr),
.data_out(reg10_data_out),
.reg_wr_ack(reg10_reg_wr_ack)

);

// Instantiation of register 11
gp_reg#(

.PA_DATA(PA_DATA_WIDTH),
.PA_HL(PA_HL_SEL)

) reg11(

.clk(clk),
.rst_b(rst_b),
.data_in(reg11_data_in),
.hl_sel(reg11_hl_sel),
.reg_wr(reg11_reg_wr),
.reg_clr(reg11_reg_clr),
.data_out(reg11_data_out),
.reg_wr_ack(reg11_reg_wr_ack)

);

// Instantiation of register 12
gp_reg#(

.PA_DATA(PA_DATA_WIDTH),
.PA_HL(PA_HL_SEL)

) reg12(

.clk(clk),
.rst_b(rst_b),
.data_in(reg12_data_in),
.hl_sel(reg12_hl_sel),
.reg_wr(reg12_reg_wr),
.reg_clr(reg12_reg_clr),
.data_out(reg12_data_out),
.reg_wr_ack(reg12_reg_wr_ack)

);

// Instantiation of register 13
gp_reg#(

.PA_DATA(PA_DATA_WIDTH),
.PA_HL(PA_HL_SEL)

) reg13(

.clk(clk),
.rst_b(rst_b),
.data_in(reg13_data_in),
.hl_sel(reg13_hl_sel),
.reg_wr(reg13_reg_wr),
.reg_clr(reg13_reg_clr),
.data_out(reg13_data_out),
.reg_wr_ack(reg13_reg_wr_ack)

);

// Instantiation of register 14
gp_reg#(

.PA_DATA(PA_DATA_WIDTH),
.PA_HL(PA_HL_SEL)

) reg14(

.clk(clk),
.rst_b(rst_b),
.data_in(reg14_data_in),
.hl_sel(reg14_hl_sel),
.reg_wr(reg14_reg_wr),
.reg_clr(reg14_reg_clr),
.data_out(reg14_data_out),
.reg_wr_ack(reg14_reg_wr_ack)

);

// Instantiation of register 15
gp_reg#(

.PA_DATA(PA_DATA_WIDTH),
.PA_HL(PA_HL_SEL)

) reg15(

.clk(clk),
.rst_b(rst_b),
.data_in(reg15_data_in),
.hl_sel(reg15_hl_sel),
.reg_wr(reg15_reg_wr),
.reg_clr(reg15_reg_clr),
.data_out(reg15_data_out),
.reg_wr_ack(reg15_reg_wr_ack)
);

// Instantiation of the input mux
ip_mux#(

.PA_IP(PA_IP_SEL),
.PA_HL(PA_HL_SEL),
.PA_DATA(PA_DATA_WIDTH),
.PA_IMME(PA_IMME_VAL)

) ip_mux(

.clk(clk),
.rst_b(rst_b),
.ip_sel(ip_sel),
.hl_sel(hl_sel),
.rtr_out(rtr_out),
.alu_out(alu_out),
.dib(dib),
.id_imme(id_imme),
.mux_out(ipsel_ipreg)

);

// Instantiation of register select demux
gen_1_17_demux#(

.PA_DATA(PA_DATA_WIDTH),
.PA_SEL(PA_IP_REG)

) reg_sel(

.clk(clk),
.rst_b(rst_b),
.mux_in(ipsel_ipreg),
.sel(ip_reg_sel),
.reg0(reg0_data_in),
.reg1(reg1_data_in),
.reg2(reg2_data_in),
.reg3(reg3_data_in),
.reg4(reg4_data_in),
.reg5(reg5_data_in),
.reg6(reg6_data_in),
.reg7(reg7_data_in),
.reg8(reg8_data_in),
.reg9(reg9_data_in),
.reg10(reg10_data_in),
.reg11(reg11_data_in),
.reg12(reg12_data_in),
.reg13(reg13_data_in),
.reg14(reg14_data_in),
.reg15(reg15_data_in),
.pc(pc_data_in)

);

// Instantiation of upper/lower select demux
gen_1_17_demux#(

.PA_DATA(PA_HL_SEL),
.PA_SEL(PA_IP_REG)

) hl_sel_demux(

.clk(clk),
.rst_b(rst_b),
.mux_in(hl_sel),
.sel(ip_reg_sel),
.reg0(reg0_hl_sel),
.reg1(reg1_hl_sel),
.reg2(reg2_hl_sel),
.reg3(reg3_hl_sel),
.reg4(reg4_hl_sel),
.reg5(reg5_hl_sel),
.reg6(reg6_hl_sel),
.reg7(reg7_hl_sel),
.reg8(reg8_hl_sel),
.reg9(reg9_hl_sel),
.reg10(reg10_hl_sel),
.reg11(reg11_hl_sel),
.reg12(reg12_hl_sel),
.reg13(reg13_hl_sel),
.reg14(reg14_hl_sel),
.reg15(reg15_hl_sel),
.pc(pc_hl_sel)

);

// Instantiation of write select demux
gen_1_17_demux#(

.PA_DATA(1),
.PA_SEL(PA_IP_REG)

) wr_sel(

.clk(clk),
.rst_b(rst_b),
.mux_in(wr_out),
.sel(ip_reg_sel),
.reg0(reg0_reg_wr),
.reg1(reg1_reg_wr),
.reg2(reg2_reg_wr),
.reg3(reg3_reg_wr),
.reg4(reg4_reg_wr),
.reg5(reg5_reg_wr),
.reg6(reg6_reg_wr),
.reg7(reg7_reg_wr),
.reg8(reg8_reg_wr),
.reg9(reg9_reg_wr),
.reg10(reg10_reg_wr),
.reg11(reg11_reg_wr),
.reg12(reg12_reg_wr),
.reg13(reg13_reg_wr),
.reg14(reg14_reg_wr),
.reg15(reg15_reg_wr),
.pc(pc_reg_wr)

);

// Instantiation of clear select demux
gen_1_17_demux#(

.PA_DATA(1),
.PA_SEL(PA_IP_REG)

) clr_sel(

.clk(clk),
.rst_b(rst_b),
.mux_in(reg_clr),
.sel(reg_clr_sel),
.reg0(reg0_reg_clr),
.reg1(reg1_reg_clr),
.reg2(reg2_reg_clr),
.reg3(reg3_reg_clr),
.reg4(reg4_reg_clr),
.reg5(reg5_reg_clr),
.reg6(reg6_reg_clr),
.reg7(reg7_reg_clr),
.reg8(reg8_reg_clr),
.reg9(reg9_reg_clr),
.reg10(reg10_reg_clr),
.reg11(reg11_reg_clr),
.reg12(reg12_reg_clr),
.reg13(reg13_reg_clr),
.reg14(reg14_reg_clr),
.reg15(reg15_reg_clr),
.pc(pc_reg_clr)

);

// Instantiation of ALU input A select mux
gen_17_1_mux#(

.PA_DATA(PA_DATA_WIDTH),
.PA_SEL(PA_IP_REG)

) alu_a_sel_mux(

.clk(clk),
.rst_b(rst_b),
.sel(alu_a_sel),
.reg0(reg0_data_out),
.reg1(reg1_data_out),
.reg2(reg2_data_out),
.reg3(reg3_data_out),
.reg4(reg4_data_out),
.reg5(reg5_data_out),
.reg6(reg6_data_out),
.reg7(reg7_data_out),
.reg8(reg8_data_out),
.reg9(reg9_data_out),
.reg10(reg10_data_out),
.reg11(reg11_data_out),
.reg12(reg12_data_out),
.reg13(reg13_data_out),
.reg14(reg14_data_out),
.reg15(reg15_data_out),
.pc(pc_data_out),
.mux_out(alu_a)

);

// Instantiation of ALU input B select mux
gen_17_1_mux#(

.PA_DATA(PA_DATA_WIDTH),
.PA_SEL(PA_IP_REG)

) alu_b_sel_mux(

.clk(clk),
.rst_b(rst_b),
.sel(alu_b_sel),
.reg0(reg0_data_out),
.reg1(reg1_data_out),
.reg2(reg2_data_out),
.reg3(reg3_data_out),
.reg4(reg4_data_out),
.reg5(reg5_data_out),
.reg6(reg6_data_out),
.reg7(reg7_data_out),
.reg8(reg8_data_out),
.reg9(reg9_data_out),
.reg10(reg10_data_out),
.reg11(reg11_data_out),
.reg12(reg12_data_out),
.reg13(reg13_data_out),
.reg14(reg14_data_out),
.reg15(reg15_data_out),
.pc(pc_data_out),
.mux_out(alu_b)

);

// Instantiation of address select mux
gen_17_1_mux#(

.PA_DATA(PA_DATA_WIDTH),
.PA_SEL(PA_IP_REG)

) addr_sel_mux(

.clk(clk),
.rst_b(rst_b),
.sel(addr_sel),
.reg0(reg0_data_out),
.reg1(reg1_data_out),
.reg2(reg2_data_out),
.reg3(reg3_data_out),
.reg4(reg4_data_out),
.reg5(reg5_data_out),
.reg6(reg6_data_out),
.reg7(reg7_data_out),
.reg8(reg8_data_out),
.reg9(reg9_data_out),
.reg10(reg10_data_out),
.reg11(reg11_data_out),
.reg12(reg12_data_out),
.reg13(reg13_data_out),
.reg14(reg14_data_out),
.reg15(reg15_data_out),
.pc(pc_data_out),
.mux_out(addr_out)

);

// Instantiation of data out bus select mux
gen_17_1_mux#(

.PA_DATA(PA_DATA_WIDTH),
.PA_SEL(PA_IP_REG)

) dob_sel_mux(

.clk(clk),
.rst_b(rst_b),
.sel(dob_sel),
.reg0(reg0_data_out),
.reg1(reg1_data_out),
.reg2(reg2_data_out),
.reg3(reg3_data_out),
.reg4(reg4_data_out),
.reg5(reg5_data_out),
.reg6(reg6_data_out),
.reg7(reg7_data_out),
.reg8(reg8_data_out),
.reg9(reg9_data_out),
.reg10(reg10_data_out),
.reg11(reg11_data_out),
.reg12(reg12_data_out),
.reg13(reg13_data_out),
.reg14(reg14_data_out),
.reg15(reg15_data_out),
.pc(pc_data_out),
.mux_out(dob)

);

// Instantiation of register to register select mux
gen_17_1_mux#(

.PA_DATA(PA_DATA_WIDTH),
.PA_SEL(PA_IP_REG)

) rtr_sel_mux(

.clk(clk),
.rst_b(rst_b),
.sel(rtr_sel),
.reg0(reg0_data_out),
.reg1(reg1_data_out),
.reg2(reg2_data_out),
.reg3(reg3_data_out),
.reg4(reg4_data_out),
.reg5(reg5_data_out),
.reg6(reg6_data_out),
.reg7(reg7_data_out),
.reg8(reg8_data_out),
.reg9(reg9_data_out),
.reg10(reg10_data_out),
.reg11(reg11_data_out),
.reg12(reg12_data_out),
.reg13(reg13_data_out),
.reg14(reg14_data_out),
.reg15(reg15_data_out),
.pc(pc_data_out),
.mux_out(rtr_out)

);

// Instantiation of acknowledge select mux
gen_17_1_mux#(

.PA_DATA(1),
.PA_SEL(PA_IP_REG)

) ack_sel(

.clk(clk),
.rst_b(rst_b),
.sel(ip_reg_sel),
.reg0(reg0_reg_wr_ack),
.reg1(reg1_reg_wr_ack),
.reg2(reg2_reg_wr_ack),
.reg3(reg3_reg_wr_ack),
.reg4(reg4_reg_wr_ack),
.reg5(reg5_reg_wr_ack),
.reg6(reg6_reg_wr_ack),
.reg7(reg7_reg_wr_ack),
.reg8(reg8_reg_wr_ack),
.reg9(reg9_reg_wr_ack),
.reg10(reg10_reg_wr_ack),
.reg11(reg11_reg_wr_ack),
.reg12(reg12_reg_wr_ack),
.reg13(reg13_reg_wr_ack),
.reg14(reg14_reg_wr_ack),
.reg15(reg15_reg_wr_ack),
.pc(pc_reg_wr_ack),
.mux_out(reg_wr_ack)

);

endmodule
