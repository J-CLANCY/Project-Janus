module adder_8_bit#(

parameter PA_DATA_WIDTH = 32'd8

)(

input wire                     clk,
input wire                     rst_b,
input wire [PA_DATA_WIDTH-1:0] adder_in_a,
input wire [PA_DATA_WIDTH-1:0] adder_in_b,
input wire                     carry_in,
output reg [PA_DATA_WIDTH-1:0] adder_out,
output reg                     carry_out

);

wire [7:0] cmb_adder_out;
wire       cmb_carry_out;

assign {cmb_carry_out, cmb_adder_out} = // This is te addition of the two bytes and the carry
         adder_in_a + adder_in_b + {7'd0,carry_in};

// This is the state reg of the adder
always @(posedge clk or negedge rst_b)
begin: adder_8_bit
  if (rst_b == 1'b0) begin
    adder_out <= 8'd0;
    carry_out <= 1'b1;
  end
  else begin
    adder_out <= cmb_adder_out;
    carry_out <= cmb_carry_out;
  end
end

endmodule

