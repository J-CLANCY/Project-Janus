module alu_fsm#(

parameter PA_DATA = 32'd32,
parameter PA_FNCT = 32'd9,
parameter PA_ADDER_DATA = 32'd8

)(

input wire                      clk,
input wire                      rst_b,
input wire [PA_DATA-1:0]  inp_a,
input wire [PA_DATA-1:0]  inp_b,
input wire [PA_FNCT-1:0]    fnct_sel,
input wire [PA_ADDER_DATA-1:0]  adder_out,
input wire                      carry_out,
input wire                      alu_req,
output reg [PA_DATA-1:0]  alu_out,
output reg                      alu_ack,
output reg [PA_ADDER_DATA-1:0]  adder_in_a,
output reg [PA_ADDER_DATA-1:0]  adder_in_b,
output reg                      carry_in,
output reg                      cf,
output reg                      zf,
output reg                      nf,
output reg                      vf

);

reg [31:0] cmb_alu_out;
reg        cmb_alu_ack;
reg [7:0]  cmb_adder_in_a;
reg [7:0]  cmb_adder_in_b;
reg        cmb_carry_in;
reg        cmb_cf;
reg        cmb_zf;
reg        cmb_nf;
reg        cmb_vf;
reg [7:0]  cmb_byte_00;
reg [7:0]  cmb_byte_01;
reg [7:0]  cmb_byte_10;
reg [7:0]  cmb_byte_11;
reg        cmb_carry_out_result;
reg [31:0] cmb_b;
reg [3:0]  cmb_next_state;

reg  [31:0] b;
wire [31:0] inv_b;

reg [7:0]  byte_00;
reg [7:0]  byte_01;
reg [7:0]  byte_10;
reg [7:0]  byte_11;
reg        carry_out_result;
reg [3:0]  next_state;

parameter FSM_ALU_IDLE = 4'b0000;
parameter FSM_ALU_ADD = 4'b0001;
parameter FSM_ALU_SUB = 4'b0010;
parameter FSM_ALU_AND = 4'b0011;
parameter FSM_ALU_OR = 4'b0100;
parameter FSM_ALU_XOR = 4'b0101;
parameter FSM_ALU_SFL = 4'b0110;
parameter FSM_ALU_SFR = 4'b0111;
parameter FSM_ALU_CHK = 4'b1000;
parameter FSM_ALU_BYTE_00 = 4'b1001;
parameter FSM_ALU_BYTE_01 = 4'b1010;
parameter FSM_ALU_BYTE_10 = 4'b1011;
parameter FSM_ALU_BYTE_11 = 4'b1100;
parameter FSM_ALU_ACK = 4'b1101;
parameter FSM_ALU_DELAY = 4'b1110;

reg [3:0] cs;
reg [3:0] ns;

assign inv_b = ~inp_b;


