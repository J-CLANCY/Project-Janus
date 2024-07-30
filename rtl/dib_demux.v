module dib_demux#(

parameter PA_DATA_WIDTH = 32'd32

)(

input wire                      clk,
input wire                      rst_b,
input wire [PA_DATA_WIDTH-1:0]  dib,
input wire                      dib_sel,
input wire                      ram_oe_ack,       
output reg [PA_DATA_WIDTH-1:0]  dib_id,
output reg [PA_DATA_WIDTH-1:0]  dib_rb,
output reg                      dib_ack

);

// This module controls which module the DIB
// goes to, either the ID or the RB

reg [31:0] dib_id_inter;
reg [31:0] dib_rb_inter;

// This is the state reg of the DIB demux
always @(posedge clk or negedge rst_b)
begin: dib_mux_state_reg 
  if(!rst_b) begin
    dib_id <= 32'd0;
    dib_rb <= 32'd0;
    dib_ack <= 1'b0;
  end
  else if (ram_oe_ack) begin
    dib_id <= dib_id_inter;
    dib_rb <= dib_rb_inter;
    dib_ack <= 1'b1;
  end
  else begin
    dib_ack <= 1'b0;
  end
end

always @(*)
begin: dib_mux_decode
  case(dib_sel)
    1'b0:
    begin
      dib_id_inter = dib;
      dib_rb_inter = dib_rb;
    end
    1'b1:
    begin
      dib_id_inter = dib_id;
      dib_rb_inter = dib;
    end
  endcase
end

endmodule
