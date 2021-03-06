`define CYCLE_TIME 50            

module TestBench;

reg                Clk;
reg                Start;
integer            i, outfile, counter;
integer            stall, flush;

always #(`CYCLE_TIME/2) Clk = ~Clk;    

CPU CPU(
    .clk_i  (Clk),
    .start_i(Start)
);
  
initial begin
    counter = 0;
    stall = 0;
    flush = 0;
    
    // initialize instruction memory
    for(i=0; i<256; i=i+1) begin
        CPU.Instruction_Memory.memory[i] = 32'b0;
    end
    
    // initialize data memory
    for(i=0; i<32; i=i+1) begin
        CPU.Data_Memory.memory[i] = 8'b0;
    end    
        
    // initialize Register File
    for(i=0; i<32; i=i+1) begin
        CPU.Registers.register[i] = 32'b0;
    end

    CPU.PC.pc_o = 32'b0;
    
    CPU.HD_Unit.HD_o_PC = 0;
    CPU.HD_Unit.HD_o_Stage1 = 0;
    CPU.HD_Unit.HD_o_mux3 = 0;
    
    CPU.Stage1.inst_o = 32'b0;
    
    CPU.Stage2.RegWrite_o_2 = 0;
    CPU.Stage2.MemtoReg_o_2 = 0;
    CPU.Stage2.Memory_write_o_2 = 0;
    CPU.Stage2.Memory_read_o_2 = 0;
    CPU.Stage2.ALUSrc_o_2 = 0;
    CPU.Stage2.RegDst_o_2 = 0;
    CPU.Stage2.ALUOp_o_2 = 2'b0;
    CPU.Stage2.RSaddr_o = 5'b0;
    CPU.Stage2.RTaddr_o = 5'b0;
    CPU.Stage2.RDaddr_o = 5'b0;
    CPU.Stage2.RSdata_o = 32'b0;
    CPU.Stage2.RTdata_o = 32'b0;
    CPU.Stage2.Sign_extend_o = 32'b0;
    CPU.Stage2.funct_o = 6'b0;

    CPU.Stage3.RegWrite_o_3 = 0;
    CPU.Stage3.Memory_write_o_3 = 0;
    CPU.Stage3.MemtoReg_o_3 = 0;
    CPU.Stage3.Memory_read_o_3 = 0;
    CPU.Stage3.Data1_o = 32'b0;
    CPU.Stage3.mux7_output_data_o = 32'b0;
    CPU.Stage3.RDaddr_o = 5'b0; 
     
    CPU.Stage4.RegWrite_o_4 = 0;
    CPU.Stage4.MemtoReg_o_4 = 0;
    CPU.Stage4.Data1_o = 32'b0;
    CPU.Stage4.Data2_o = 32'b0;
    CPU.Stage4.RDaddr_o = 5'b0;

    
    // Load instructions into instruction memory
    $readmemb("instruction.txt", CPU.Instruction_Memory.memory);
    //$readmemb("Fibonacci_instruction.txt", CPU.Instruction_Memory.memory);
    
    $fdisplay(outfile, "%d%d%d%d%d", counter, Start, stall, flush, CPU.PC.pc_o);

    // Open output file
    outfile = $fopen("output.txt") | 1;
    
    // Set Input n into data memory at 0x00
    CPU.Data_Memory.memory[0] = 8'h5;       // n = 5 for example
    
    Clk = 1;
    //Reset = 0;
    Start = 0;
    
    #(`CYCLE_TIME/4) 
    //Reset = 1;
    Start = 1;
        
    
end
  
