`define BINARY

module id_fsm(

input wire        clk,
input wire        rst_b,
input wire [31:0] instr,
input wire        cf,
input wire        nf,
input wire        zf,
input wire        vf,
input wire        alu_ack,
input wire        reg_wr_ack,
input wire        mar_wr_ack,
input wire        ram_wr_ack,
input wire        ram_oe_ack,
input wire        ir_wr_ack,
input wire        dib_ack,
output reg        ir_wr,
output reg [15:0] imme_out,
output reg [8:0]  alu_fnct_sel,
output reg [8:0]  alu_a_sel,
output reg [8:0]  alu_b_sel,
output reg [8:0]  addr_sel,
output reg [8:0]  dob_sel,
output reg [8:0]  rtr_sel,
output reg [1:0]  hl_sel,
output reg [2:0]  rb_ip_sel,
output reg [8:0]  rb_ip_reg_sel,
output reg [8:0]  rb_reg_clr_sel,
output reg        dib_sel,
output reg        reg_wr,
output reg        reg_clr,
output reg        pc_incr,
output reg        mar_wr,
output reg        ram_wr,
output reg        ram_oe,
output reg        halt

);

// This ifdef let's us switch between BINARY and ONE_HOT encoding
`ifdef BINARY
  
  reg [5:0] CS;
  reg [5:0] NS;
  reg [5:0] CI;
  reg [5:0] cmb_CI;

  parameter FETCH =       6'b000000;
  parameter WAIT_MAR =    6'b000001;
  parameter WAIT_RAM_OE = 6'b000010;
  parameter IR_WAIT =     6'b000011;
  parameter DIB_WAIT =    6'b000100;
  parameter JMP_MISC =    6'b000101;
  parameter ARITH =       6'b000110;
  parameter LOGIC =       6'b000111;
  parameter MEM_MAN =     6'b001000;
  parameter NOP =         6'b001001;
  parameter JMP =         6'b001010;
  parameter JEZ =         6'b001011;
  parameter JGZ =         6'b001100;
  parameter JLZ =         6'b001101;
  parameter HLT =         6'b001110;
  parameter ADD =         6'b001111;
  parameter SUB =         6'b010000;
  parameter AND =         6'b010001;
  parameter OR =          6'b010010;
  parameter XOR =         6'b010011;
  parameter SFL =         6'b010100;
  parameter SFR =         6'b010101;
  parameter LD =          6'b010110;
  parameter ST =          6'b010111;
  parameter MOV =         6'b011000;
  parameter MVL =         6'b011001;
  parameter MVH =         6'b011010;
  parameter CLR =         6'b011011;
  parameter REG_WAIT =    6'b011100;
  parameter ALU_WAIT =    6'b011101;
  parameter MAR_WAIT =    6'b011110;
  parameter RAM_OE_WAIT = 6'b011111;
  parameter RAM_WR_WAIT = 6'b100000;
  parameter PC_INCR =     6'b100001;
  
 
`else 
  `ifdef ONE_HOT

    reg [33:0] CS;
    reg [33:0] NS;
    reg [33:0] CI;
    reg [33:0] cmb_CI;

    parameter FETCH =       34'h000000001;
    parameter WAIT_MAR =    34'h000000002;
    parameter WAIT_RAM_OE = 34'h000000004;
    parameter IR_WAIT =     34'h000000008;
    parameter DIB_WAIT =    34'h000000010;
    parameter JMP_MISC =    34'h000000020;
    parameter ARITH =       34'h000000040;
    parameter LOGIC =       34'h000000080;
    parameter MEM_MAN =     34'h000000100;
    parameter NOP =         34'h000000200;
    parameter JMP =         34'h000000400;
    parameter JEZ =         34'h000000800;
    parameter JGZ =         34'h000001000;
    parameter JLZ =         34'h000002000;
    parameter HLT =         34'h000004000;
    parameter ADD =         34'h000008000;
    parameter SUB =         34'h000010000;
    parameter AND =         34'h000020000;
    parameter OR =          34'h000040000;
    parameter XOR =         34'h000080000;
    parameter SFL =         34'h000100000;
    parameter SFR =         34'h000200000;
    parameter LD =          34'h000400000;
    parameter ST =          34'h000800000;
    parameter MOV =         34'h001000000;
    parameter MVL =         34'h002000000;
    parameter MVH =         34'h004000000;
    parameter CLR =         34'h008000000;
    parameter REG_WAIT =    34'h010000000;
    parameter ALU_WAIT =    34'h020000000;
    parameter MAR_WAIT =    34'h040000000;
    parameter RAM_OE_WAIT = 34'h080000000;
    parameter RAM_WR_WAIT = 34'h100000000;
    parameter PC_INCR =     34'h200000000;
  `endif
`endif

