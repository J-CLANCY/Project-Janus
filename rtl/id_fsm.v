`define BINARY

module id_fsm#(

parameter PA_INST = 32'd32,
parameter PA_IMME = 32'd16,
parameter PA_FNCT = 32'd9,
parameter PA_ALU = 32'd9,
parameter PA_ADDR = 32'd9,
parameter PA_DOB = 32'd9,
parameter PA_RTR = 32'd9,
parameter PA_HL = 32'd2,
parameter PA_IP = 32'd3,
parameter PA_IP_REG = 32'd9

)(

input wire                  clk,
input wire                  rst_b,
input wire [PA_INST-1:0]    instr,
input wire                  cf,
input wire                  nf,
input wire                  zf,
input wire                  vf,
input wire                  alu_ack,
input wire                  reg_wr_ack,
input wire                  mar_wr_ack,
input wire                  ram_wr_ack,
input wire                  ram_oe_ack,
input wire                  ir_wr_ack,
input wire                  dib_ack,
output reg                  ir_wr,
output reg                  alu_req,
output reg [PA_IMME-1:0]    imme_out,
output reg [PA_FNCT-1:0]    alu_fnct_sel,
output reg [PA_ALU-1:0]     alu_a_sel,
output reg [PA_ALU-1:0]     alu_b_sel,
output reg [PA_ADDR-1:0]    addr_sel,
output reg [PA_DOB-1:0]     dob_sel,
output reg [PA_RTR-1:0]     rtr_sel,
output reg [PA_HL-1:0]      hl_sel,
output reg [PA_IP-1:0]      rb_ip_sel,
output reg [PA_IP_REG-1:0]  rb_ip_reg_sel,
output reg [PA_IP_REG-1:0]  rb_reg_clr_sel,
output reg                  dib_sel,
output reg                  reg_wr,
output reg                  reg_clr,
output reg                  pc_incr,
output reg                  mar_wr,
output reg                  ram_wr,
output reg                  ram_oe,
output reg                  halt

);

// This ifdef let's us switch between BINARY and ONE_HOT encoding
`ifdef BINARY
  
  reg [5:0] cs;
  reg [5:0] ns;
  reg [5:0] ci;
  reg [5:0] cmb_ci;

  parameter FSM_ID_FETCH       = 6'd0;
  parameter FSM_ID_WAIT_ADDR   = 6'd1;
  parameter FSM_ID_WAIT_MAR    = 6'd2;
  parameter FSM_ID_WAIT_RAM_OE = 6'd3;
  parameter FSM_ID_DIB_WAIT    = 6'd4;
  parameter FSM_ID_IR_WAIT     = 6'd5;
  parameter FSM_ID_JMP_MISC    = 6'd6;
  parameter FSM_ID_ARITH       = 6'd7;
  parameter FSM_ID_LOGIC       = 6'd8;
  parameter FSM_ID_MEM_MAN     = 6'd9;
  parameter FSM_ID_NOP         = 6'd10;
  parameter FSM_ID_JMP         = 6'd11;
  parameter FSM_ID_JEZ         = 6'd12;
  parameter FSM_ID_JGZ         = 6'd13;
  parameter FSM_ID_JLZ         = 6'd14;
  parameter FSM_ID_HLT         = 6'd15;
  parameter FSM_ID_ADD         = 6'd16;
  parameter FSM_ID_SUB         = 6'd17;
  parameter FSM_ID_AND         = 6'd18;
  parameter FSM_ID_OR          = 6'd19;
  parameter FSM_ID_XOR         = 6'd20;
  parameter FSM_ID_SFL         = 6'd21;
  parameter FSM_ID_SFR         = 6'd22;
  parameter FSM_ID_LD          = 6'd23;
  parameter FSM_ID_ST          = 6'd24;
  parameter FSM_ID_MOV         = 6'd25;
  parameter FSM_ID_MVL         = 6'd26;
  parameter FSM_ID_MVH         = 6'd27;
  parameter FSM_ID_CLR         = 6'd28;
  parameter FSM_ID_ALU_SEL     = 6'd29;
  parameter FSM_ID_ADDR_SEL    = 6'd30;
  parameter FSM_ID_DOB_SEL     = 6'd31;
  parameter FSM_ID_REG_WAIT    = 6'd32;
  parameter FSM_ID_ALU_WAIT    = 6'd33;
  parameter FSM_ID_MAR_WAIT    = 6'd34;
  parameter FSM_ID_RAM_OE_WAIT = 6'd35;
  parameter FSM_ID_RAM_WR_WAIT = 6'd36;
  parameter FSM_ID_PC_PLUS     = 6'd37;
  parameter FSM_ID_PC_WAIT     = 6'd38;
  
 
