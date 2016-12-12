module Forwarding_Unit
(
    Regdst_i_WB,
    Regdst_i_M,
    EX_RSaddr_i,
    EX_RTaddr_i,
    ID_RSaddr_i,
    ID_RTaddr_i,
    Stage4_RegWrite_i,
    Stage3_RegWrite_i,
    mux7_o,
    mux6_o,
    mux9_o,
    mux10_o
);

input        Stage4_RegWrite_i, Stage3_RegWrite_i;
input  [4:0] EX_RSaddr_i, EX_RTaddr_i, ID_RSaddr_i, ID_RTaddr_i, Regdst_i_WB, Regdst_i_M;
output [1:0] mux7_o, mux6_o;
output       mux9_o, mux10_o;

//RS
assign mux6_o = ((Stage3_RegWrite_i == 1) && (Regdst_i_M != 0) && (Regdst_i_M == EX_RSaddr_i))? 2'b10://EX-hazard
                ((Stage4_RegWrite_i == 1) && (Regdst_i_WB != 0) && (Regdst_i_M != EX_RSaddr_i) && (Regdst_i_WB == EX_RSaddr_i))? 2'b01:
                2'b00;
//RT
assign mux7_o = ((Stage3_RegWrite_i == 1) && (Regdst_i_M != 0) && (Regdst_i_M == EX_RTaddr_i))? 2'b10://EX-hazard
                ((Stage4_RegWrite_i == 1) && (Regdst_i_WB != 0) && (Regdst_i_M != EX_RTaddr_i) && (Regdst_i_WB == EX_RTaddr_i))? 2'b01:2'b00;               
  
assign mux9_o = ((Stage4_RegWrite_i == 1) && (Regdst_i_WB != 0)  && (Regdst_i_WB == ID_RSaddr_i))? 1 : 0;
assign mux10_o = ((Stage4_RegWrite_i == 1) && (Regdst_i_WB != 0)  && (Regdst_i_WB == ID_RTaddr_i))? 1 : 0;

                
endmodule
