module ip_mux#(

parameter PA_IP = 32'd3,
parameter PA_HL = 32'd2,
parameter PA_DATA = 32'd32,
parameter PA_IMME = 32'd16

)(

input wire               clk,
input wire               rst_b,
input wire [PA_IP-1:0]   ip_sel,
input wire [PA_HL-1:0]   hl_sel,
input wire [PA_DATA-1:0] rtr_out,
input wire [PA_DATA-1:0] alu_out,
input wire [PA_DATA-1:0] dib,
input wire [PA_IMME-1:0] id_imme,
output reg [PA_DATA-1:0] mux_out

);

// This is the multiplexer that controls all of the data
// inputs into the register bank
reg [31:0] cmb_mux_out;

// This is the state reg of the mux
always @(posedge clk or negedge rst_b)
begin: ip_mux_reg
  if(rst_b == 1'b0) begin
    mux_out <= 32'd0;
  end
  else begin
    mux_out <= cmb_mux_out;
  end
end

always @(*)
begin: ip_mux
  case(ip_sel)
    3'b000: cmb_mux_out = 32'd0;    // Nothing selected
    3'b001: cmb_mux_out = rtr_out; // Reg to reg transfer
    3'b010: cmb_mux_out = alu_out; // ALU to reg transfer
    3'b011: cmb_mux_out = dib;     // Data input bus to reg
    3'b100: // Upper or lower half immediate value write
    begin
      if(hl_sel == 2'b00 || hl_sel == 2'b01) begin
        cmb_mux_out[31:16] = 16'd0;
        cmb_mux_out[15:0] = id_imme[15:0];
      end
      else if (hl_sel == 2'b10) begin
        cmb_mux_out[31:16] = id_imme[15:0];
        cmb_mux_out[15:0] = 16'd0;
      end
      else begin
        cmb_mux_out = 32'd0;
      end
    end
    default: cmb_mux_out = 32'd0;
  endcase
end


endmodule
