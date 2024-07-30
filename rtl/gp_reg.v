module gp_reg#(

parameter PA_DATA = 32'd32,
parameter PA_HL = 32'd2

)(

input wire               clk,
input wire               rst_b,
input wire [PA_DATA-1:0] data_in,
input wire [PA_HL-1:0]   hl_sel,
input wire               reg_wr,
input wire               reg_clr,
output reg [PA_DATA-1:0] data_out,
output reg               reg_wr_ack
  
);

// This is the general purpose register module that will be used for
// all general purpose registers that the system will have
parameter FSM_REG_IDLE = 2'b00;
parameter FSM_REG_CLR = 2'b01;
parameter FSM_REG_WR = 2'b10;
parameter FSM_REG_ACK = 2'b11;

reg [31:0] cmb_data_out;
reg        cmb_reg_wr_ack;
reg [1:0] cs;
reg [1:0] ns;

// This is the state reg of the register
always @ (posedge clk or negedge rst_b)
begin: gp_reg
  if(!rst_b) begin // Reset
    data_out <= 32'd0;
    reg_wr_ack <= 1'b0;
    cs <= FSM_REG_IDLE;
  end
  else begin
    data_out <= cmb_data_out;
    reg_wr_ack <= cmb_reg_wr_ack;
    cs <= ns; 
  end
end

always @(*)
begin: gp_reg_ns_op_decode

  ns = cs;
  cmb_data_out = data_out;
  cmb_reg_wr_ack = 1'b0;

  case(cs)
    FSM_REG_IDLE: // Waits for a signal
    begin
      if(reg_clr) begin
        ns = FSM_REG_CLR;
      end
      else if(reg_wr) begin
        ns = FSM_REG_WR;
      end
    end

    FSM_REG_CLR:
    begin
      cmb_data_out = 32'd0; // Clear
      ns = FSM_REG_IDLE;
    end

    FSM_REG_WR: 
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
      ns = FSM_REG_ACK;
    end

    FSM_REG_ACK: 
    begin
      cmb_reg_wr_ack = 1'b1; // Acknowledge
      ns = FSM_REG_IDLE;
    end
  endcase
end

endmodule
