module Stage2(
    RegWrite_i_2,
    RegWrite_o_2,
    MemtoReg_i_2,
    MemtoReg_o_2,
    Memory_write_i_2,
    Memory_write_o_2,
    Memory_read_i_2,
    Memory_read_o_2,
    ALUSrc_i_2,
    ALUOp_i_2,
    RegDst_i_2,
    ALUSrc_o_2,
    ALUOp_o_2,
    RegDst_o_2,
    clk_i,
	
	RSdata_i,
    RSdata_o,
    RTdata_i,
    RTdata_o,
    
	Sign_extend_i,
    Sign_extend_o,
    
	RSaddr_i,
	RSaddr_o,
	RTaddr_i,
	RTaddr_o,
	RDaddr_i,
	RDaddr_o
);

input         RegWrite_i_2,MemtoReg_i_2,Memory_write_i_2,Memory_read_i_2,ALUSrc_i_2,RegDst_i_2, clk_i;
output        RegWrite_o_2,MemtoReg_o_2,Memory_write_o_2,Memory_read_o_2,ALUSrc_o_2,RegDst_o_2;
input  [1:0]  ALUOp_i_2;
output [1:0]  ALUOp_o_2;
input  [31:0] RSdata_i, RTdata_i, Sign_extend_i;
output [31:0] RSdata_o, RTdata_o, Sign_extend_o;
input  [4:0]  RSaddr_i, RTaddr_i, RDaddr_i;
output [4:0]  RSaddr_o, RTaddr_o, RDaddr_o;

reg RegWrite, MemtoReg, Memory_write, Memory_read, ALUSrc, RegDst;
reg [1:0] ALUOp;
reg [31:0] RSdata, RTdata, Sign_extend;
reg [4:0] RSaddr, RTaddr, RDaddr;

assign RegWrite_o_2 = RegWrite;
assign MemtoReg_o_2 = MemtoReg;
assign Memory_write_o_2 = Memory_write;
assign Memory_read_o_2 = Memory_read;
assign ALUSrc_o_2 = ALUSrc;
assign RegDst_o_2 = RegDst;
assign ALUOp_o_2 = ALUOp;
assign RSdata_o = RSdata;
assign RTdata_o = RTdata;
assign Sign_extend_o = Sign_extend;
assign RSaddr_o = RSaddr;
assign RTaddr_o = RTaddr;
assign RDaddr_o = RDaddr;

always @(posedge clk_i)begin
	RegWrite = RegWrite_i_2;
	MemtoReg = MemtoReg_i_2;	
	Memory_write = Memory_write_i_2;
	Memory_read = Memory_read_i_2;
	ALUSrc = ALUSrc_i_2;
	RegDst = RegDst_i_2;
	ALUOp = ALUOp_i_2;
	RSdata = RSdata_i;
	RTdata = RTdata_i;
	Sign_extend = Sign_extend_i;
	RSaddr = RSaddr_i;
	RTaddr = RTaddr_i;
	RDaddr = RDaddr_i;
end

endmodule