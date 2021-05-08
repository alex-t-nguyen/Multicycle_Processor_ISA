`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:07:15 05/02/2021
// Design Name:   instruction_ram
// Module Name:   C:/Users/Niem/Documents/AlexDocs/Computer Architecture/ComputerArchProject/instruction_ram_tb.v
// Project Name:  ComputerArchProject
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: instruction_ram
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module instruction_ram_tb;

	// Inputs
	reg clk;
	reg [9:0] address;
	reg memRead;
	reg memWrite;

	// Outputs
	wire [18:0] data;

	// Instantiate the Unit Under Test (UUT)
	instruction_ram uut (
		.clk(clk), 
		.address(address), 
		.memRead(memRead), 
		.memWrite(memWrite), 
		.data(data)
	);

	integer c;
	
	initial begin
		// Initialize Inputs
		clk = 0;
		address = 0;
		memRead = 0;
		memWrite = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		for(c = 0; c <= 40; c = c + 1)
		begin
			clk <= c;
			memRead = 1;
			memWrite = 0;
			address = 10'd516;
			#100;
		end
	end
      
endmodule

