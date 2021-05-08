`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:37:22 05/02/2021
// Design Name:   addr_mux4
// Module Name:   C:/Users/Niem/Documents/AlexDocs/Computer Architecture/ComputerArchProject/addr_mux4_tb.v
// Project Name:  ComputerArchProject
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: addr_mux4
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module addr_mux4_tb;

	// Inputs
	reg [9:0] data0;
	reg [9:0] data1;
	reg [9:0] data2;
	reg [9:0] data3;
	reg [1:0] select;

	// Outputs
	wire [9:0] dataOut;

	// Instantiate the Unit Under Test (UUT)
	addr_mux4 uut (
		.data0(data0), 
		.data1(data1), 
		.data2(data2), 
		.data3(data3), 
		.select(select), 
		.dataOut(dataOut)
	);

	initial begin
		// Initialize Inputs
		data0 = 0;
		data1 = 0;
		data2 = 0;
		data3 = 0;
		select = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		data3 = 10'd512;
		select = 3;
	end
      
endmodule

