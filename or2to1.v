`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:55:01 05/13/2021 
// Design Name: 
// Module Name:    or2to1 
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
module or2to1(
    data_in1,
    data_in2,
    data_out,
	 enable
    );
	 
	 input data_in1;
	 input data_in2;
	 output reg data_out;
	 input enable;
	 
	 always @ (*) begin
	 if(enable)
		data_out = data_in1 | data_in2;
	 end

endmodule
