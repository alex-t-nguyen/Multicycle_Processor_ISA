`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   12:19:03 05/02/2021
// Design Name:   control
// Module Name:   C:/Users/Niem/Documents/AlexDocs/Computer Architecture/ComputerArchProject/control_tb.v
// Project Name:  ComputerArchProject
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: control
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module control_tb;

	// Inputs
	reg clk;
	reg reset;
	//reg [18:0] instruction;
	reg alu_zero;
	reg [4:0] opcode;

	// Outputs
	wire RegDst;
	wire ALUSrcA;
	wire [1:0] ALUSrcB;
	wire RegWrite;
	wire MemToReg;
	wire IRWrite;
	wire MemWrite;
	wire MemRead;
	wire PCWrite;
	wire [2:0] ALUOp;
	wire [1:0] PCSource;
	wire PCWriteCond;
	wire mem_select;

	// Instantiate the Unit Under Test (UUT)
	control uut (
		.clk(clk), 
		.reset(reset), 
		//.instruction(instruction), 
		.RegDst(RegDst), 
		.ALUSrcA(ALUSrcA), 
		.ALUSrcB(ALUSrcB), 
		.RegWrite(RegWrite), 
		.MemToReg(MemToReg), 
		.IRWrite(IRWrite), 
		.MemWrite(MemWrite), 
		.MemRead(MemRead), 
		.PCWrite(PCWrite), 
		.ALUOp(ALUOp), 
		.PCSource(PCSource), 
		.PCWriteCond(PCWriteCond), 
		.mem_select(mem_select), 
		.alu_zero(alu_zero), 
		.opcode(opcode)
	);

	integer c;
	
	initial begin
		// Initialize Inputs
		clk = 1;
		reset = 1;
		//instruction = 0;
		alu_zero = 0;
		opcode = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		for (c = 0; c <= 12; c = c + 1)
		begin
			clk <= c;
			//instruction <= 19'h07600;	// Program 1 -> Store result in 0x30 (decimal 48)
			reset <= 0;
			alu_zero <= 0;
			opcode <= 5'b01001;
			#100;
		end
		
	end
      
endmodule

