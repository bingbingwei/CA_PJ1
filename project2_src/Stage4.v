module Stage4(
	clk_i,
	RegWrite_i_4,
	MemtoReg_i_4,
	RegWrite_o_4,
	MemtoReg_o_4,
	Data1_i,
	Data1_o,
    Data2_i,
	Data2_o,
    RDaddr_i,
    RDaddr_o,
    stall_i
);

input	      RegWrite_i_4,MemtoReg_i_4,clk_i;
output	      RegWrite_o_4,MemtoReg_o_4;
input  [31:0] Data1_i, Data2_i;
output [31:0] Data1_o, Data2_o;
input  [4:0]  RDaddr_i;
output [4:0]  RDaddr_o;
input         stall_i;

reg    		  RegWrite_o_4, MemtoReg_o_4;
reg    [31:0] Data1_o, Data2_o;
reg	   [4:0]  RDaddr_o;

always @(posedge clk_i) begin
   if(stall_i) begin
      RegWrite_o_4 <= 0;
      MemtoReg_o_4 <= 0;
      Data1_o <= 0;
      Data2_o <= 0;
      RDaddr_o <= 0;
   end
   else begin
      RegWrite_o_4 <= RegWrite_i_4;
      MemtoReg_o_4 <= MemtoReg_i_4;
      Data1_o <= Data1_i;
      Data2_o <= Data2_i;
      RDaddr_o <= RDaddr_i;
   end
end

endmodule
