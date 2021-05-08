`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:46:03 04/30/2021 
// Design Name: 
// Module Name:    regfile 
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
module regfile(
    read_address1,
    read_address2,
    read_data1,
    read_data2,
    write_address,
    write_data,
	 write_enable,
	 clk
    );
	 `include "params.v";
	 
	 input [REGFILE_ADDR_BITS - 1:0] read_address1;
    input [REGFILE_ADDR_BITS - 1:0] read_address2;
    output [DATA_BUS_WIDTH - 1:0] read_data1;
    output [DATA_BUS_WIDTH - 1:0] read_data2;
    input [REGFILE_ADDR_BITS - 1:0] write_address;
    input [DATA_BUS_WIDTH - 1:0] write_data;
	 input write_enable;
	 input clk;

	 reg [WIDTH_REGISTER_FILE - 1:0] regfile [REGFILE_ADDR_BITS - 1:0];
	 always @ (negedge clk)
	 begin
		if(write_enable)
			regfile[write_address] <= write_data;
	 end
	 
	 assign read_data1 = read_address1 ? regfile[read_address1] : 64'b0;
	 assign read_data2 = read_address2 ? regfile[read_address2] : 64'b0;
	 
endmodule
