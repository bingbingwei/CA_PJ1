module Data_memory
(
	address_i,
	Memory_write_i,
	Memory_read_i,
	write_data_i,
	read_data_o
);

input	   [31:0]	address_i;
input	            Memory_write_i;
input	            Memory_read_i;
input	   [31:0]	write_data_i;
output	[31:0]	read_data_o;

reg		[31:0]	memory	[0:255];

assign read_data_o = 32'd0;

//why right shift???

assign memory[address_i>>2] = (Memory_write_i == 1'b1) ? write_data_i : 0;
assign read_data_o = (Memory_read_i == 1'b1) ? memory[address_i>>2] : 0;
	
endmodule
