module Stage1{
	inst_i,
	inst_o,
	clk_i
};

input         clk_i;
input  [31:0] inst_i;
output [31:0] inst_o;

reg    [31:0] tmp;

assign inst_o = tmp;

always@ (posedge clk_i) begin
	tmp = inst_i;
end

endmodule