`else 
  `ifdef ONE_HOT

    reg [38:0] cs;
    reg [38:0] ns;
    reg [38:0] ci;
    reg [38:0] cmb_ci;

    parameter FSM_ID_FETCH       = 39'd1;
    parameter FSM_ID_WAIT_ADDR   = 39'd2;
    parameter FSM_ID_WAIT_MAR    = 39'd4;
    parameter FSM_ID_WAIT_RAM_OE = 39'd8;
    parameter FSM_ID_DIB_WAIT    = 39'd16;
    parameter FSM_ID_IR_WAIT     = 39'd32;
    parameter FSM_ID_JMP_MISC    = 39'd64;
    parameter FSM_ID_ARITH       = 39'd128;
    parameter FSM_ID_LOGIC       = 39'd256; 
    parameter FSM_ID_MEM_MAN     = 39'd512;
    parameter FSM_ID_NOP         = 39'd1024;
    parameter FSM_ID_JMP         = 39'd2048;
    parameter FSM_ID_JEZ         = 39'd4096;
    parameter FSM_ID_JGZ         = 39'd8192;
    parameter FSM_ID_JLZ         = 39'd16384;
    parameter FSM_ID_HLT         = 39'd32768;
    parameter FSM_ID_ADD         = 39'd65536;
    parameter FSM_ID_SUB         = 39'd131072;
    parameter FSM_ID_AND         = 39'd262144;
    parameter FSM_ID_OR          = 39'd524288;
    parameter FSM_ID_XOR         = 39'd1048576;
    parameter FSM_ID_SFL         = 39'd2097152;
    parameter FSM_ID_SFR         = 39'd4194304;
    parameter FSM_ID_LD          = 39'd8388608;
    parameter FSM_ID_ST          = 39'd16777216;
    parameter FSM_ID_MOV         = 39'd33554432;
    parameter FSM_ID_MVL         = 39'd67108864;
    parameter FSM_ID_MVH         = 39'd134217728;
    parameter FSM_ID_CLR         = 39'd268435456;
    parameter FSM_ID_ALU_SEL     = 39'd536870912;
    parameter FSM_ID_ADDR_SEL    = 39'd1073741824;
    parameter FSM_ID_DOB_SEL     = 39'd2147483648;
    parameter FSM_ID_REG_WAIT    = 39'd4294967296;
    parameter FSM_ID_ALU_WAIT    = 39'd8589934592;
    parameter FSM_ID_MAR_WAIT    = 39'd17179869184;
    parameter FSM_ID_RAM_OE_WAIT = 39'd34359738368;
    parameter FSM_ID_RAM_WR_WAIT = 39'd68719476736;
    parameter FSM_ID_PC_PLUS     = 39'd137438953472;
    parameter FSM_ID_PC_WAIT     = 39'd274877906944;
  `endif
`endif

// Instantiation of some variables to ease the 
// implementation of the FSM

parameter        PC = 9'h0FF;

parameter        PA_ID = 1'b0;
parameter        PA_RB = 1'b1;

parameter        def = 2'b00;
parameter        low = 2'b01;
parameter        high = 2'b10;

parameter        rtr = 3'b001;
parameter        alu = 3'b010;
parameter        dib = 3'b011;
parameter        id_imme = 3'b100;

