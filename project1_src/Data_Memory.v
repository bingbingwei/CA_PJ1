module Data_Memory
(
   clk_i,
	address_i,
	Memory_write_i,
	Memory_read_i,
	write_data_i,
	read_data_o
);

input             clk_i;
input	   [31:0]	address_i;
input	            Memory_write_i;
input	            Memory_read_i;
input	   [31:0]	write_data_i;
output	[31:0]	read_data_o;

reg		[7:0]	memory	[0:31];
//reg      [31:0]   read_data_o;

assign read_data_o = (Memory_read_i) ? memory[address_i] : 0;

always@(posedge clk_i) begin
   if(Memory_write_i)
      memory[address_i] <= write_data_i[7:0]; 
end

/*always@(address_i, Memory_write_i, Memory_read_i, write_data_i) begin
   if(Memory_write_i == 1'b1) 
      memory[address_i] <= write_data_i;
   if(Memory_read_i == 1'b1)
      read_data_o <= memory[address_i];
   else
      read_data_o <= 32'd0;

end   */

	
endmodule
