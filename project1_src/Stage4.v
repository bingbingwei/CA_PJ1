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
    RDaddr_o
);

input	      RegWrite_i_4,MemtoReg_i_4,clk_i;
output	      RegWrite_o_4,MemtoReg_o_4;
input  [31:0] Data1_i, Data2_i;
output [31:0] Data1_o, Data2_o;
input  [4:0]  RDaddr_i;
output [4:0]  RDaddr_o;

reg    		  RegWrite, MemtoReg;
reg    [31:0] Data1, Data2;
reg	   [4:0]  RDaddr;

assign RegWrite_o_4 = RegWrite;
assign MemtoReg_o_4 = MemtoReg;
assign Data1_o = Data1;
assign Data2_o = Data2;
assign Rdaddr_o = Rdaddr;

always @(posedge clk_i) begin
	RegWrite = RegWrite_i_4;
	MemtoReg = MemtoReg_i_4;
	Data1 = Data1_i;
	Data2 = Data2_i;
	Rdaddr = Rdaddr_o;
end

endmodule