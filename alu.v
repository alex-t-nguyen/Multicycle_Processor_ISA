`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:37:14 04/27/2021 
// Design Name: 
// Module Name:    alu 
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
module alu(
    srcA,
    srcB,
    ALU_Op,
    result,
    zero
    );
	 `include "params.v"
	 parameter MSB = DATA_BUS_WIDTH - 1;
	 input [MSB:0] srcA;
    input [MSB:0] srcB;
    input [ALU_OP_NUM_BITS - 1:0] ALU_Op;
    output [MSB:0] result;
    output zero;
	 
	 reg [DATA_BUS_WIDTH - 1:0] answer;
	 
	 // Calcluate ALU result
	 always @ (*)
	 begin
		answer = 64'd0;
		case (ALU_Op)
			0: answer = srcA + srcB;
			1: begin 
					answer = srcA + ((~srcB)+1);	// Take 2's complement of 10 and add for signed arithmetic 
					answer = (~answer)+1;	// Take 2's complement again to turn back into unsigned (ie. -10 + 1 = -9 -> 9)
				end
			default: answer <= 0;
		endcase
	 end

	 // Assign ALU result
	 assign zero = (answer <= srcB) ? 1 : 0;	// Compare unsigned answer (positive equivalent) with srcB to check if branching
	 
	 assign result = answer[MSB:0];
	 
endmodule
