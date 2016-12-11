module CPU
(
    clk_i, 
    start_i
);

// Ports
input               clk_i;
input               start_i;

wire  [31:0]   inst, inst_addr, instReadData;
wire  [31:0]   controlSignal_o;
wire           branch_o, jump_o, equal_o;

wire  [31:0]   Add_PC_o;

wire           HD_o_PC, HD_o_Stage1, HD_o_mux3;   
wire  [31:0]   PC_i;
wire  [31:0]   jump_addr;

wire  [31:0]   Adder_o;
wire  [31:0]   signExtend_o;
wire  [31:0]   ALU_o;
wire  [31:0]   mux1_o, mux3_o, mux4_o, mux5_o, mux6_o, mux7_o;
wire  [4:0]    mux8_o;

wire  [31:0]   Stage1_PC_o;
wire  [31:0]   Stage2_signExtend_o, Stage2_RSdata_o, Stage2_RTdata_o;
wire  [4:0]    Stage2_RTaddr_o, Stage2_RDaddr_o, Stage2_RSaddr_o;
wire  [5:0]    Stage2_funct_o;
wire  [1:0]    Stage2_ALUOp_o;
wire           Stage2_RegDst_o, Stage2_ALUSrc_o;
wire           Stage2_MemRead_o, Stage2_MemWrite_o, Stage2_MemtoReg_o, Stage2_RegWrite_o;
wire  [31:0]   Stage3_addr_o, Stage3_WriteData_o;
wire           Stage3_MemWrite_o, Stage3_MemRead_o, Stage3_RegWrite_o, Stage3_MemtoReg_o;
wire  [4:0]    Stage3_RDaddr_o;
wire  [31:0]   Stage4_Data1_o, Stage4_Data2_o;
wire  [4:0]    Stage4_RDaddr_o;
wire           Stage4_RegWrite_o, Stage4_MemtoReg_o;

wire  [31:0]   RSdata, RTdata;

wire  [2:0]    ALUCtrl_o;
wire  [31:0]   Data_Memory_o;

wire  [1:0]    Forwarding_Unit_mux6_o, Forwarding_Unit_mux7_o;

Control Control(
    .Op_i           (inst[31:26]),
    .Control_o      (controlSignal_o),
    .Branch_o       (branch_o),
    .Jump_o         (jump_o)
);


