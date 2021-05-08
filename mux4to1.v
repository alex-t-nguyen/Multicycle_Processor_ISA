`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:14:09 04/28/2021 
// Design Name: 
// Module Name:    mux4to1 
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
module addr_mux4(
    data0,
    data1,
	 data2,
	 data3,
    select,
    dataOut
    );
	 `include "params.v"

	 input [ADDRESS_BUS_WIDTH - 1:0] data0;
    input [ADDRESS_BUS_WIDTH - 1:0] data1;
	 input [ADDRESS_BUS_WIDTH - 1:0] data2;
    input [ADDRESS_BUS_WIDTH - 1:0] data3;
    input [1:0] select;
    output [ADDRESS_BUS_WIDTH - 1:0] dataOut;
	 
	 reg [ADDRESS_BUS_WIDTH - 1:0] dataBus;
	 always @ (*)
	 begin
		case (select)
			0: dataBus <= data0;
			1: dataBus <= data1;
			2: dataBus <= data2;
			3: dataBus <= data3;
		endcase
	 end
	 
	 assign dataOut = dataBus;

endmodule

module data_mux4(
	 data0,
	 data1,
	 data2,
	 data3,
	 select,
	 dataOut
	 );
	 
	 `include "params.v"
	 
	 input [DATA_BUS_WIDTH - 1:0] data0;
	 input [DATA_BUS_WIDTH - 1:0] data1;
	 input [DATA_BUS_WIDTH - 1:0] data2;
	 input [DATA_BUS_WIDTH - 1:0] data3;
	 input [1:0] select;
	 output [DATA_BUS_WIDTH - 1:0] dataOut;
	 
	 reg [DATA_BUS_WIDTH - 1:0] dataBus;
	 
	 always @ (*)
	 begin
		case (select)
			0: dataBus <= data0;
			1: dataBus <= data1;
			2: dataBus <= data2;
			3: dataBus <= data3;
		endcase
	 end
	 
	 assign dataOut = dataBus;

endmodule
