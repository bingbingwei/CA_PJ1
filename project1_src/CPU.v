module CPU
(
    clk_i, 
    rst_i,
    start_i
);

// Ports
input               clk_i;
input               rst_i;
input               start_i;

wire                [31:0] inst_addr,inst;
wire                [31:0] ALU_output,mux5_output,mux7_output;          
wire                [4:0]  mux8_output;
wire                Stage3_RegWrite_output,Stage4_RegWrite_output;

wire [31:0] Stage3_data1, Reg_RSdata_output, Reg_RTdata_output;
wire [4:0]  Stage3_RDaddr_output, Stage4_RDaddr_output;

Control Control(
    .Op_i           (inst[31:26]),
    .RegDst_o       (Stage2.RegDst_i_2),
    .ALUOp_o        (Stage2.ALUOp_i_2), //0 for R-type ; 1 for I-type
    .ALUSrc_o       (Stage2.ALUSrc_i_2),
    .RegWrite_o     (Registers.RegWrite_i),
    .Memory_write_o (Data_Memory.Memory_write_i),
    .Memory_read_o  (Data_Memory.Memory_read_i),
    .MemtoReg_o     (mux5.select_i)
);

Adder Add_PC(
    .data1_in   (inst_addr),
    .data2_in   (32'd4),
    .data_o     (PC.pc_i)
);

PC PC(
    .clk_i      (clk_i),
    .rst_i      (rst_i),
    .start_i    (start_i),
    .pc_i       (Add_PC.data_o),
    .pc_o       (inst_addr)
);

Instruction_Memory Instruction_Memory(
    .addr_i     (inst_addr), 
    .instr_o    (Stage1.inst_i)
);

Registers Registers(
    .clk_i      (clk_i),
    .RSaddr_i   (inst[25:21]),
    .RTaddr_i   (inst[20:16]),
    .RDaddr_i   (Stage4_RDaddr_output),//three line -> use wire
    .RDdata_i   (mux5_output),
    .RegWrite_i (Stage4_RegWrite_output), 
    .RSdata_o   (Reg_RSdata_output),//three line -> use wire
    .RTdata_o   (Reg_RTdata_output)//three line -> use wire
);

MUX5 mux8(
    .data1_i    (Stage2_RTaddr_output),//four line -> use wire
    .data2_i    (Stage2.RDaddr_o),
    .select_i   (Stage2.RegDst_o_2),
    .data_o     (mux8_output)
);

MUX32 mux4(
    .data1_i    (mux7_output),
    .data2_i    (Stage2.Sign_extend_o),
    .select_i   (Stage2.ALUSrc_o_2),
    .data_o     (ALU.data2_i)
);

Sign_Extend Sign_Extend(
    .data_i     (inst[15:0]),
    .data_o     (Stage2.Sign_extend_i)
);

ALU ALU(
    .data1_i    (mux6.data_o),
    .data2_i    (mux4.data_o),
    .ALUCtrl_i  (ALU_Control.ALUCtrl_o),
    .data_o     (ALU_output)
);

ALU_Control ALU_Control(
    .funct_i    (inst[5:0]),
    .ALUOp_i    (Stage2.ALUOp_o_2),
    .ALUCtrl_o  (ALU.ALUCtrl_i)
);

Data_Memory Data_Memory(
    .address_i      (Stage3_data1),
    .Memory_write_i (Stage3.Memory_write_o_3),
    .Memory_read_i  (Stage3.Memory_read_o_3),
    .write_data_i   (Stage3.mux7_output_data_o),
    .read_data_o    (Stage4.Data1_i)
);

MUX32 mux5(
    .data1_i(Stage4.Data1_o),//0
    .data2_i(Stage4.Data2_o),//1
    .select_i(Stage4.MemtoReg_o_4),
    .data_o(mux5_output)
);

MUX32v3 mux6(
    .data1_i(Stage2.RSdata_o),
    .data2_i(mux5_output),
    .data3_i(Stage3_data1),//four line -> use wire
    .select_i(Forwarding_Unit.mux6_o),
    .data_o(ALU.data1_i)
);

MUX32v3 mux7(
    .data1_i(Stage2.RTdata_o),
    .data2_i(mux5_output),
    .data3_i(Stage3_data1),
    .select_i(Forwarding_Unit.mux7_o),
    .data_o(mux7_output)
);

Forwarding_Unit Forwarding_Unit(
    .Regdst_i_WB(Stage4_RDaddr_output),//three line -> use wire
    .Regdst_i_M(Stage3_RDaddr_output),//three line -> use wire
    .RSaddr_i(Stage2.RSaddr_o),
    .RTaddr_i(Stage2_RTaddr_output),//four line -> use wire
    .Stage4_Regwrite_i(Stage4_RegWrite_output),
    .Stage3_RegWrite_i(Stage3_RegWrite_output),
    .mux7_o(mux7.select_i),
    .mux6_o(mux6.select_i)
);

Hazard_Detection_Unit HD_Unit{
	.RTaddr_i(Stage2_RTaddr_output),//four line -> use wire

};

Equal Euqal{
	.data1_i(Reg_RSdata_output),//three line -> use wire
	.data2_i(Reg_RTdata_output),//three line -> use wire
	.data_o()

};

Stage4 Stage4(
    //WB
    .RegWrite_i_4(Stage3_RegWrite_output),
    .RegWrite_o_4(Stage4_RegWrite_output),//three line -> use wire
    .MemtoReg_i_4(Stage3.MemtoReg_o_3),
    .MemtoReg_o_4(mux5.select_i),
    //clk
    .clk_i(clk_i),
    //other 3*2
    .Data1_i(Data_Memory.read_data_o),
	.Data1_o(mux5.data1_i),
    .Data2_i(Stage3_data1),//four line -> use wire
	.Data2_o(mux5.data2_i),
    .RDaddr_i(Stage3_RDaddr_output),//three line -> use wire
    .RDaddr_o(Stage4_RDaddr_output)//three line -> use wire***
);

Stage3 Stage3(
    //WB
    .RegWrite_i_3(Stage2.RegWrite_o_2),
    .RegWrite_o_3(Stage3_RegWrite_output),
    .MemtoReg_i_3(Stage2.MemtoReg_o_2),
    .MemtoReg_o_3(Stage4.MemtoReg_i_4),
    //M
    .Memory_write_i_3(Stage3.Memory_write_o_2),
    .Memory_write_o_3(Data_Memory.Memory_write_i),
    .Memory_read_i_3(Stage3.Memory_read_o_2),
    .Memory_read_o_3(Data_Memory.Memory_read_i).
    //clk
    .clk_i(clk_i),
    //other 3*2
    .Data1_i(ALU_ouput),
    .Data1_o(Stage3_data1),//four line -> use wire
    .mux7_output_data_i(mux7_output),//three line -> use wire
    .mux7_output_data_o(Data_Memory.write_data_i),
	.RDaddr_i(mux8_output),
    .RDaddr_o(Stage3_RDaddr_output)//three line -> use wire
);

Stage2 Stage2(
    //WB
    .RegWrite_i_2(Control.RegWrite_o),
    .RegWrite_o_2(Stage3.RegWrite_i_3),
    .MemtoReg_i_2(Control.MemtoReg_o),
    .MemtoReg_o_2(Stage3.MemtoReg_i_3),
    //M
    .Memory_write_i_2(Control.Memory_write_o),
    .Memory_write_o_2(Stage3.Memory_write_i_3),
    .Memory_read_i_2(Control.Memory_read_o),
    .Memory_read_o_2(Stage3.Memory_read_i_3),
    //EX
    .ALUSrc_i_2(Control.ALUSrc_o),
    .ALUOp_i_2(Control.ALUOp_o),
    .RegDst_i_2(Control.RegDst_o),
    .ALUSrc_o_2(mux4.select_i),
    .ALUOp_o_2(ALU_Control.ALUOp_i),
    .RegDst_o_2(mux8.select_i),
    //clk
    .clk_i(clk_i),
	
    //other 7*2 -> 6*2 (有一條可以不用理他)
    .RSdata_i(Reg_RSdata_output),//three line -> use wire
    .RSdata_o(mux6.data1_i),
    .RTdata_i(Reg_RTdata_output),//three line -> use wire
    .RTdata_o(mux7.data1_i),
    
	.Sign_extend_i(Sign_Extend.data_o),
    .Sign_extend_o(mux4.data2_i),
    
	.RSaddr_i(inst[25:21]),
	.RSaddr_o(Forwarding_Unit.RSaddr_i),
	.RTaddr_i(inst[20:16]),
	.RTaddr_o(Stage2_RTaddr_output),//four line -> use wire
	.RDaddr_i(inst[15:11]),
	.RDaddr_o(mux8.data2_i)
);

Stage1 Stage1{
	.inst_i(Instruction_Memory.instr_o),
	.inst_o(inst)
};

endmodule
