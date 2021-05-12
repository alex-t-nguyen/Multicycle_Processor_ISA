`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:50:26 04/28/2021 
// Design Name: 
// Module Name:    mux2to1 
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
module addr_mux2(
	 data0,
	 data1,
	 select,
	 dataOut
    );
	 `include "params.v"
	 
	 input [ADDRESS_BUS_WIDTH - 1:0] data0;
	 input [ADDRESS_BUS_WIDTH - 1:0] data1;
	 input select;
	 output [ADDRESS_BUS_WIDTH - 1:0] dataOut;
	 
	 assign dataOut = select ? data1 : data0;

endmodule

module data_mux2(
	data0,
	data1,
	select,
	dataOut
	);
	`include "params.v"
	
	input [DATA_BUS_WIDTH - 1:0] data0;
	input [DATA_BUS_WIDTH - 1:0] data1;
	input select;
	output [DATA_BUS_WIDTH - 1:0] dataOut;
	
	assign dataOut = select ? data1 : data0;

endmodule

module dest_reg_mux2(
	 data0,
	 data1,
	 select,
	 dataOut
	 );
	 `include "params.v"
	 
	 input [REGFILE_ADDR_BITS - 1:0] data0;
	 input [REGFILE_ADDR_BITS - 1:0] data1;
	 input select;
	 output [REGFILE_ADDR_BITS - 1:0] dataOut;
	 
	 assign dataOut = select ? data1 : data0;
	 
endmodule

	 
	 
	 
