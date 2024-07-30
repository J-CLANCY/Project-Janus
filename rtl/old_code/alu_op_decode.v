module alu_op_decode(

input wire        clk,
input wire        rst_b,
input wire [31:0] fnct_out,
input wire        cf_curr,
input wire        nf_curr,
input wire        zf_curr,
input wire        vf_curr,
output reg [31:0] alu_out,
output reg        alu_ack,
output reg        cf,
output reg        nf,
output reg        zf,
output reg        vf

);
  
// This is the module that generates the alu_ack signal
// and outputs the results of a calculation

always @(posedge clk or negedge rst_b)
begin :alu_op_decode
  if(rst_b == 1'b0) begin // Reset
    alu_out <= 32'd0;
    alu_ack <= 1'b0;
    cf <= 1'b0;
    nf <= 1'b0;
    zf <= 1'b0;
    vf <= 1'b0;
  end
  else if((!((fnct_out == alu_out)&(cf == cf_curr)&(nf == nf_curr)&(zf == zf_curr)&(vf == vf_curr)))||(fnct_out == 0 && alu_out == 0))begin
    alu_ack <= 1'b1;
    alu_out <= fnct_out;
    cf <= cf_curr;
    nf <= nf_curr;
    zf <= zf_curr;
    vf <= vf_curr;      // If the previous outputs don't                                                                     
  end                  // match the incoming ones, then the
  else begin           // ALU has completed an operation
    alu_ack <= 1'b0;
  end                                     
end
endmodule

