module Hazard_Detection_Unit(
   RTaddr_i,
   inst_i,
   Memory_read_i,
   HD_o_PC,
   HD_o_Stage1,
   HD_o_mux3
);

input    [4:0]    RTaddr_i;
input    [31:0]   inst_i;
input             Memory_read_i;
output            HD_o_PC, HD_o_Stage1, HD_o_mux3;
reg               HD_o_PC, HD_o_Stage1, HD_o_mux3;

always @(*) begin
   if(Memory_read_i == 1 && (RTaddr_i == inst_i[25:21] || RTaddr_i == inst_i[20:16])) begin
      HD_o_PC <= 1;
      HD_o_Stage1 <= 1;
      HD_o_mux3 <= 1;
   end   
   else begin 
      HD_o_PC <= 0;
      HD_o_Stage1 <= 0;
      HD_o_mux3 <= 0;
   end   
end

endmodule
