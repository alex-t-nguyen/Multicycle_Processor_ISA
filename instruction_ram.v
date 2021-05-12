`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:42:16 04/29/2021 
// Design Name: 
// Module Name:    instruction_ram 
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
module instruction_ram(
    clk,
    address,
    memRead,
    memWrite,
    data
    );
	 `include "params.v"
	 
	 input clk;
    input [ADDRESS_BUS_WIDTH - 1:0] address;
    input memRead;
    input memWrite;
    output [INSTRUCTION_WIDTH - 1:0] data;
	 
	 parameter NUM_INSTRUCTION_ADDRESSES = NUM_ADDRESSES / 2;
	 
	 // Instructions are 19 bits = 3 bytes (24 bits)
	 // This means each instruction word is 3 bytes
	 // To make instruction memory word-aligned (read instructions in 4 lines (4 bytes)) -> more convenient than 3 lines
	 parameter NUM_INSTRUCTION_WORDS = NUM_INSTRUCTION_ADDRESSES / 4; // 4 instructions per word
	 
	 // Normally, Instruction RAM is read-only -> byte-addressable -> # of lines in 
	 // memory are divided as if they are 1 byte long (width of each line is 1 byte) and each instruction takes up 3 bytes (3 lines)
	 // To make memory writeable, make memory word-addressalbe -> width of each line in memory is 1 word (3 bytes) and reduce # of lines by 3 (word size)
	 reg [INSTRUCTION_WIDTH - 1:0] ram_memory [0:NUM_INSTRUCTION_WORDS - 1];
	 reg [INSTRUCTION_WIDTH - 1:0] ram_private;
	 wire [ADDRESS_BUS_WIDTH - 4:0] word_index;	// word index -> fit 10 bit address into 7 bits (128 lines) of memory
	 
	 integer i;
	 initial 
	 begin
	 // Load the program at the halfway point, which is the reset address
	 
  // Program C = A + B   A @ 0x10 B @ 0x20 C @ 0x30
  // lr R1, [R0, 0x10]
  // lr R2, [R0, 0x20]
  // add R3, R1, R2  ; R3 <= (R1) + (R2)
  // sr [R0, 0x30], R3
  //
  // Program machine encoding:
  // lr opcode = 8. lr R1, [R0,0x10]
  // opcode | unused | reg_source | reg_n | immediate   
  //   5    |    2   |    2       |   2   |    8       // 19 - 9 - 8 = 2
  // 01000       00       00          01     0001 0000
  // regroup bits:
  // 0010 0000 0001 0001 0000
  // hex value:
  // 0x20110
	  ram_memory[0] = 19'h20110;
	  
  // lr opcode = 8. lr R2, R0[0x20]
  // opcode | unused | reg_source | reg_n | immediate   
  //   5    |    2   |     2      |   2   |     8       // 19 - 9 - 8 = 2
  // 01000       00        00         10     0010 0000
  // regroup bits:
  // 0010 0000 0010 0010 0000
  // hex value:
  // 0x20220
	  ram_memory[1] = 19'h20220;
	  
  // add opcode = 1. add R3, R1, R2  ; R3 <= (R1) + (R2)
  // opcode | reg_dest | reg_source | reg_n | unused   
  //   5    |    2     |     2      |    2  |    8     // 19 - 5 - 6 = 8
  // 00001       11          01         10    0000 0000
  // regroup bits:
  // 0000 0111 0110 0000 0000
  // hex value:
  // 0x07600
	  ram_memory[2] = 19'h07600;
	  
  // sr opcode = 9. sr [R0, 0x30], R3 -> [RSource, Immediate], Rn
  // opcode | unused | reg_source | reg_n | immediate   
  //   5    |    2   |    2     |   2    |    8     // 19 - 5 - 6 = 8
  // 01001       00       00        11      0011 0000
  // regroup bits:
  // 0010 0100 0011 0011 0000
  // hex value:
  // 0x24330
	  ram_memory[3] = 19'h24330;
	  
  // Program 1:
  // 0x20110
  // 0x20220
  // 0x07600
  // 0x24330
  
	 end
	 
	 // word_index is the address divided by the word size (actually 3, but easier to work with 4)
	 // right shift by 2 = divide by 4
	 assign word_index = address[ADDRESS_BUS_WIDTH - 2:0] >> 2;
	 always @ (posedge clk)
	 begin
		if (memRead) begin
			ram_private <= ram_memory[word_index];
		end
		else if (memWrite)
			ram_memory[word_index] <= data;
	 end
	 assign data = ram_private;
	
endmodule
