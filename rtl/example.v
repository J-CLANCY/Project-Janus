module example(

input wire a,
input wire b,
output wire o,
output wire co

);

and and_gate (co,a,b);
xor xor_gate (o,a,b);

endmodule
