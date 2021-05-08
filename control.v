`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:03:03 04/22/2021 
// Design Name: 
// Module Name:    control 
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
module control(
    clk,
	 reset,
    //instruction,
    RegDst,
    ALUSrcA,
    ALUSrcB,
    RegWrite,
    MemToReg,
    IRWrite,
    MemWrite,
    MemRead,
    //DnotI,
	 PCWrite,
	 ALUOp,
	 PCSource,
	 PCWriteCond,
	 mem_select,
	 alu_zero,
	 opcode
    );
	 `include "params.v"
	 
	 parameter OPCODE_LSB = INSTRUCTION_WIDTH - WIDTH_OPCODE;
	
	 input clk;
	 input reset;
    //input [INSTRUCTION_WIDTH - 1:0] instruction;	// Pass entire instruction as parameter to control
	 input [WIDTH_OPCODE - 1: 0] opcode;
    output reg RegDst;
    output reg ALUSrcA;
    output reg [1:0] ALUSrcB;
    output reg RegWrite;
    output reg MemToReg;
    output reg IRWrite;
    output reg MemWrite;
    output reg MemRead;
    //output reg DnotI;
	 output reg PCWrite;
	 output reg [2:0] ALUOp;
	 output reg [1:0] PCSource;
	 output reg PCWriteCond;
	 output reg mem_select;
	 input alu_zero;
	 
	 //wire [WIDTH_OPCODE - 1:0] opcode;
	 //assign opcode = instruction[INSTRUCTION_WIDTH -1: OPCODE_LSB];	// Retrieve only opcode part of passed in instruction
	 
	 reg [NUM_STATE_BITS - 1:0] current_state;
	 reg [NUM_STATE_BITS - 1:0] next_state;
	 
	 // Update state of control (FSM)
	 always @ (posedge clk)
	 begin
		if (reset)
			current_state <= STATE_RESET;	// perform synchronous reset
		else
			current_state <= next_state;	// update state to calculated next state
	 end
	 
	 // MUX selectors for outputs of each state
	 parameter ALU_A_PC = 1'b0;
	 parameter ALU_A_REG_SRC = 1'b1;
	 parameter ALU_B_REG_SRC = 2'd0;
	 parameter ALU_B_PC4 = 2'd1;
	 parameter ALU_B_IMM = 2'd2;
	 parameter ALU_B_BRANCH = 2'd3;
	 parameter DATA_SELECT_ALU_OUT = 1'b0;
	 parameter DATA_SELECT_MEM = 1'b1;
	 parameter PC_SELECT_INSTR_ADDRESS = 1'b0;
	 parameter PC_SELECT_DATA_ADDRESS = 1'b1;
	 parameter REG_DST_RN = 1'b0;
	 parameter REG_DST_RD = 1'b1;
	 
	 // Get next state of control (FSM)
	 always @ (current_state or opcode or alu_zero)
	 begin
			// Initialize control signals with default values to prevent creating a latch
			RegDst <= REG_DST_RN;
			ALUSrcA <= 1'b0;
			ALUSrcB <= 2'b0;
			RegWrite <= 1'b0;
			MemToReg <= DATA_SELECT_ALU_OUT;
			IRWrite <= 1'b0;
			MemWrite <= 1'b1;
			MemRead <= 1'b0;
			//DnotI <= PC_SELECT_INSTR_ADDRESS;
			PCWrite <= 1'b0;
			ALUOp <= ALU_OP_ADD;
			PCSource <= PC_SELECT_RESET;
			PCWriteCond <=  1'b0;
			mem_select <= 1'b0;
			
			case (current_state)
				STATE_RESET: 
				begin
					next_state <= STATE_IF;
					
					RegDst <= REG_DST_RN;
					ALUSrcA <= 1'b0;
					ALUSrcB <= 2'b0;
					RegWrite <= 1'b0;
					MemToReg <= DATA_SELECT_ALU_OUT;
					IRWrite <= 1'b0;
					MemWrite <= 1'b0;
					MemRead <= 1'b1;
					//DnotI <= PC_SELECT_INSTR_ADDRESS;
					PCWrite <= 1'b1;	// Turn on program counter
					ALUOp <= ALU_OP_ADD;
					PCSource <= PC_SELECT_RESET;
					PCWriteCond <=  1'b0;
					mem_select <= 1'b0;
				end
			
				STATE_IF: // Instruction fetch stage
				begin	// No case necessary because next state is always INSTRUCTION_DECODE
					next_state <= STATE_ID;
					
					MemRead <= 1'b0;
					MemWrite <= 1'b1;
					RegWrite = 1'b0;
					ALUSrcA <= ALU_A_PC;
					//DnotI <= PC_SELECT_INSTR_ADDRESS;
					IRWrite <= 1'b1;
					ALUSrcB <= ALU_B_PC4;
					ALUOp <= ALU_OP_ADD;
					PCWrite <= 1'b1;
					PCSource <= PC_SELECT_ALU;
					mem_select <= 1'b0;
				end
				
				STATE_ID:	// Instruction Decode stage
				begin
					PCWrite <= 1'b0;
					IRWrite <= 1'b0;
					case (opcode)
						INSTR_NOP: next_state <= STATE_IF;
						
						INSTR_ADD: next_state <= STATE_REG_X;
						
						INSTR_ADDI: next_state <= STATE_ADDI;
						
						INSTR_MOV: next_state <= STATE_MOVE;
						
						INSTR_LR: next_state <= STATE_LR_ADDR;
						
						INSTR_SR: next_state <= STATE_SR_ADDR;
						
						INSTR_LA: next_state <= STATE_LOAD_ADDR;
						
						INSTR_BLEQ: next_state <= STATE_BRANCH_COMPL;
						
						default: next_state <= STATE_ERROR;
					endcase
					ALUSrcA <= ALU_A_PC;	// Defaults to PC data for inputA
					ALUSrcB <= ALU_B_BRANCH;	// Defaults to branch data for inputB
					ALUOp <= ALU_OP_ADD;	// Defaults to add
				end
				
				STATE_LR_ADDR:
				begin
					next_state <= STATE_MEM_LOAD;
					
					ALUSrcA <= ALU_A_REG_SRC;
					ALUSrcB <= ALU_B_IMM;
					ALUOp <= ALU_OP_ADD;
				end
				
				STATE_SR_ADDR:
				begin
					next_state <= STATE_MEM_STORE;
					
					ALUSrcA <= ALU_A_REG_SRC;
					ALUSrcB <= ALU_B_IMM;
					ALUOp <= ALU_OP_ADD;
				end
				
				STATE_ADDI:	// Execute Register with immediate ALU stage
				begin
					next_state <= STATE_ALU_WB;
					
					ALUOp <= ALU_OP_ADD;
					ALUSrcA <= ALU_A_REG_SRC;
					ALUSrcB <= ALU_B_IMM;
					RegDst <= REG_DST_RN;
				end
				
				STATE_REG_X:	// Execute Register ALU stage
				begin
					next_state <= STATE_ALU_WB;
					
					ALUSrcA <= ALU_A_REG_SRC;
					ALUSrcB <= ALU_B_REG_SRC;
					RegDst <= REG_DST_RD;
					case (opcode)
						INSTR_NOP: ALUOp <= ALU_OP_ADD;
						
						INSTR_ADD: ALUOp <= ALU_OP_ADD;
						
						INSTR_ADDI: ALUOp <= ALU_OP_ADD;
				
						INSTR_SUB: ALUOp <= ALU_OP_SUB;
						
						default: ALUOp <= ALU_OP_ADD;
					endcase
				end
				
				STATE_BRANCH_COMPL:	// Branch Complete stage
				begin
					next_state <= STATE_IF;
					
					ALUSrcA <= ALU_A_REG_SRC;
					ALUSrcB <= ALU_B_REG_SRC;
					ALUOp <= ALU_OP_SUB;
					PCWriteCond <= 1'b1;
					
					if (alu_zero & PCWriteCond)
					begin
						PCWrite <= 1'b0;
						//PCSource <= PC_SELECT_ALU_BUF;
					end
					else
					begin
						PCWrite <= 1'b1;
						PCSource <= PC_SELECT_ALU_BUF;
					end
				end
				
				/*
				STATE_JUMP_COMPL:	// Jump Complete stage
				begin
					next_state <= STATE_IF;
					
					PCWrite <= 1'b1;
					PCSource <= PC_SELECT_JUMP;
				end
				*/
				
				STATE_MEM_LOAD:	// Load Memory stage
				begin
					next_state <= STATE_MEM_WRITEBACK;
				
					MemRead <= 1'b1;
					MemWrite <= 1'b0;
					//DnotI <= PC_SELECT_DATA_ADDRESS;
					mem_select <= 1'b1;
				end
				
				STATE_MEM_STORE:	// Store Memory Stage
				begin
					next_state <= STATE_IF;
				
					MemWrite <= 1'b1;
					MemRead <= 1'b0;
					//DnotI  <= PC_SELECT_DATA_ADDRESS;
					mem_select <= 1'b1;
				end
				
				STATE_ALU_WB:	// Store in register stage
				begin
					next_state <= STATE_IF;
					
					case(opcode)
						INSTR_ADD: RegDst <= REG_DST_RD;
						INSTR_ADDI: RegDst <= REG_DST_RN;
					endcase
					RegWrite <= 1'b1;
					MemToReg <= DATA_SELECT_ALU_OUT;
				end
				
				STATE_MEM_WRITEBACK:	// Memory Write Back stage
				begin
					next_state <= STATE_IF;
					
					MemToReg <= DATA_SELECT_MEM;
					RegWrite <= 1'b1;
					RegDst <= REG_DST_RN;
					//DnotI <= PC_SELECT_DATA_ADDRESS;
					mem_select <= 1'b1;
				end
				
				default:
				begin
					next_state <= STATE_RESET;
					
					RegDst <= REG_DST_RN;
					ALUSrcA <= 1'b0;
					ALUSrcB <= 2'b0;
					RegWrite <= 1'b0;
					MemToReg <= DATA_SELECT_ALU_OUT;
					IRWrite <= 1'b0;
					MemWrite <= 1'b0;
					MemRead <= 1'b1;
					//DnotI <= PC_SELECT_INSTR_ADDRESS;
					PCWrite <= 1'b1;	// Turn on program counter
					ALUOp <= ALU_OP_ADD;
					PCSource <= PC_SELECT_RESET;
					PCWriteCond <= 1'b0;
					mem_select <= 1'b0;
				end
			endcase
	 end
endmodule
