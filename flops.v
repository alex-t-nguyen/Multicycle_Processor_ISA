`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:22:30 04/30/2021 
// Design Name: 
// Module Name:    flops 
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
module data_register(
    clk,
    in_data,
    out_data,
    enable
    );
	 `include "params.v";
	 
	 input clk;
    input [DATA_BUS_WIDTH - 1: 0] in_data;
    output reg [DATA_BUS_WIDTH - 1:0] out_data;
    input enable;

	 always @ (posedge clk)
	 begin
		if(enable)
			out_data <= in_data;
	 end

endmodule

module address_register(
	 clk,
	 in_data,
	 out_data,
	 enable
	 );
	 
	 `include "params.v";
	 
	 input clk;
	 input [ADDRESS_BUS_WIDTH - 1:0] in_data;
	 output reg [ADDRESS_BUS_WIDTH - 1:0] out_data;
	 input enable;
	 
	 always @ (posedge clk)
	 begin
		if (enable)
			out_data <= in_data;
	 end
	 
endmodule

module instruction_register(
	 clk,
	 in_data,
	 instruction,
	 enable
	 );
	 
	 `include "params.v";
	 
	 input clk;
	 input [INSTRUCTION_WIDTH - 1:0] in_data;
	 output reg [INSTRUCTION_WIDTH - 1:0] instruction;
	 input enable;
	 
	 always @ (posedge clk)
	 begin
		if (enable)
			instruction <= in_data;
	 end
	 
endmodule

	 
	 
	 
	 
	 
