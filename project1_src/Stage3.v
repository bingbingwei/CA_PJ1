module Stage3(
	RegWrite_i_3,
    RegWrite_o_3,
    MemtoReg_i_3,
    MemtoReg_o_3,
	
    Memory_write_i_3,
    Memory_write_o_3,
    Memory_read_i_3,
    Memory_read_o_3,
    
    clk_i,
    
    Data1_i,
    Data1_o,
    mux7_output_data_i,
    mux7_output_data_o,
	RDaddr_i,
    RDaddr_o
);

input	      RegWrite_i_3,MemtoReg_i_3,Memory_write_i_3,Memory_read_i_3,clk_i;
output        RegWrite_o_3,MemtoReg_o_3,Memory_write_o_3,Memory_read_o_3;
input  [31:0] Data1_i, mux7_output_data_i;
output [31:0] Data1_o, mux7_output_data_o;
input  [4:0]  RDaddr_i;
output [4:0]  RDaddr_o;

reg	       RegWrite, MemtoReg, Memory_write, Memory_read;
reg [31:0] Data1, mux7_output_data;
reg [4:0]  RDaddr;

assign RegWrite_o_3 = RegWrite;
assign MemtoReg_o_3 = MemtoReg;
assign Memory_write_o_3 = Memory_write;
assign Memory_read_o_3 = Memory_read;
assign Data1_o = Data1;
assign mux7_output_data_o = mux7_output_data;
assign RDaddr_o = RDaddr;

always @(posedge clk_i) begin
	RegWrite = RegWrite_i_3;
	MemtoReg = MemtoReg_i_3;	
	Memory_write = Memory_write_i_3;
	Memory_read = Memory_read_i_3;
	Data1 = Data1_i;
	mux7_output_data = mux7_output_data_i;
	RDaddr = RDaddr_i;
end

endmodule
