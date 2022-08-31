
module 

module user_module_coralmw_manual_verilog(
  input [7:0] io_in,
  output [7:0] io_out
);

wire CLK; 
assign CLK = io_in[0];
wire RST; 
assign RST = io_in[1];
wire [3:0] ancilla; 
assign ancilla = io_in[6:3];

wire [4:0] correction;
wire [1:0] axis;
assign io_out = {0, axis, correction};

  codelut codeLUT(
    CLK, RST,
    ancilla,
    correction,
    axis);
    
endmodule
