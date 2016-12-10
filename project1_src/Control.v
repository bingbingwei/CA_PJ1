module Control
(
	Op_i,
	Control_o,
	Branch_o,
	Jump_o
);

input			[5:0] Op_i;
wire			ALUSrc,RegWrite,RegDst,MemtoReg,Memory_write, Memory_read;
wire			[1:0] ALUOp;

output			[31:0] Control_o;

assign			RegDst=(Op_i==6'b000000)?   1'b1:1'b0;     //R-type-->rd : I-type-->rt
assign			RegWrite=(Op_i==6'b000000                  //R-type
							|| Op_i==6'b001000                     //addi       
							|| Op_i==6'b100011)? 1'b1:1'b0;        //lw
assign			ALUSrc=(Op_i==6'b000000)?   1'b0:1'b1;     //R-type : I-type
assign			MemtoReg=(Op_i==6'b100011)? 1'b1:1'b0;     //lw
assign			Memory_write=(Op_i==6'b101011)? 1'b1:1'b0; //sw
assign			Memory_read=(Op_i==6'b100011)? 1'b1:1'b0;  //lw
assign			ALUOp=(Op_i==6'b000000)? 2'b00:            //R-type
						     (Op_i==6'b100011 || Op_i==6'b101011)? 2'b01://lw sw :ADD
						     (Op_i==6'b001101)? 2'b10://ori :OR
						     (Op_i==6'b000100)? 2'b11://beq :SUB
						      2'b00;

assign			Control_o = {24'd0,RegDst,ALUSrc,ALUOp,Memory_write,Memory_read,MemtoReg,RegWrite};	

//assign branch and jump

endmodule