parameter        Add = 9'b001000000;
parameter        Sub = 9'b001000001;
parameter        And_state = 9'b010000000;
parameter        Or_state = 9'b010000001;
parameter        Xor_state = 9'b010000010;
parameter        Sfl = 9'b010000011;
parameter        Sfr = 9'b010000100;
parameter        Chk = 9'b000000000;

reg      [5:0]  id;
reg      [7:0]  reg1;
reg      [7:0]  reg2;
reg      [7:0]  reg3;

reg        cmb_ir_wr;
reg        cmb_alu_req;
reg [8:0]  cmb_alu_fnct_sel;
reg [8:0]  cmb_alu_a_sel;
reg [8:0]  cmb_alu_b_sel;
reg [8:0]  cmb_addr_sel;
reg [8:0]  cmb_dob_sel;
reg [8:0]  cmb_rtr_sel;
reg [1:0]  cmb_hl_sel;
reg [2:0]  cmb_rb_ip_sel;
reg [8:0]  cmb_rb_ip_reg_sel;
reg [8:0]  cmb_rb_reg_clr_sel;
reg        cmb_dib_sel;
reg        cmb_reg_wr;
reg        cmb_reg_clr;
reg        cmb_pc_incr;
reg        cmb_mar_wr;
reg        cmb_ram_wr;
reg        cmb_ram_oe;
reg        cmb_halt;

wire [15:0] cmb_imme_out;

wire     [7:0]  cmb_id;
wire     [7:0]  cmb_reg1;
wire     [7:0]  cmb_reg2;
wire     [7:0]  cmb_reg3;

assign cmb_id = instr[31:24];
assign cmb_reg1 = instr[23:16];
assign cmb_reg2 = instr[15:8];
assign cmb_reg3 = instr[7:0];
assign cmb_imme_out = instr[15:0];


