module Hazard_Detection_Unit(
   RTaddr_i,
   inst_i,
   Memory_read_i,
   HD_o
);

input    [4:0]    RTaddr_i;
input    [31:0]   inst_i;
input             Memory_read_i;
output            HD_o;

assign HD_o = (inst_i[31:26] == 6'b100011 && RTaddr_i == inst_i[20:16] && Memory_read_i == 1)? 1 : //lw
              (inst_i[31:26] == 6'b000100)? 1 : //beq
              (inst_i[31:26] == 6'b000010)? 1 : 0; //jump

endmodule
