`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:06:11 05/01/2021
// Design Name:   Multi_Cycle_Computer
// Module Name:   C:/Users/Niem/Documents/AlexDocs/Computer Architecture/ComputerArchProject/Multi_Cycle_Computer_tb.v
// Project Name:  ComputerArchProject
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Multi_Cycle_Computer
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module Multi_Cycle_Computer_tb;

	// Inputs
	reg clk;
	reg reset;
	wire [63:0] program_out;

	// Instantiate the Unit Under Test (UUT)
	Multi_Cycle_Computer uut (
		.clk(clk), 
		.reset(reset), 
		.program_out(program_out)
	);

	integer c;
	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 0;
		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		for (c = 0; c <= 2; c = c + 1)
		begin
			clk <= c;
			reset <= 1;
			#100;
		end
		
		
		for (c = 0; c <= 10000; c = c + 1)
		begin
			clk <= c;
			reset <= 0;
			#100;
		end
	end
      
endmodule

