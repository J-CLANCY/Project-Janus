module inst_reg#(

parameter PA_DATA_WIDTH = 32'd32

)(

input wire        clk,
input wire        rst_b,
input wire [PA_DATA_WIDTH-1:0] data_in,
input wire        ir_wr,
output reg [PA_DATA_WIDTH-1:0] data_out,
output reg        ir_wr_ack

);

// The instruction register is just a very simple set of 
// 32 D flip flops that store the current instruction 

parameter FSM_IR_IDLE = 2'b00;
parameter FSM_IR_WR = 2'b01;
parameter FSM_IR_ACK = 2'b10;

reg [31:0] cmb_data_out;
reg        cmb_ir_wr_ack;
reg [1:0] cs;
reg [1:0] ns;

// This is the state reg of the IR
always @ (posedge clk or negedge rst_b)
begin: ir_reg
  if(!rst_b) begin // Reset
    data_out <= 32'd0;
    ir_wr_ack <= 1'b0;
    cs <= FSM_IR_IDLE;
  end
  else begin
    data_out <= cmb_data_out;
    ir_wr_ack <= cmb_ir_wr_ack;
    cs <= ns; 
  end
end

always @(*)
begin: ir_ns_op_decode

  ns = cs;
  cmb_data_out = data_out;
  cmb_ir_wr_ack = 1'b0;

  case(cs)
    FSM_IR_IDLE:
    begin
      if(ir_wr) begin
        ns = FSM_IR_WR;
      end
    end

    FSM_IR_WR: // Write
    begin
      cmb_data_out = data_in;
      ns = FSM_IR_ACK;
    end

    FSM_IR_ACK: 
    begin
      cmb_ir_wr_ack = 1'b1; // Acknowledge
      ns = FSM_IR_IDLE;
    end
    default: ns = FSM_IR_IDLE;
  endcase
end

endmodule
