module program_counter#(

parameter PA_DATA = 32'd32,
parameter PA_HL = 32'd2

)(

input wire               clk,
input wire               rst_b,
input wire [PA_DATA-1:0] data_in,
input wire [PA_HL-1:0]         hl_sel,
input wire               reg_wr,
input wire               reg_clr,
input wire               pc_incr,
output reg [PA_DATA-1:0] data_out,
output reg               reg_wr_ack

);

// The program counter is very similar to a general purpose register,
// the only difference being that the program counter has the pc_incr
// signal that increments it by one
parameter FSM_PC_IDLE = 3'b000;
parameter FSM_PC_CLR = 3'b001;
parameter FSM_PC_WR = 3'b010;
parameter FSM_PC_INCR = 3'b011;
parameter FSM_PC_ACK = 3'b100;

reg [31:0] cmb_data_out;
reg        cmb_reg_wr_ack;
reg [2:0] cs;
reg [2:0] ns;

// This is the state reg of the program counter
always @ (posedge clk or negedge rst_b)
begin: pc_reg
  if(!rst_b) begin // Reset
    data_out <= 32'd0;
    reg_wr_ack <= 1'b0;
    cs <= FSM_PC_IDLE;
  end
  else begin
    data_out <= cmb_data_out;
    reg_wr_ack <= cmb_reg_wr_ack;
    cs <= ns; 
  end
end

always @(*)
begin: pc_ns_op_decode

  ns = cs;
  cmb_data_out = data_out;
  cmb_reg_wr_ack = 1'b0;

  case(cs)
    FSM_PC_IDLE: // Waits for signal
    begin
      if(reg_clr) begin
        ns = FSM_PC_CLR;
      end
      else if(pc_incr) begin
        ns = FSM_PC_INCR;
      end
      else if(reg_wr) begin
        ns = FSM_PC_WR;
      end
    end

    FSM_PC_CLR:
    begin
      cmb_data_out = 32'd0; // Clear
      ns = FSM_PC_INCR;
    end
    
    FSM_PC_INCR: // Increments PC
    begin
      cmb_data_out = cmb_data_out + 32'd1;
      ns = FSM_PC_ACK;
    end

    FSM_PC_WR: 
    begin
      if (hl_sel == 2'b00) begin // Default write
        cmb_data_out = data_in; 
      end 
      else if (hl_sel == 2'b01) begin // Write lower half_word
        cmb_data_out[15:0] = data_in[15:0];
      end
      else if (hl_sel == 2'b10) begin // Write upper half_word
        cmb_data_out[31:16] = data_in[31:16];
      end
      ns = FSM_PC_ACK;
    end

    FSM_PC_ACK: 
    begin
      cmb_reg_wr_ack = 1'b1; // Acknowledge
      ns = FSM_PC_IDLE;
    end
  endcase
end

endmodule
