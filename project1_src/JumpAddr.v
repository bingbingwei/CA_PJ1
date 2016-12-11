module JumpAddr(
   inst_26,
   mux1_o_3,
   jump_addr 
);

input    [25:0]   inst_26;
input    [3:0]    mux1_o_3;
output   [31:0]   jump_addr;

assign jump_addr = {mux1_o_3, inst_26, 1'b0, 1'b0};

endmodule