always@(posedge Clk) begin
    if(counter == 30)    // stop after 30 cycles
        $stop;

    // put in your own signal to count stall and flush
    // if(CPU.HazzardDetection.mux8_o == 1 && CPU.Control.Jump_o == 0 && CPU.Control.Branch_o == 0)stall = stall + 1;
    // if(CPU.HazzardDetection.Flush_o == 1)flush = flush + 1;  
    if(CPU.HD_Unit.HD_o_Stage1 == 1 && CPU.Control.Jump_o == 0 && CPU.Control.Branch_o == 0) 
       stall = stall + 1;
    if(CPU.Stage1.flush_i == 1)
       flush = flush + 1;

    /*$fdisplay(outfile, "=============================================================================================");
    $fdisplay(outfile, "cycle = %d\n", counter);
	$fdisplay(outfile, "Stage0:\n");
    $fdisplay(outfile, "\tPC:%d",CPU.PC.pc_o);
    $fdisplay(outfile, "\tinstrcuct :%b",CPU.Instruction_Memory.instr_o);*/

    //debug messages

    // print PC
    $fdisplay(outfile, "cycle = %d, Start = %d, Stall = %d, Flush = %d\nPC = %d", counter, Start, stall, flush, CPU.PC.pc_o);
    /*$fdisplay(outfile, "mux1 select = %d: %d, mux2 select = %d: %d",CPU.mux1.select_i,CPU.mux1.data_o,CPU.mux2.select_i,CPU.mux2.data_o);
    $fdisplay(outfile, "Instruction = | OP || RS|| RT|| RD||   imme  |\nInstruction = %b",CPU.Instruction_Memory.instr_o);
    $fdisplay(outfile, "Add_PC = %d, Adder = %d",CPU.inst_addr,CPU.Add_PC_o);
    $fdisplay(outfile, "Stage1:\n");
    $fdisplay(outfile, "\tPC:%d",CPU.PC.pc_o-4);
    $fdisplay(outfile, "\tinstrcuct :%b",CPU.Stage1.inst_o);
    $fdisplay(outfile, "\tdata1_o_1 :%b",CPU.Stage1.data1_o_1);
    $fdisplay(outfile, "\tControl_in:%b",CPU.Control.Op_i);
    $fdisplay(outfile, "\tControl_o :%b",CPU.Control.Control_o);

    $fdisplay(outfile, "PC:\n");
    $fdisplay(outfile, "\tpc_o      :%d",CPU.PC.pc_o);
    $fdisplay(outfile, "\tHD_i      :%b",CPU.PC.HD_i);

    $fdisplay(outfile, "mux3:\n");
    $fdisplay(outfile, "\tmux3_o    :%b",CPU.mux3_o);

    $fdisplay(outfile, "Stage2:\n");
    $fdisplay(outfile, "\tPC:%d",CPU.PC.pc_o-8);
    $fdisplay(outfile, "\tRegDst_o_2:%b",CPU.Stage2.RegDst_o_2);
    $fdisplay(outfile, "\tRS Data   :%b",CPU.Stage2.RSdata_o);
    $fdisplay(outfile, "\tRT Data   :%b",CPU.Stage2.RTdata_o);
    $fdisplay(outfile, "\timmediate :%b",CPU.Stage2.Sign_extend_o);
    $fdisplay(outfile, "\tRS Addr   :%b",CPU.Stage2.RSaddr_o);
    $fdisplay(outfile, "\tRT Addr   :%b",CPU.Stage2.RTaddr_o);
    $fdisplay(outfile, "\tRD Addr   :%b",CPU.Stage2.RDaddr_o);
    $fdisplay(outfile, "\tfunction  :%b",CPU.Stage2.funct_o);
    $fdisplay(outfile, "\tmemread   :%b",CPU.Stage2.Memory_read_i_2);  
    $fdisplay(outfile, "\tmemread   :%b",CPU.Stage2.Memory_read_o_2);  

    $fdisplay(outfile, "Hazard Detection:\n");
    $fdisplay(outfile, "\tPC        :%b",CPU.HD_Unit.HD_o_PC);
    $fdisplay(outfile, "\tStage1    :%b",CPU.HD_Unit.HD_o_Stage1);
    $fdisplay(outfile, "\tmux3      :%b",CPU.HD_Unit.HD_o_mux3);

    $fdisplay(outfile, "ALU:\n");
    $fdisplay(outfile, "\tALUCtrl_o :%b",CPU.ALUCtrl_o);
    $fdisplay(outfile, "\tALU data1 :%b",CPU.mux6_o);
    $fdisplay(outfile, "\tALU data2 :%b",CPU.mux4_o);

    $fdisplay(outfile, "Stage3:\n");
    $fdisplay(outfile, "\tPC:%d",CPU.PC.pc_o-12);
    $fdisplay(outfile, "\tMemWrite  :%b",CPU.Stage3.Memory_write_o_3);
    $fdisplay(outfile, "\tMem Read  :%b",CPU.Stage3.Memory_read_o_3);
    $fdisplay(outfile, "\tMemtoReg  :%b",CPU.Stage3.MemtoReg_o_3);
    $fdisplay(outfile, "\tRegWrite  :%b",CPU.Stage3.RegWrite_o_3);
    $fdisplay(outfile, "\tALUOutput :%b",CPU.Stage3.Data1_o);
    $fdisplay(outfile, "\tMux7Output:%b",CPU.Stage3.mux7_output_data_o);
    $fdisplay(outfile, "\tRD Addr   :%b",CPU.Stage3.RDaddr_o);
    
    $fdisplay(outfile, "Data Memory:\n");
    $fdisplay(outfile, "\taddress   :%b",CPU.Data_Memory.address_i);
    $fdisplay(outfile, "\tmem write :%b",CPU.Data_Memory.Memory_write_i);
    $fdisplay(outfile, "\tmem read  :%b",CPU.Data_Memory.Memory_read_i);
    $fdisplay(outfile, "\twrite data:%b",CPU.Data_Memory.write_data_i);
    $fdisplay(outfile, "\tread data :%b",CPU.Data_Memory.read_data_o);

    $fdisplay(outfile, "Stage4:\n");
    $fdisplay(outfile, "\tPC:%d",CPU.PC.pc_o-16);
    $fdisplay(outfile, "\tMemtoReg  :%b",CPU.Stage4.MemtoReg_o_4);
    $fdisplay(outfile, "\tRegWrite  :%b",CPU.Stage4.RegWrite_o_4);
    $fdisplay(outfile, "\tRD Addr   :%b",CPU.Stage4.RDaddr_o);
    $fdisplay(outfile, "\tLw Data   :%b",CPU.Stage4.Data1_o);
    $fdisplay(outfile, "\tALUOutput :%b",CPU.Stage4.Data2_o);
	 $fdisplay(outfile, "------");*/
	
    // print Registers
    $fdisplay(outfile, "Registers");
    $fdisplay(outfile, "R0(r0) = %d, R8 (t0) = %d, R16(s0) = %d, R24(t8) = %d", CPU.Registers.register[0], CPU.Registers.register[8] , CPU.Registers.register[16], CPU.Registers.register[24]);
    $fdisplay(outfile, "R1(at) = %d, R9 (t1) = %d, R17(s1) = %d, R25(t9) = %d", CPU.Registers.register[1], CPU.Registers.register[9] , CPU.Registers.register[17], CPU.Registers.register[25]);
    $fdisplay(outfile, "R2(v0) = %d, R10(t2) = %d, R18(s2) = %d, R26(k0) = %d", CPU.Registers.register[2], CPU.Registers.register[10], CPU.Registers.register[18], CPU.Registers.register[26]);
    $fdisplay(outfile, "R3(v1) = %d, R11(t3) = %d, R19(s3) = %d, R27(k1) = %d", CPU.Registers.register[3], CPU.Registers.register[11], CPU.Registers.register[19], CPU.Registers.register[27]);
    $fdisplay(outfile, "R4(a0) = %d, R12(t4) = %d, R20(s4) = %d, R28(gp) = %d", CPU.Registers.register[4], CPU.Registers.register[12], CPU.Registers.register[20], CPU.Registers.register[28]);
    $fdisplay(outfile, "R5(a1) = %d, R13(t5) = %d, R21(s5) = %d, R29(sp) = %d", CPU.Registers.register[5], CPU.Registers.register[13], CPU.Registers.register[21], CPU.Registers.register[29]);
    $fdisplay(outfile, "R6(a2) = %d, R14(t6) = %d, R22(s6) = %d, R30(s8) = %d", CPU.Registers.register[6], CPU.Registers.register[14], CPU.Registers.register[22], CPU.Registers.register[30]);
    $fdisplay(outfile, "R7(a3) = %d, R15(t7) = %d, R23(s7) = %d, R31(ra) = %d", CPU.Registers.register[7], CPU.Registers.register[15], CPU.Registers.register[23], CPU.Registers.register[31]);

    // print Data Memory
    $fdisplay(outfile, "Data Memory: 0x00 = %d", {CPU.Data_Memory.memory[3] , CPU.Data_Memory.memory[2] , CPU.Data_Memory.memory[1] , CPU.Data_Memory.memory[0] });
    $fdisplay(outfile, "Data Memory: 0x04 = %d", {CPU.Data_Memory.memory[7] , CPU.Data_Memory.memory[6] , CPU.Data_Memory.memory[5] , CPU.Data_Memory.memory[4] });
    $fdisplay(outfile, "Data Memory: 0x08 = %d", {CPU.Data_Memory.memory[11], CPU.Data_Memory.memory[10], CPU.Data_Memory.memory[9] , CPU.Data_Memory.memory[8] });
    $fdisplay(outfile, "Data Memory: 0x0c = %d", {CPU.Data_Memory.memory[15], CPU.Data_Memory.memory[14], CPU.Data_Memory.memory[13], CPU.Data_Memory.memory[12]});
    $fdisplay(outfile, "Data Memory: 0x10 = %d", {CPU.Data_Memory.memory[19], CPU.Data_Memory.memory[18], CPU.Data_Memory.memory[17], CPU.Data_Memory.memory[16]});
    $fdisplay(outfile, "Data Memory: 0x14 = %d", {CPU.Data_Memory.memory[23], CPU.Data_Memory.memory[22], CPU.Data_Memory.memory[21], CPU.Data_Memory.memory[20]});
    $fdisplay(outfile, "Data Memory: 0x18 = %d", {CPU.Data_Memory.memory[27], CPU.Data_Memory.memory[26], CPU.Data_Memory.memory[25], CPU.Data_Memory.memory[24]});
    $fdisplay(outfile, "Data Memory: 0x1c = %d", {CPU.Data_Memory.memory[31], CPU.Data_Memory.memory[30], CPU.Data_Memory.memory[29], CPU.Data_Memory.memory[28]});
	
    $fdisplay(outfile, "\n");
    
    counter = counter + 1;
          
end

  
endmodule
//test brench 要改