// This is the state reg of the FSM
always @ (posedge clk or negedge rst_b)
begin: state_reg
  if(rst_b == 1'b0) begin // Reset
    cs <= FSM_ID_FETCH;
    ci <= 0;
    id <= 8'd0;
    reg1 <= 8'd0;
    reg2 <= 8'd0;
    reg3 <= 8'd0;
    ir_wr <= 1'b0;
    alu_req <= 1'b0;
    imme_out <= 16'd0;
    alu_fnct_sel <= 9'd0;
    alu_a_sel <= 9'd0;
    alu_b_sel <= 9'd0;
    addr_sel <= 9'd0;
    dob_sel <= 9'd0;
    rtr_sel <= 9'd0;
    hl_sel <= 2'd0;
    rb_ip_sel <= 3'd0;
    rb_ip_reg_sel <= 9'd0;
    rb_reg_clr_sel <= 9'd0;
    dib_sel <= 1'b0;
    reg_wr <= 1'b0;
    reg_clr <= 1'b0;
    pc_incr <= 1'b0;
    mar_wr <= 1'b0;
    ram_wr <= 1'b0;
    ram_oe <= 1'b0;
    halt  <= 1'b0;
  end
  else if(clk) begin
    cs <= ns;
    ci <= cmb_ci;
    id <= cmb_id[5:0];
    reg1 <= cmb_reg1;
    reg2 <= cmb_reg2;
    reg3 <= cmb_reg3;
    ir_wr <= cmb_ir_wr;
    alu_req <= cmb_alu_req;
    imme_out <= cmb_imme_out;
    alu_fnct_sel <= cmb_alu_fnct_sel;
    alu_a_sel <= cmb_alu_a_sel;
    alu_b_sel <= cmb_alu_b_sel;
    addr_sel <= cmb_addr_sel;
    dob_sel <= cmb_dob_sel;
    rtr_sel <= cmb_rtr_sel;
    hl_sel <= cmb_hl_sel;
    rb_ip_sel <= cmb_rb_ip_sel;
    rb_ip_reg_sel <= cmb_rb_ip_reg_sel;
    rb_reg_clr_sel <= cmb_rb_reg_clr_sel;
    dib_sel <= cmb_dib_sel;
    reg_wr <= cmb_reg_wr;
    reg_clr <= cmb_reg_clr;
    pc_incr <= cmb_pc_incr;
    mar_wr <= cmb_mar_wr;
    ram_wr <= cmb_ram_wr;
    ram_oe <= cmb_ram_oe;
    halt  <= cmb_halt;
  end
end

// This is the next state and output decode of the FSM
always @ (*)
begin : ns_op_decode

  //Defaults
  ns = cs;
  cmb_alu_fnct_sel = alu_fnct_sel;
  cmb_alu_a_sel = alu_a_sel;
  cmb_alu_b_sel = alu_b_sel;
  cmb_addr_sel = addr_sel;
  cmb_dob_sel = dob_sel;
  cmb_rtr_sel = rtr_sel;
  cmb_hl_sel = hl_sel;
  cmb_rb_ip_sel = rb_ip_sel;
  cmb_rb_ip_reg_sel = rb_ip_reg_sel;
  cmb_rb_reg_clr_sel = rb_reg_clr_sel;
  cmb_ci = ci;
  cmb_ir_wr = 1'b0;
  cmb_alu_req = 1'b0;
  cmb_dib_sel = dib_sel;
  cmb_reg_wr = 1'b0;
  cmb_reg_clr = 1'b0;
  cmb_pc_incr = 1'b0;
  cmb_mar_wr = 1'b0;
  cmb_ram_wr = 1'b0;
  cmb_ram_oe = 1'b0;
  cmb_halt = 1'b0;

  // The main case statement
  case(cs)
   
    // The first 6 states are the fetch phase of the FSM
    FSM_ID_FETCH:
    begin
      cmb_addr_sel = PC;
      cmb_dib_sel = PA_ID;
      ns = FSM_ID_WAIT_ADDR;
    end

    FSM_ID_WAIT_ADDR:
    begin
      cmb_mar_wr = 1'b1;
      ns = FSM_ID_WAIT_MAR;
    end

    FSM_ID_WAIT_MAR:
    begin
      if (mar_wr_ack) begin
        cmb_ram_oe = 1'b1;
        ns = FSM_ID_WAIT_RAM_OE;
      end
    end

    FSM_ID_WAIT_RAM_OE:
    begin
      if(ram_oe_ack) begin
        ns = FSM_ID_DIB_WAIT;
      end
    end
    
    FSM_ID_DIB_WAIT:
    begin
      if(dib_ack)begin
        cmb_ir_wr = 1'b1;
        ns = FSM_ID_IR_WAIT;
      end
    end

    FSM_ID_IR_WAIT:
    begin
      if(ir_wr_ack)begin
        case(cmb_id[7:6])
          2'b00: ns = FSM_ID_JMP_MISC;
          2'b01: ns = FSM_ID_ARITH;
          2'b10: ns = FSM_ID_LOGIC;
          2'b11: ns = FSM_ID_MEM_MAN;
        endcase
      end
    end 

    // These next four states are the branches for
    // each type of instruction
    FSM_ID_JMP_MISC:
    begin
      case(id[5:0])
        6'b000000:
        begin
          cmb_ci = FSM_ID_NOP;
          ns = FSM_ID_NOP;
        end
        6'b000001:
        begin
          cmb_ci = FSM_ID_JMP;
          ns = FSM_ID_JMP;
        end
        6'b000010:
        begin
          cmb_ci = FSM_ID_JEZ;
          ns = FSM_ID_JEZ;
        end
        6'b000011:
        begin
          cmb_ci = FSM_ID_JGZ;
          ns = FSM_ID_JGZ;
        end
        6'b000100:
        begin
          cmb_ci = FSM_ID_JLZ;
          ns = FSM_ID_JLZ;
        end
        6'b000101:
        begin
          cmb_ci = FSM_ID_HLT;
          ns = FSM_ID_HLT;
        end
        default: 
        begin
          cmb_ci = FSM_ID_NOP;
          ns = FSM_ID_NOP;
        end
      endcase
    end

    FSM_ID_ARITH:
    begin
      case(id[5:0])
        6'b000000:
        begin
          cmb_ci = FSM_ID_ADD;
          ns = FSM_ID_ADD;
        end
        6'b000001:
        begin
          cmb_ci = FSM_ID_SUB;
          ns = FSM_ID_SUB;
        end
        default: 
        begin
          cmb_ci = FSM_ID_NOP;
          ns = FSM_ID_NOP;
        end
      endcase
    end

    FSM_ID_LOGIC:
    begin
      case(id[5:0])
        6'b000000:
        begin
          cmb_ci = FSM_ID_AND;
          ns = FSM_ID_AND;
        end
        6'b000001:
        begin
          cmb_ci = FSM_ID_OR;
          ns = FSM_ID_OR;
        end
        6'b000010:
        begin
          cmb_ci = FSM_ID_XOR;
          ns = FSM_ID_XOR;
        end
        6'b000011:
        begin
          cmb_ci = FSM_ID_SFL;
          ns = FSM_ID_SFL;
        end
        6'b000100:
        begin
          cmb_ci = FSM_ID_SFR;
          ns = FSM_ID_SFR;
        end
        default: 
        begin
          cmb_ci = FSM_ID_NOP;
          ns = FSM_ID_NOP;
        end
      endcase
    end

    FSM_ID_MEM_MAN:
    begin
      case(id[5:0])
        6'b000000:
        begin
          cmb_ci = FSM_ID_LD;
          ns = FSM_ID_LD;
        end
        6'b000001:
        begin
          cmb_ci = FSM_ID_ST;
          ns = FSM_ID_ST;
        end
        6'b000010:
        begin
          cmb_ci = FSM_ID_MOV;
          ns = FSM_ID_MOV;
        end
        6'b000011:
        begin
          cmb_ci = FSM_ID_MVL;
          ns = FSM_ID_MVL;
        end
        6'b000100:
        begin
          cmb_ci = FSM_ID_MVH;
          ns = FSM_ID_MVH;
        end
        6'b000101:
        begin
          cmb_ci = FSM_ID_CLR;
          ns = FSM_ID_CLR;
        end
        default: 
        begin
          cmb_ci = FSM_ID_NOP;
          ns = FSM_ID_NOP;
        end
      endcase
    end
    
    // These next six states are jump and misc instructions
    FSM_ID_NOP: ns = FSM_ID_PC_PLUS;

    FSM_ID_JMP:
    begin
      cmb_rtr_sel = {1'b0,reg1};
      cmb_rb_ip_sel = rtr;
      cmb_hl_sel = def;
      cmb_rb_ip_reg_sel = PC;
      cmb_reg_wr = 1'b1;
      ns = FSM_ID_REG_WAIT;
    end

    FSM_ID_JEZ:
    begin
      cmb_alu_a_sel = {1'b0,reg1};
      cmb_alu_fnct_sel = Chk;
      ns = FSM_ID_ALU_SEL;
    end

    FSM_ID_JGZ:
    begin
      cmb_alu_a_sel = {1'b0,reg1};
      cmb_alu_fnct_sel = Chk;
      ns = FSM_ID_ALU_SEL;
    end

    FSM_ID_JLZ:
    begin
      cmb_alu_a_sel = {1'b0,reg1};
      cmb_alu_fnct_sel = Chk;
      ns = FSM_ID_ALU_SEL;
    end

    FSM_ID_HLT: cmb_halt = 1'b1;

    // These next two are the arithmetic instructions
    FSM_ID_ADD:
    begin
      cmb_alu_a_sel = {1'b0,reg1};
      cmb_alu_b_sel = {1'b0,reg2};
      cmb_alu_fnct_sel = Add;
      ns = FSM_ID_ALU_SEL;
    end

    FSM_ID_SUB:
    begin
      cmb_alu_a_sel = {1'b0,reg1};
      cmb_alu_b_sel = {1'b0,reg2};
      cmb_alu_fnct_sel = Sub;
      ns = FSM_ID_ALU_SEL;
    end
 
    // These next five are the logic instructions
    FSM_ID_AND:
    begin
      cmb_alu_a_sel = {1'b0,reg1};
      cmb_alu_b_sel = {1'b0,reg2};
      cmb_alu_fnct_sel = And_state;
      ns = FSM_ID_ALU_SEL;
    end

    FSM_ID_OR:
    begin
      cmb_alu_a_sel = {1'b0,reg1};
      cmb_alu_b_sel = {1'b0,reg2};
      cmb_alu_fnct_sel = Or_state;
      ns = FSM_ID_ALU_SEL;
    end

    FSM_ID_XOR:
    begin
      cmb_alu_a_sel = {1'b0,reg1};
      cmb_alu_b_sel = {1'b0,reg2};
      cmb_alu_fnct_sel = Xor_state;
      ns = FSM_ID_ALU_SEL;
    end

    FSM_ID_SFL:
    begin
      cmb_alu_a_sel = {1'b0,reg1};
      cmb_alu_fnct_sel = Sfl;
      ns = FSM_ID_ALU_SEL;
    end

    FSM_ID_SFR:
    begin
      cmb_alu_a_sel = {1'b0,reg1};
      cmb_alu_fnct_sel = Sfr;
      ns = FSM_ID_ALU_SEL;
    end

    // These last six are the memory management instructions
    FSM_ID_LD:
    begin
      cmb_addr_sel = {1'b0,reg2};
      cmb_dib_sel = PA_RB; 
      ns = FSM_ID_ADDR_SEL;
    end

    FSM_ID_ST:
    begin
      cmb_addr_sel = {1'b0,reg2};
      ns = FSM_ID_ADDR_SEL;
    end

    FSM_ID_MOV:
    begin
      cmb_rtr_sel = {1'b0,reg2};
      cmb_rb_ip_sel = rtr;
      cmb_rb_ip_reg_sel = {1'b0,reg1};
      cmb_hl_sel = def;
      cmb_reg_wr = 1'b1;
      ns = FSM_ID_REG_WAIT;
    end

    FSM_ID_MVL:
    begin
      cmb_rb_ip_sel = id_imme;
      cmb_hl_sel = low;
      cmb_rb_ip_reg_sel = {1'b0,reg1};
      cmb_reg_wr = 1'b1;
      ns = FSM_ID_REG_WAIT;
    end

    FSM_ID_MVH:
    begin
      cmb_rb_ip_sel = id_imme;
      cmb_hl_sel = high;
      cmb_rb_ip_reg_sel = {1'b0,reg1};
      cmb_reg_wr = 1'b1;
      ns = FSM_ID_REG_WAIT;
    end

    FSM_ID_CLR:
    begin
      cmb_rb_reg_clr_sel = {1'b0,reg1};
      cmb_reg_clr = 1'b1;
      ns = FSM_ID_PC_PLUS;
    end
   
    // These are all of the misc. states that are necessary
    // selecting the outputs of the RB
    FSM_ID_ALU_SEL:
    begin
      cmb_alu_req = 1'b1;
      ns = FSM_ID_ALU_WAIT;
    end

    FSM_ID_ADDR_SEL:
    begin
      cmb_mar_wr = 1'b1;
      ns = FSM_ID_MAR_WAIT;
    end

    FSM_ID_DOB_SEL:
    begin
      cmb_ram_wr = 1'b1;
      ns = FSM_ID_RAM_WR_WAIT;
    end

    // This is the state where the instruction
    // decoder waits for the register to write
    FSM_ID_REG_WAIT:
    begin
      if((ci == FSM_ID_JMP) || 
         (ci == FSM_ID_JEZ) || 
         (ci == FSM_ID_JGZ) || 
         (ci == FSM_ID_JLZ)) begin
        if (reg_wr_ack)begin
          ns = FSM_ID_FETCH;
        end
      end
      else begin
        if(reg_wr_ack) begin
          ns = FSM_ID_PC_PLUS;
        end
      end
    end

    // This is the state where the instruction
    // decoder waits for the ALU to finish
    FSM_ID_ALU_WAIT:
    begin
      if(ci == FSM_ID_JEZ) begin
        if(alu_ack) begin
          if(zf) begin
            cmb_rtr_sel = {1'b0,reg2};
            cmb_rb_ip_sel = rtr;
            cmb_rb_ip_reg_sel = PC;
            cmb_hl_sel = def;
            cmb_reg_wr = 1'b1;
            ns = FSM_ID_REG_WAIT;
          end
          else begin
            ns = FSM_ID_PC_PLUS;
          end
        end
      end
      else if(ci == FSM_ID_JGZ) begin
        if(alu_ack) begin
          if(!zf && !nf) begin
            cmb_rtr_sel = {1'b0,reg2};
            cmb_rb_ip_sel = rtr;
            cmb_rb_ip_reg_sel = PC;
            cmb_hl_sel = def;
            cmb_reg_wr = 1'b1;
            ns = FSM_ID_REG_WAIT;
          end
          else begin
            ns = FSM_ID_PC_PLUS;
          end
        end
      end 
      else if(ci == FSM_ID_JLZ) begin
        if(alu_ack) begin
          if(nf) begin
            cmb_rtr_sel = {1'b0,reg2};
            cmb_rb_ip_sel = rtr;
            cmb_rb_ip_reg_sel = PC;
            cmb_hl_sel = def;
            cmb_reg_wr = 1'b1;
            ns = FSM_ID_REG_WAIT;
          end
          else begin
            ns = FSM_ID_PC_PLUS;
          end
        end
      end
      else if ((ci == FSM_ID_ADD) ||
               (ci == FSM_ID_SUB) ||
               (ci == FSM_ID_AND) ||
               (ci == FSM_ID_OR) ||
               (ci == FSM_ID_XOR)) begin
        if(alu_ack) begin
          cmb_rb_ip_sel = alu;
          cmb_rb_ip_reg_sel = {1'b0,reg3};
          cmb_hl_sel = def;
          cmb_reg_wr = 1'b1;
          ns = FSM_ID_REG_WAIT;
        end
      end
      else if (ci == FSM_ID_SFL || ci == FSM_ID_SFR) begin
        if(alu_ack) begin
          cmb_rb_ip_sel = alu;
          cmb_rb_ip_reg_sel = {1'b0,reg1};
          cmb_hl_sel = def;
          cmb_reg_wr = 1'b1;
          ns = FSM_ID_REG_WAIT;
        end
      end
    end

    // This is the state where the instruction
    // decoder waits for the MAR to write
    FSM_ID_MAR_WAIT:
    begin
      case(ci)
        FSM_ID_LD:
        begin
          if(mar_wr_ack) begin
            cmb_ram_oe = 1'b1;
            ns = FSM_ID_RAM_OE_WAIT;
          end  
        end
  
        FSM_ID_ST:
        begin
          if(mar_wr_ack) begin
            cmb_dob_sel = {1'b0,reg1};
            ns = FSM_ID_DOB_SEL;
          end
        end
      default: ns = FSM_ID_HLT;
      endcase
    end

    // This is the state where the instruction
    // decoder waits for the RAM to output
    FSM_ID_RAM_OE_WAIT:
    begin
      if(ram_oe_ack) begin
        cmb_rb_ip_sel = dib;
        cmb_rb_ip_reg_sel = {1'b0,reg1};
        cmb_hl_sel = def;
        cmb_reg_wr = 1'b1;
        ns = FSM_ID_REG_WAIT;
      end
    end

    // This is the state where the instruction
    // decoder waits for the RAM to write
    FSM_ID_RAM_WR_WAIT:
    begin
      if(ram_wr_ack) begin
        ns = FSM_ID_PC_PLUS;
      end
    end

    // This is the state that increments the
    // program counter and resets the FSM
    FSM_ID_PC_PLUS:
    begin
      cmb_pc_incr = 1'b1;
      cmb_rb_ip_reg_sel = PC;
      ns = FSM_ID_PC_WAIT;
    end
     
    FSM_ID_PC_WAIT:
    begin
      if(reg_wr_ack) begin
        ns = FSM_ID_FETCH;
      end
    end
    default: ns = FSM_ID_HLT;
  endcase  
end

endmodule
