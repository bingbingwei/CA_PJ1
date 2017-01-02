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
	RDaddr_o,

   funct_i,
   funct_o,
   stall_i
);

input         RegWrite_i_2,MemtoReg_i_2,Memory_write_i_2,Memory_read_i_2,ALUSrc_i_2,RegDst_i_2, clk_i;
output        RegWrite_o_2,MemtoReg_o_2,Memory_write_o_2,Memory_read_o_2,ALUSrc_o_2,RegDst_o_2;
reg           RegWrite_o_2,MemtoReg_o_2,Memory_write_o_2,Memory_read_o_2,ALUSrc_o_2,RegDst_o_2;
input  [1:0]  ALUOp_i_2;
output [1:0]  ALUOp_o_2;
reg    [1:0]  ALUOp_o_2;
input  [31:0] RSdata_i, RTdata_i, Sign_extend_i;
output [31:0] RSdata_o, RTdata_o, Sign_extend_o;
reg    [31:0] RSdata_o, RTdata_o, Sign_extend_o;
input  [4:0]  RSaddr_i, RTaddr_i, RDaddr_i;
output [4:0]  RSaddr_o, RTaddr_o, RDaddr_o;
reg    [4:0]  RSaddr_o, RTaddr_o, RDaddr_o;
input  [5:0]  funct_i;
output [5:0]  funct_o;
reg    [5:0]  funct_o;

input         stall_i;

always @(posedge clk_i)begin
   if(stall_i) begin
      RegWrite_o_2 <= RegWrite_o_2;
      MemtoReg_o_2 <= MemtoReg_o_2;	
      Memory_write_o_2 <= Memory_write_o_2;
      Memory_read_o_2 <= Memory_read_o_2;
      ALUSrc_o_2 <= ALUSrc_o_2;
      RegDst_o_2 <= RegDst_o_2;
      ALUOp_o_2 <= ALUOp_o_2;
      RSdata_o <= RSdata_o;
      RTdata_o <= RTdata_o;
      Sign_extend_o <= Sign_extend_o;
      RSaddr_o <= RSaddr_o;
      RTaddr_o <= RTaddr_o;
      RDaddr_o <= RDaddr_o;
      funct_o <= funct_o;
   end
   else begin
      RegWrite_o_2 <= RegWrite_i_2;
      MemtoReg_o_2 <= MemtoReg_i_2;	
      Memory_write_o_2 <= Memory_write_i_2;
      Memory_read_o_2 <= Memory_read_i_2;
      ALUSrc_o_2 <= ALUSrc_i_2;
      RegDst_o_2 <= RegDst_i_2;
      ALUOp_o_2 <= ALUOp_i_2;
      RSdata_o <= RSdata_i;
      RTdata_o <= RTdata_i;
      Sign_extend_o <= Sign_extend_i;
      RSaddr_o <= RSaddr_i;
      RTaddr_o <= RTaddr_i;
      RDaddr_o <= RDaddr_i;
      funct_o <= funct_i;
   end
end

endmodule