// Instantiation of some variables to ease the 
// implementation of the FSM

parameter        PC = 9'h0FF;

parameter        id = 1'b0;
parameter        rb = 1'b1;

parameter        low = 2'b01;
parameter        high = 2'b10;

parameter        rtr = 3'b001;
parameter        alu = 3'b010;
parameter        dib = 3'b011;
parameter        id_imme = 3'b100;

parameter        Add = 9'b001000000;
parameter        Sub = 9'b001000001;
parameter        And = 9'b010000000;
parameter        Or = 9'b010000001;
parameter        Xor = 9'b010000010;
parameter        Sfl = 9'b010000011;
parameter        Sfr = 9'b010000100;
parameter        Chk = 9'b000000000;

reg      [8:0]  CIR;
reg      [1:0]  CHL;
reg      [2:0]  CIS;
reg      [5:0]  ID;
reg      [7:0]  Reg1;
reg      [7:0]  Reg2;
reg      [7:0]  Reg3;

reg        cmb_ir_wr;
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

reg      [8:0]  cmb_CIR;
reg      [1:0]  cmb_CHL;
reg      [2:0]  cmb_CIS;

wire     [7:0]  cmb_ID;
wire     [7:0]  cmb_Reg1;
wire     [7:0]  cmb_Reg2;
wire     [7:0]  cmb_Reg3;

assign cmb_ID = instr[31:24];
assign cmb_Reg1 = instr[23:16];
assign cmb_Reg2 = instr[15:8];
assign cmb_Reg3 = instr[7:0];
assign cmb_imme_out = instr[15:0];