// This is the state reg of the ALU_FSM
always @(posedge clk or negedge rst_b)
begin: alu_fsm_state_reg
  if(rst_b == 1'b0) begin
    cs <= FSM_ALU_IDLE;
    alu_out <= 32'd0;
    alu_ack <= 1'b0;
    adder_in_a <= 8'd0;
    adder_in_b <= 8'd0;
    carry_in <= 1'b0;
    cf <= 1'b0;
    zf <= 1'b0;
    nf <= 1'b0;
    vf <= 1'b0;
    byte_00 <= 8'd0;
    byte_01 <= 8'd0;
    byte_10 <= 8'd0;
    byte_11 <= 8'd0;
    carry_out_result <= 1'b0;
    b <= 32'd0;
    next_state <= 4'd0;
  end
  else begin
    cs <= ns;
    alu_out <= cmb_alu_out;
    alu_ack <= cmb_alu_ack;
    adder_in_a <= cmb_adder_in_a;
    adder_in_b <= cmb_adder_in_b;
    carry_in <= cmb_carry_in;
    cf <= cmb_cf;
    zf <= cmb_zf;
    nf <= cmb_nf;
    vf <= cmb_vf;
    byte_00 <= cmb_byte_00;
    byte_01 <= cmb_byte_01;
    byte_10 <= cmb_byte_10;
    byte_11 <= cmb_byte_11;
    carry_out_result <= cmb_carry_out_result;
    b <= cmb_b;
    next_state <= cmb_next_state;
  end
end

always @(*)
begin: alu_fsm_ns_op_decode

  //Default
  ns = cs;
  cmb_alu_out = alu_out;
  cmb_alu_ack = 1'b0;
  cmb_adder_in_a = adder_in_a;
  cmb_adder_in_b = adder_in_b;
  cmb_carry_in = carry_in;
  cmb_cf = cf;
  cmb_zf = zf;
  cmb_nf = nf;
  cmb_vf = vf;
  cmb_byte_00 = byte_00;
  cmb_byte_01 = byte_01;
  cmb_byte_10 = byte_10;
  cmb_byte_11 = byte_11;
  cmb_carry_out_result = carry_out_result;
  cmb_b = b;
  cmb_next_state = next_state;

  case(cs)
    FSM_ALU_IDLE: // Waits for a request
    begin
      if(alu_req) begin
        case(fnct_sel[8:6])
          3'b000: ns = FSM_ALU_CHK;
          3'b001:
          begin
            case(fnct_sel[5:0])
              6'h00: 
              begin
                cmb_b = inp_b;
                ns = FSM_ALU_ADD;
              end

              6'h01:
              begin
                cmb_b = inv_b;
                ns = FSM_ALU_SUB;
              end

              default: ns = FSM_ALU_IDLE;
            endcase
          end
          3'b010:
          begin
            case(fnct_sel[5:0])
              6'h00: ns = FSM_ALU_AND;
              6'h01: ns = FSM_ALU_OR;
              6'h02: ns = FSM_ALU_XOR;
              6'h03: ns = FSM_ALU_SFL;
              6'h04: ns = FSM_ALU_SFR;
              default: ns = FSM_ALU_IDLE;
            endcase
          end
          default: ns = FSM_ALU_IDLE;
        endcase
      end
    end

    FSM_ALU_ADD: // Begins ADD
    begin
      cmb_carry_in = 1'b0;
      cmb_adder_in_a = inp_a[7:0];
      cmb_adder_in_b = b[7:0];
      cmb_next_state = FSM_ALU_BYTE_00;
      ns = FSM_ALU_DELAY;
    end

    FSM_ALU_SUB: // Begins SUB
    begin
      cmb_carry_in = 1'b1;
      cmb_adder_in_a = inp_a[7:0];
      cmb_adder_in_b = b[7:0];
      cmb_next_state = FSM_ALU_BYTE_00;
      ns = FSM_ALU_DELAY;
    end

    FSM_ALU_AND: // Begins AND
    begin
      cmb_alu_out = inp_a & inp_b;
      ns = FSM_ALU_ACK;
    end

    FSM_ALU_OR: // Begins OR
    begin
      cmb_alu_out = inp_a | inp_b;
      ns = FSM_ALU_ACK;
    end

    FSM_ALU_XOR:  // Begins XOR
    begin
      cmb_alu_out = inp_a ^ inp_b;
      ns = FSM_ALU_ACK;
    end

    FSM_ALU_SFL:  // Begins SFL
    begin
      cmb_alu_out = inp_a << 1;
      ns = FSM_ALU_ACK;
    end

    FSM_ALU_SFR:  // Begins SFR
    begin
      cmb_alu_out = inp_a >> 1;
      ns = FSM_ALU_ACK;
    end

    FSM_ALU_CHK:  // Begins CHK
    begin
       cmb_alu_out = inp_a;
       if(inp_a == 32'd0) begin
         cmb_zf = 1'b1;
         cmb_nf = 1'b0;
       end
       else if(inp_a[31] == 1'b1) begin
         cmb_zf = 1'b0;
         cmb_nf = 1'b1;
       end
       else begin
         cmb_zf = 1'b0;
         cmb_nf = 1'b0;
       end
       ns = FSM_ALU_ACK;
    end
    
    FSM_ALU_DELAY: ns = next_state; // Delays by 1 cycle

    FSM_ALU_BYTE_00: // Saves first byte
    begin
      cmb_byte_00 = adder_out;
      cmb_carry_in = carry_out;
      cmb_adder_in_a = inp_a[15:8];
      cmb_adder_in_b = b[15:8];
      cmb_next_state = FSM_ALU_BYTE_01;
      ns = FSM_ALU_DELAY;
    end

    FSM_ALU_BYTE_01: // Saves second byte
    begin
      cmb_byte_01 = adder_out;
      cmb_carry_in = carry_out;
      cmb_adder_in_a = inp_a[23:16];
      cmb_adder_in_b = b[23:16];
      cmb_next_state = FSM_ALU_BYTE_10;
      ns = FSM_ALU_DELAY;
    end

    FSM_ALU_BYTE_10: // Saves third byte
    begin
      cmb_byte_10 = adder_out;
      cmb_carry_in = carry_out;
      cmb_adder_in_a = inp_a[31:24];
      cmb_adder_in_b = b[31:24];
      cmb_next_state = FSM_ALU_BYTE_11;
      ns = FSM_ALU_DELAY;
    end

    FSM_ALU_BYTE_11: // Saves fourth byte
    begin
      cmb_byte_11 = adder_out;
      cmb_alu_out = {cmb_byte_11,cmb_byte_10,cmb_byte_01,cmb_byte_00};
      cmb_carry_out_result = carry_out;
      ns = FSM_ALU_ACK;
    end
  
    FSM_ALU_ACK: // Send acknowledge
    begin
      cmb_alu_ack = 1'b1;
      ns = FSM_ALU_IDLE;
    end
    default: ns = FSM_ALU_IDLE;
  endcase
end
endmodule
