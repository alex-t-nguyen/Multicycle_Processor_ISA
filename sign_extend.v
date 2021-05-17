`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:10:52 04/28/2021 
// Design Name: 
// Module Name:    sign_extend 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module sign_extend(
    imm,
    out
    );
	 `include "params.v";
	 
	 input [IMMEDIATE_WIDTH - 1:0] imm;
    output [DATA_BUS_WIDTH - 1:0] out;
	 
	 reg [DATA_BUS_WIDTH - 1:0] extendedResult;
	 
	 always @ (imm)
	 begin
		extendedResult[IMMEDIATE_WIDTH - 1:0] = imm[IMMEDIATE_WIDTH - 1:0];
		extendedResult[DATA_BUS_WIDTH - 1: IMMEDIATE_WIDTH] = {53{imm[IMMEDIATE_WIDTH - 1]}};
	 end
	 
	 assign out[DATA_BUS_WIDTH - 1:0] = extendedResult[DATA_BUS_WIDTH - 1:0];
endmodule