// This is the state reg of the FSM
always @ (posedge clk or negedge rst_b)
begin: state_reg
  if(rst_b == 1'b0) begin // Reset
    CS <= FETCH;
    CI <= 0;
    CIR <= 9'd0;
    CHL <= 2'd0;
    CIS <= 3'd0;
    ID <= 8'd0;
    Reg1 <= 8'd0;
    Reg2 <= 8'd0;
    Reg3 <= 8'd0;
    ir_wr <= 1'b0;
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
    CS <= NS;
    CI <= cmb_CI;
    CIR <= cmb_CIR;
    CHL <= cmb_CHL;
    CIS <= cmb_CIS;
    ID <= cmb_ID[5:0];
    Reg1 <= cmb_Reg1;
    Reg2 <= cmb_Reg2;
    Reg3 <= cmb_Reg3;
    ir_wr <= cmb_ir_wr;
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
  NS = CS;
  cmb_alu_fnct_sel = 9'h100;
  cmb_alu_a_sel = 9'h100;
  cmb_alu_b_sel = 9'h100;
  cmb_addr_sel = 9'h100;
  cmb_dob_sel = 9'h100;
  cmb_rtr_sel = 9'h100;
  cmb_hl_sel = 2'b00;
  cmb_rb_ip_sel = 3'b000;
  cmb_rb_ip_reg_sel = 9'h100;
  cmb_rb_reg_clr_sel = 9'h100;
  cmb_CIR = 9'd0;
  cmb_CHL = 2'd0;
  cmb_CIS = 3'd0;
  cmb_CI = CI;
  cmb_ir_wr = 1'b0;
  cmb_dib_sel = 1'b0;
  cmb_reg_wr = 1'b0;
  cmb_reg_clr = 1'b0;
  cmb_pc_incr = 1'b0;
  cmb_mar_wr = 1'b0;
  cmb_ram_wr = 1'b0;
  cmb_ram_oe = 1'b0;
  cmb_halt = 1'b0;

  // The main case statement
  case(CS)
   
    // The first four states are the fetch phase of the FSM
    FETCH:
    begin
      cmb_addr_sel = PC;
      cmb_dib_sel = id;
      cmb_mar_wr = 1'b1;
      NS = WAIT_MAR;
    end

    WAIT_MAR:
    begin
      cmb_addr_sel = PC;
      if (mar_wr_ack) begin
        cmb_ram_oe = 1'b1;
        NS = WAIT_RAM_OE;
      end
    end

    WAIT_RAM_OE:
    begin
      if(ram_oe_ack) begin
        NS = DIB_WAIT;
      end
    end
    
    DIB_WAIT:
    begin
      if(dib_ack)begin
        cmb_ir_wr = 1'b1;
        NS = IR_WAIT;
      end
    end

    IR_WAIT:
    begin
      //ir_wr = 1'b1; // Here incase of instruction register behaviour becoming weird
      if(ir_wr_ack)begin
        case(cmb_ID[7:6])
          2'b00: NS = JMP_MISC;
          2'b01: NS = ARITH;
          2'b10: NS = LOGIC;
          2'b11: NS = MEM_MAN;
        endcase
      end
    end 

    // These next four states are the branches for
    // each type of instruction
    JMP_MISC:
    begin
      case(ID[5:0])
        6'b000000:
        begin
          cmb_CI = NOP;
          NS = NOP;
        end
        6'b000001:
        begin
          cmb_CI = JMP;
          NS = JMP;
        end
        6'b000010:
        begin
          cmb_CI = JEZ;
          NS = JEZ;
        end
        6'b000011:
        begin
          cmb_CI = JGZ;
          NS = JGZ;
        end
        6'b000100:
        begin
          cmb_CI = JLZ;
          NS = JLZ;
        end
        6'b000101:
        begin
          cmb_CI = HLT;
          NS = HLT;
        end
        default: 
        begin
          cmb_CI = NOP;
          NS = NOP;
        end
      endcase
    end

    ARITH:
    begin
      case(ID[5:0])
        6'b000000:
        begin
          cmb_CI = ADD;
          NS = ADD;
        end
        6'b000001:
        begin
          cmb_CI = SUB;
          NS = SUB;
        end
        default: 
        begin
          cmb_CI = NOP;
          NS = NOP;
        end
      endcase
    end

    LOGIC:
    begin
      case(ID[5:0])
        6'b000000:
        begin
          cmb_CI = AND;
          NS = AND;
        end
        6'b000001:
        begin
          cmb_CI = OR;
          NS = OR;
        end
        6'b000010:
        begin
          cmb_CI = XOR;
          NS = XOR;
        end
        6'b000011:
        begin
          cmb_CI = SFL;
          NS = SFL;
        end
        6'b000100:
        begin
          cmb_CI = SFR;
          NS = SFR;
        end
        default: 
        begin
          cmb_CI = NOP;
          NS = NOP;
        end
      endcase
    end

    MEM_MAN:
    begin
      case(ID[5:0])
        6'b000000:
        begin
          cmb_CI = LD;
          NS = LD;
        end
        6'b000001:
        begin
          cmb_CI = ST;
          NS = ST;
        end
        6'b000010:
        begin
          cmb_CI = MOV;
          NS = MOV;
        end
        6'b000011:
        begin
          cmb_CI = MVL;
          NS = MVL;
        end
        6'b000100:
        begin
          cmb_CI = MVH;
          NS = MVH;
        end
        6'b000101:
        begin
          cmb_CI = CLR;
          NS = CLR;
        end
        default: 
        begin
          cmb_CI = NOP;
          NS = NOP;
        end
      endcase
    end
    
    // These next six states are jump and misc instructions
    NOP: NS = PC_INCR;

    JMP:
    begin
      cmb_rtr_sel = {1'b0,Reg1};
      cmb_rb_ip_sel = rtr;
      cmb_rb_ip_reg_sel = PC;
      cmb_CIR = PC;
      cmb_CIS = rtr;
      cmb_reg_wr = 1'b1;
      NS = REG_WAIT;
    end

    JEZ:
    begin
      cmb_alu_a_sel = {1'b0,Reg1};
      cmb_alu_fnct_sel = Chk;
      NS = ALU_WAIT;
    end

    JGZ:
    begin
      cmb_alu_a_sel = {1'b0,Reg1};
      cmb_alu_fnct_sel = Chk;
      NS = ALU_WAIT;
    end

    JLZ:
    begin
      cmb_alu_a_sel = {1'b0,Reg1};
      cmb_alu_fnct_sel = Chk;
      NS = ALU_WAIT;
    end

    HLT: cmb_halt = 1'b1;

    // These next two are the arithmetic instructions
    ADD:
    begin
      cmb_alu_a_sel = {1'b0,Reg1};
      cmb_alu_b_sel = {1'b0,Reg2};
      cmb_alu_fnct_sel = Add;
      NS = ALU_WAIT;
    end

    SUB:
    begin
      cmb_alu_a_sel = {1'b0,Reg1};
      cmb_alu_b_sel = {1'b0,Reg2};
      cmb_alu_fnct_sel = Sub;
      NS = ALU_WAIT;
    end
 
    // These next five are the logic instructions
    AND:
    begin
      cmb_alu_a_sel = {1'b0,Reg1};
      cmb_alu_b_sel = {1'b0,Reg2};
      cmb_alu_fnct_sel = And;
      NS = ALU_WAIT;
    end

    OR:
    begin
      cmb_alu_a_sel = {1'b0,Reg1};
      cmb_alu_b_sel = {1'b0,Reg2};
      cmb_alu_fnct_sel = Or;
      NS = ALU_WAIT;
    end

    XOR:
    begin
      cmb_alu_a_sel = {1'b0,Reg1};
      cmb_alu_b_sel = {1'b0,Reg2};
      cmb_alu_fnct_sel = Xor;
      NS = ALU_WAIT;
    end

    SFL:
    begin
      cmb_alu_a_sel = {1'b0,Reg1};
      cmb_alu_fnct_sel = Sfl;
      NS = ALU_WAIT;
    end

    SFR:
    begin
      cmb_alu_a_sel = {1'b0,Reg1};
      cmb_alu_fnct_sel = Sfr;
      NS = ALU_WAIT;
    end

    // These last six are the memory management instructions
    LD:
    begin
      cmb_addr_sel = {1'b0,Reg2};
      cmb_dib_sel = rb;
      cmb_mar_wr = 1'b1; 
      NS = MAR_WAIT;
    end

    ST:
    begin
      cmb_addr_sel = {1'b0,Reg2};
      cmb_mar_wr = 1'b1;
      NS = MAR_WAIT;
    end

    MOV:
    begin
      cmb_rtr_sel = {1'b0,Reg2};
      cmb_rb_ip_sel = rtr;
      cmb_rb_ip_reg_sel = {1'b0,Reg1};
      cmb_CIR = {1'b0,Reg1};
      cmb_CIS = rtr;
      cmb_reg_wr = 1'b1;
      NS = REG_WAIT;
    end

    MVL:
    begin
      cmb_rb_ip_sel = id_imme;
      cmb_hl_sel = low;
      cmb_rb_ip_reg_sel = {1'b0,Reg1};
      cmb_CIR = {1'b0,Reg1};
      cmb_CIS = id_imme;
      cmb_CHL = low;
      NS = REG_WAIT;
    end

    MVH:
    begin
      cmb_rb_ip_sel = id_imme;
      cmb_hl_sel = high;
      cmb_rb_ip_reg_sel = {1'b0,Reg1};
      cmb_CIR = {1'b0,Reg1};
      cmb_CIS = id_imme;
      cmb_CHL = high;
      cmb_reg_wr = 1'b1;
      NS = REG_WAIT;
    end

    CLR:
    begin
      cmb_rb_reg_clr_sel = {1'b0,Reg1};
      cmb_reg_clr = 1'b1;
      NS = PC_INCR;
    end

    REG_WAIT:
    begin
      cmb_rb_ip_reg_sel = CIR;
      cmb_rb_ip_sel = CIS;
      cmb_hl_sel = CHL;
      cmb_reg_wr = 1'b1;
      if(CI == JMP || CI == JEZ || CI == JGZ || CI == JLZ) begin
        if (reg_wr_ack)begin
          cmb_reg_wr = 1'b0;
          NS = FETCH;
        end
      end
      else begin
        if(reg_wr_ack) begin
          cmb_reg_wr = 1'b0;
          NS = PC_INCR;
        end
      end
    end

    // This is the state where the instruction
    // decoder waits for the ALU to finish
    ALU_WAIT:
    begin
      if(CI == JEZ) begin
        if(alu_ack) begin
          if(zf) begin
            cmb_rtr_sel = {1'b0,Reg2};
            cmb_rb_ip_sel = rtr;
            cmb_rb_ip_reg_sel = PC;
            cmb_CIR = PC;
            cmb_reg_wr = 1'b1;
            NS = REG_WAIT;
          end
          else begin
            NS = PC_INCR;
          end
        end
      end
      else if(CI == JGZ) begin
        if(alu_ack) begin
          if(!zf && !nf) begin
            cmb_rtr_sel = {1'b0,Reg2};
            cmb_rb_ip_sel = rtr;
            cmb_rb_ip_reg_sel = PC;
            cmb_CIR = PC;
            cmb_reg_wr = 1'b1;
            NS = REG_WAIT;
          end
          else begin
            NS = PC_INCR;
          end
        end
      end 
      else if(CI == JLZ) begin
        if(alu_ack) begin
          if(nf) begin
            cmb_rtr_sel = {1'b0,Reg2};
            cmb_rb_ip_sel = rtr;
            cmb_rb_ip_reg_sel = PC;
            cmb_CIR = PC;
            cmb_reg_wr = 1'b1;
            NS = REG_WAIT;
          end
          else begin
            NS = PC_INCR;
          end
        end
      end
      else if ((CI == ADD) || (CI == SUB) || (CI == AND) || (CI == OR) || (CI == XOR)) begin
        if(alu_ack) begin
          cmb_rb_ip_sel = alu;
          cmb_rb_ip_reg_sel = {1'b0,Reg3};
          cmb_CIR = {1'b0,Reg3};
          cmb_reg_wr = 1'b1;
          NS = REG_WAIT;
        end
      end
      else if (CI == SFL || CI == SFR) begin
        if(alu_ack) begin
          cmb_rb_ip_sel = alu;
          cmb_rb_ip_reg_sel = {1'b0,Reg1};
          cmb_CIR = {1'b0,Reg1};
          cmb_reg_wr = 1'b1;
          NS = REG_WAIT;
        end
      end
    end

    // This is the state where the instruction
    // decoder waits for the MAR to write
    MAR_WAIT:
    begin
      cmb_addr_sel = {1'b0,Reg2};
      case(CI)
        LD:
        begin
          cmb_dib_sel = rb;
          if(mar_wr_ack) begin
            cmb_ram_oe = 1'b1;
            NS = RAM_OE_WAIT;
          end  
        end
  
        ST:
        begin
          if(mar_wr_ack) begin
            cmb_dob_sel = {1'b0,Reg1};
            cmb_ram_wr = 1'b1;
            NS = RAM_WR_WAIT;
          end
        end
      default: NS = HLT;
      endcase
    end

    // This is the state where the instruction
    // decoder waits for the RAM to output
    RAM_OE_WAIT:
    begin
      cmb_dib_sel = rb;
      if(ram_oe_ack) begin
        cmb_rb_ip_sel = dib;
        cmb_rb_ip_reg_sel = {1'b0,Reg1};
        cmb_CIR = {1'b0,Reg1};
        cmb_reg_wr = 1'b1;
        NS = REG_WAIT;
      end
    end

    // This is the state where the instruction
    // decoder waits for the RAM to write
    RAM_WR_WAIT:
    begin
      cmb_dob_sel = {1'b0,Reg1};
      if(ram_wr_ack) begin
        NS = PC_INCR;
      end
    end

    // This is the state that increments the
    // program counter and resets the FSM
    PC_INCR:
    begin
      cmb_pc_incr = 1'b1;
      NS = FETCH;
    end
    
    default: NS = HLT;
  endcase  
end

endmodule
