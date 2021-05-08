`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:41:28 04/28/2021 
// Design Name: 
// Module Name:    left_shift 
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
module left_shift(
    shiftIn,
    shiftOut
    );
	 `include "params.v"
	 
	 input [DATA_BUS_WIDTH - 1:0] shiftIn;
    output [DATA_BUS_WIDTH - 1:0] shiftOut;
	 
	 assign shiftOut[DATA_BUS_WIDTH - 1:2] = shiftIn[DATA_BUS_WIDTH - 3:0];
	 assign shiftOut[1:0] = 2'b0;

endmodule

module pc_shifter(
	 shiftIn,
	 shiftOut
	 );
	 `include "params.v"
	 
	 input [INSTRUCTION_WIDTH - WIDTH_OPCODE:0] shiftIn;
	 output [INSTRUCTION_WIDTH - WIDTH_OPCODE + 2:0] shiftOut;
	 
	 assign shiftOut[INSTRUCTION_WIDTH - WIDTH_OPCODE + 2:2] = shiftIn[INSTRUCTION_WIDTH - WIDTH_OPCODE:0];
	 assign shiftOut[1:0] = 2'b0;

endmodule
