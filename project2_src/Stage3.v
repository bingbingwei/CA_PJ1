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

reg	       RegWrite_o_3, MemtoReg_o_3, Memory_write_o_3, Memory_read_o_3;
reg [31:0] Data1_o, mux7_output_data_o;
reg [4:0]  RDaddr_o;

always @(posedge clk_i) begin
	RegWrite_o_3 <= RegWrite_i_3;
	MemtoReg_o_3 <= MemtoReg_i_3;	
	Memory_write_o_3 <= Memory_write_i_3;
	Memory_read_o_3 <= Memory_read_i_3;
	Data1_o <= Data1_i;
	mux7_output_data_o <= mux7_output_data_i;
	RDaddr_o <= RDaddr_i;
end

endmodule
