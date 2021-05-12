`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:17:23 05/01/2021
// Design Name:   data_ram
// Module Name:   C:/Users/Niem/Documents/AlexDocs/Computer Architecture/ComputerArchProject/data_ram_tb.v
// Project Name:  ComputerArchProject
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: data_ram
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module data_ram_tb;

	// Inputs
	reg clk;
	reg [9:0] address;
	reg memRead;
	reg memWrite;
	reg [63:0] writeData;
	reg cs;

	// Outputs
	wire [63:0] readData;

	// Instantiate the Unit Under Test (UUT)
	data_ram uut (
		.clk(clk), 
		.address(address), 
		.memRead(memRead), 
		.memWrite(memWrite), 
		.writeData(writeData), 
		.readData(readData), 
		.cs(cs)
	);

	integer c;
	initial begin
		// Initialize Inputs
		clk = 0;
		address = 0;
		memRead = 0;
		memWrite = 1;
		writeData = 64'd10;
		cs = 1;

		// Wait 100 ns for global reset to finish
		#100;
      
		// Add stimulus here
		for (c = 0; c <= 12; c = c + 1)
		begin
			clk <= c;
			address <= 12'd48;	// Program 1 -> Store result in 0x30 (decimal 48)
			#100;
		end
	end
      
endmodule

