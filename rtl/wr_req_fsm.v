module wr_req_fsm(

input wire clk,
input wire rst_b,
input wire wr_req,
output reg wr_out

);

// This FSM takes in the WR signal from the instruction decoder
// and delays it until the data sent is available to the register

parameter FSM_WR_IDLE = 2'b00;
parameter FSM_WR_DELAY_ONE = 2'b01;

reg [1:0] cs;
reg [1:0] ns;

reg cmb_wr_out;

// This is the state reg of the wr_req_fsm
always @(posedge clk or negedge rst_b)
begin: wr_req_reg
  if(rst_b == 1'b0)begin
    cs <= FSM_WR_IDLE;
    wr_out <= 1'b0;
  end
  else begin
    cs <= ns;
     wr_out <= cmb_wr_out;
  end
end

always @(*)
begin: wr_req_ns_op_decode

  ns = cs;
  cmb_wr_out = 1'b0;
  
  case(cs)
    FSM_WR_IDLE: // Waits for write
    begin
      if(wr_req) begin
        ns = FSM_WR_DELAY_ONE;
      end
    end
  
    FSM_WR_DELAY_ONE: // Delay by 1 cycle
    begin
      cmb_wr_out = 1'b1;
      ns = FSM_WR_IDLE;
    end
    default: ns = FSM_WR_IDLE;
  endcase
end
    

endmodule