Adder Add_PC(
    .data1_in   (inst_addr),
    .data2_in   (32'd4),
    .data_o     (Add_PC_o)
);

PC PC(
    .clk_i      (clk_i),
    .start_i    (start_i),
    .HD_i       (HD_o_PC),
    .pc_i       (PC_i),
    .pc_o       (inst_addr)
);

Instruction_Memory Instruction_Memory(
    .addr_i     (inst_addr), 
    .instr_o    (instReadData)
);

MUX32 mux1(
    .data1_i    (Add_PC_o), //0
    .data2_i    (Adder_o), //1
    //注意可能會錯
    .select_i   (branch_o && equal_o),
    .data_o     (mux1_o)
);

MUX32 mux2(
    .data1_i    (mux1_o),//0
    .data2_i    (jump_addr),//1
    .select_i   (jump_o),
    .data_o     (PC_i)
);

Adder Adder(
    .data1_in   (signExtend_o << 2),
    .data2_in   (Stage1_PC_o),
    .data_o     (Adder_o)
);

Registers Registers(
    .clk_i      (clk_i),
    .RSaddr_i   (inst[25:21]),
    .RTaddr_i   (inst[20:16]),
    .RDaddr_i   (Stage4_RDaddr_o),
    .RDdata_i   (mux5_o),
    .RegWrite_i (Stage4_RegWrite_o), 
    .RSdata_o   (RSdata),//three line -> use wire
    .RTdata_o   (RTdata)//three line -> use wire
);

MUX5 mux8(
    .data1_i    (Stage2_RTaddr_o),//four line -> use wire
    .data2_i    (Stage2_RDaddr_o),
    .select_i   (Stage2_RegDst_o),
    .data_o     (mux8_o)
);

MUX32 mux4(
    .data1_i    (mux7_o),
    .data2_i    (Stage2_signExtend_o),
    .select_i   (Stage2_ALUSrc_o),
    .data_o     (mux4_o)
);

Sign_Extend Sign_Extend(
    .data_i     (inst[15:0]),
    .data_o     (signExtend_o)
);

ALU ALU(
    .data1_i    (mux6_o),
    .data2_i    (mux4_o),
    .ALUCtrl_i  (ALUCtrl_o),
    .data_o     (ALU_o)
);

ALU_Control ALU_Control(
    .funct_i    (Stage2_funct_o),
    .ALUOp_i    (Stage2_ALUOp_o),
    .ALUCtrl_o  (ALUCtrl_o)
);

Data_Memory Data_Memory(
    .clk_i          (clk_i),
    .address_i      (Stage3_addr_o),
    .Memory_write_i (Stage3_MemWrite_o),
    .Memory_read_i  (Stage3_MemRead_o),
    .write_data_i   (Stage3_WriteData_o),
    .read_data_o    (Data_Memory_o)
);

MUX32 mux5(
    .data1_i(Stage4_Data2_o),//0, Stage4.Data2_o
    .data2_i(Stage4_Data1_o),//1, Stage4.Data1_o
    .select_i(Stage4_MemtoReg_o),
    .data_o(mux5_o)
);

MUX32v3 mux6(
    .data1_i(Stage2_RSdata_o),
    .data2_i(mux5_o),
    .data3_i(Stage3_addr_o),//four line -> use wire
    .select_i(Forwarding_Unit_mux6_o),
    .data_o(mux6_o)
);

MUX32v3 mux7(
    .data1_i(Stage2_RTdata_o),
    .data2_i(mux5_o),
    .data3_i(Stage3_addr_o),
    .select_i(Forwarding_Unit_mux7_o),
    .data_o(mux7_o)
);

Forwarding_Unit Forwarding_Unit(

    .Regdst_i_WB(Stage4_RDaddr_o),//three line -> use wire
    .Regdst_i_M(Stage3_RDaddr_o),//three line -> use wire
    .RSaddr_i(Stage2_RSaddr_o),
    .RTaddr_i(Stage2_RTaddr_o),//four line -> use wire
    .Stage4_RegWrite_i(Stage4_RegWrite_o),
    .Stage3_RegWrite_i(Stage4_RegWrite_o),
    .mux7_o(Forwarding_Unit_mux7_o),
    .mux6_o(Forwarding_Unit_mux6_o)
);

Stage4 Stage4(
    //WB
    .RegWrite_i_4(Stage3_RegWrite_o),
    .RegWrite_o_4(Stage4_RegWrite_o),//three line -> use wire
    .MemtoReg_i_4(Stage3_MemtoReg_o),
    .MemtoReg_o_4(Stage4_MemtoReg_o),
    //clk
    .clk_i(clk_i),
    //other 3*2
    .Data1_i(Data_Memory_o),
	.Data1_o(Stage4_Data1_o),
    .Data2_i(Stage3_addr_o),//four line -> use wire
	.Data2_o(Stage4_Data2_o),
    .RDaddr_i(Stage3_RDaddr_o),//three line -> use wire
    .RDaddr_o(Stage4_RDaddr_o)//three line -> use wire***
);

Stage3 Stage3(
    //WB
    .RegWrite_i_3(Stage2_RegWrite_o),
    .RegWrite_o_3(Stage3_RegWrite_o),
    .MemtoReg_i_3(Stage2_MemtoReg_o),
    .MemtoReg_o_3(Stage3_MemtoReg_o),
    //M
    .Memory_write_i_3(Stage2_MemWrite_o),
    .Memory_write_o_3(Stage3_MemWrite_o),
    .Memory_read_i_3(Stage2_MemRead_o),
    .Memory_read_o_3(Stage3_MemRead_o),
    //clk
    .clk_i(clk_i),
    //other 3*2
    .Data1_i(ALU_o),
    .Data1_o(Stage3_addr_o),//four line -> use wire
    .mux7_output_data_i(mux7_o),//three line -> use wire
    .mux7_output_data_o(Stage3_WriteData_o),
	 .RDaddr_i(mux8_o),
    .RDaddr_o(Stage3_RDaddr_o)//three line -> use wire
);

Stage2 Stage2(
    //WB
    .RegWrite_i_2(mux3_o[0]),
    .RegWrite_o_2(Stage2_RegWrite_o),
    .MemtoReg_i_2(mux3_o[1]),
    .MemtoReg_o_2(Stage2_MemtoReg_o),
    //M
    .Memory_write_i_2(mux3_o[3]),
    .Memory_write_o_2(Stage2_MemWrite_o),
    .Memory_read_i_2(mux3_o[2]),
    .Memory_read_o_2(Stage2_MemRead_o),
    //EX
    .ALUSrc_i_2(mux3_o[6]),
    .ALUOp_i_2(mux3_o[5:4]),
    .RegDst_i_2(mux3_o[7]),
    .ALUSrc_o_2(Stage2_ALUSrc_o),
    .ALUOp_o_2(Stage2_ALUOp_o),
    .RegDst_o_2(Stage2_RegDst_o),
    //clk
    .clk_i(clk_i),
    
    //other 7*2 -> 6*2 (有一條可以不用理他)
    .RSdata_i(RSdata),//three line -> use wire
    .RSdata_o(Stage2_RSdata_o),
    .RTdata_i(RTdata),//three line -> use wire
    .RTdata_o(Stage2_RTdata_o),
    
    .Sign_extend_i(signExtend_o),
    .Sign_extend_o(Stage2_signExtend_o),
    
    .RSaddr_i(inst[25:21]),
    .RSaddr_o(Stage2_RSaddr_o),
    .RTaddr_i(inst[20:16]),
    .RTaddr_o(Stage2_RTaddr_o),//four line -> use wire
    .RDaddr_i(inst[15:11]),
    .RDaddr_o(Stage2_RDaddr_o),

    //different from original
    .funct_i(inst[5:0]),
    .funct_o(Stage2_funct_o)
);

MUX32 mux3(
    .data1_i(controlSignal_o),//0, ControlSignal_i
    .data2_i(32'd0),//1, ZERO
    .select_i(HD_o_mux3),            //注意可能會錯優!!
    .data_o(mux3_o)//0:RegWrite_o 1:MemtoReg_o 2:Memory_read_o
                            //3:Memory_write_o [5:4]:ALUOp_o 6:ALUSrc_o
                            //7:RegDst_i [31:8]:0
);


Stage1 Stage1(
	.inst_i(instReadData),
	.inst_o(inst),
    .HD_i(HD_o_Stage1),
    .flush_i(jump_o || (branch_o && equal_o)),
    .data1_i(Add_PC_o),
    .data1_o_1(Stage1_PC_o),
    .clk_i(clk_i)
);

Hazard_Detection_Unit HD_Unit(
    .RTaddr_i(Stage2_RTaddr_o),//four line -> use wire
    .inst_i(inst),
    .Memory_read_i(Stage2_MemRead_o),
    .HD_o_PC(HD_o_PC),
    .HD_o_Stage1(HD_o_Stage1),
    .HD_o_mux3(HD_o_mux3)
);

Equal Equal(
    .data1_i(RSdata),//three line -> use wire
    .data2_i(RTdata),//three line -> use wire
    .data_o(equal_o)
);

JumpAddr JumpAddr(
    .inst_26(inst[25:0]),
    .mux1_o_3(mux1_o[31:28]),
    .jump_addr(jump_addr)    
);

endmodule
