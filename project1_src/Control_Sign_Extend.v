module Control_Sign_Extend(
	RegDst_i,
	ALUSrc_i,
	ALUOp_i,
	Memory_write_i,
	Memory_read_i,
	MemtoReg_i,
	RegWrite_i,
	Control_Signal_o
);

input	RegDst_i,ALUSrc_i,Memory_write_i,Memory_read_i,MemtoReg_i,RegWrite_i,MemtoReg_i;
input	[1:0] ALUOp_i;
output	[31:0] Control_Signal_o;

assign	Control_Signal_o = {24'b0,RegDst_i
                                    ,ALUSrc_i
                                    ,ALUOp_i
                                    ,Memory_write_i
                                    ,Memory_read_i
                                    ,MemtoReg_i
                                    ,RegWrite_i};

endmodule