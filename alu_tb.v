`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   20:12:41 05/02/2021
// Design Name:   alu
// Module Name:   C:/Users/Niem/Documents/AlexDocs/Computer Architecture/ComputerArchProject/alu_tb.v
// Project Name:  ComputerArchProject
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: alu
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module alu_tb;

	// Inputs
	reg [63:0] srcA;
	reg [63:0] srcB;
	reg [2:0] ALU_Op;

	// Outputs
	wire [63:0] result;
	wire zero;

	// Instantiate the Unit Under Test (UUT)
	alu uut (
		.srcA(srcA), 
		.srcB(srcB), 
		.ALU_Op(ALU_Op), 
		.result(result), 
		.zero(zero)
	);
	integer c;
	
	initial begin
		// Initialize Inputs
		srcA = 0;
		srcB = 0;
		ALU_Op = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		srcA = 10'd512;
		srcB = 4;
		ALU_Op = 0;
	end
      
endmodule

