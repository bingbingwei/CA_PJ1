module Stage1(
	inst_i,
	inst_o,
   HD_i,
   stall_i,
   flush_i,
   data1_i,
   data1_o_1,
	clk_i
);


input  [31:0] inst_i, data1_i;
input         clk_i, HD_i, flush_i, stall_i;
output [31:0] inst_o, data1_o_1;
reg    [31:0] inst_o, data1_o_1;


always@ (posedge clk_i) begin
   if(HD_i || stall_i) begin
      inst_o <= inst_o;
      data1_o_1 <= data1_o_1;
   end 
   else if(flush_i) begin
      inst_o <= 0;
      data1_o_1 <= 0;
   end
   else begin
      inst_o <= inst_i;
      data1_o_1 <= data1_i;
   end   

end

endmodule
