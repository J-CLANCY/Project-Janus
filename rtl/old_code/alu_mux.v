module alu_mux(

input wire        clk,
input wire        rst_b,
input wire [31:0] add_out,
input wire [31:0] sub_out,
input wire [31:0] and_out,
input wire [31:0] or_out,
input wire [31:0] xor_out,
input wire [31:0] sfl_out,
input wire [31:0] sfr_out,
input wire [31:0] chk_out,
input wire [8:0]  fnct_sel,
output reg [31:0] mux_out

);

// This is the mux that controls which ALU function
// get's outputted to the register bank

reg [31:0] cmb_mux_out;

always @(posedge clk or negedge rst_b)
begin: alu_mux_reg
  if(rst_b == 1'b0)begin
    mux_out <= 32'd0;
  end
  else begin
    mux_out <= cmb_mux_out;
  end
end

always @(*)
begin: alu_mux
  case(fnct_sel[8:6])
    3'b000: cmb_mux_out = chk_out;
    3'b001:
    begin
      case(fnct_sel[5:0])
        6'h00: cmb_mux_out = add_out;
        6'h01: cmb_mux_out = sub_out;
        default: cmb_mux_out = 32'd0;
      endcase
    end
    3'b010:
    begin
      case(fnct_sel[5:0])
        6'h00: cmb_mux_out = and_out;
        6'h01: cmb_mux_out = or_out;
        6'h02: cmb_mux_out = xor_out;
        6'h03: cmb_mux_out = sfl_out;
        6'h04: cmb_mux_out = sfr_out;
        default:cmb_mux_out = 32'd0;
      endcase
    end
    3'b100: cmb_mux_out = 32'd0;
    default: cmb_mux_out = 32'd0;
  endcase
end

endmodule
