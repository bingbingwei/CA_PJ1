module Stage1(
	inst_i,
	inst_o,
   HD_i,
   flush_i,
	clk_i
);

input         clk_i;
input  [31:0] inst_i;
output [31:0] inst_o;

reg    [31:0] tmp;

assign inst_o = tmp;

always@ (posedge clk_i) begin
   //don't know what's this?
   if(flush_i != 1 && HD_i != 1) begin
      tmp = inst_i;
   end
end

endmodule
