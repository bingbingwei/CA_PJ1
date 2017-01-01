module PC
(
    clk_i,
    start_i,
    HD_i,
    pc_i,
    pc_o
);

// Ports
input               clk_i;
input               start_i;
input               HD_i; // don't know what can do?
input   [31:0]      pc_i;
output  [31:0]      pc_o;

// Wires & Registers
reg     [31:0]      pc_o;


always@(posedge clk_i) begin
    if(HD_i)
       pc_o <= pc_o;
    else if(start_i)
        pc_o <= pc_i;
    else
        pc_o <= pc_o;
end

endmodule
