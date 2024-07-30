module ram(

input wire        clk,
input wire         rst_b,
input wire [2:0]  cb_out,
input wire [31:0] ab,
input wire [31:0] dob,
output wire [2:0]  cb_in,
output reg [31:0] dib

);

wire mar_wr = cb_out[0];
wire ram_wr = cb_out[1];
wire ram_oe = cb_out[2];
reg mar_wr_ack;
reg ram_wr_ack;
reg ram_oe_ack;

reg [31:0] address;
reg [31:0] current;

reg [31:0] mem [0:255];

integer j;

always @(negedge rst_b)
begin: reset
  if(rst_b == 1'b0)begin
    for(j=0;j<256;j=j+1) begin
      mem[j] = 32'd0;
    end
    $readmemh("RAM.txt", mem);
  end
end

always @ (posedge clk)
begin: MAR_WRITE
  if (mar_wr) begin
    address <= ab;
    mar_wr_ack <= 1;
  end
  else begin
    mar_wr_ack <= 0;
  end
end

always @ (posedge clk)
begin: RAM_WRITE
  if(ram_wr && !ram_oe) begin
    mem[address] <= dob;
    ram_wr_ack <= 1;
  end
  else begin
    ram_wr_ack <= 0;
  end
end

always @ (posedge clk)
begin: RAM_READ
  if(!ram_wr && ram_oe) begin
    dib <= mem[address];
    current <= mem[address];
    ram_oe_ack <= 1;
  end
  else begin
    dib <= current;
    ram_oe_ack <= 0;
  end
end

assign cb_in[0] = mar_wr_ack;
assign cb_in[1] = ram_wr_ack;
assign cb_in[2] = ram_oe_ack;

endmodule
