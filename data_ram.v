`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:19:55 04/28/2021 
// Design Name: 
// Module Name:    data_ram 
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
module data_ram(
    clk,
	 address,
	 memRead,
	 memWrite,
	 writeData,
	 readData,
	 cs
    );
	 `include "params.v"
	 
	 input clk;
    input [ADDRESS_BUS_WIDTH - 1:0] address;
    input memRead;
    input memWrite;
    input [DATA_BUS_WIDTH - 1:0] writeData;
    output [DATA_BUS_WIDTH - 1:0] readData;
    input cs;	// chip select
	 
	 parameter NUM_DATA_ADDRESSES = NUM_ADDRESSES / 2;
	 
	 reg [8:0] ram_memory [0:NUM_DATA_ADDRESSES - 1];	// 512 rows x 64 columns -> 512 addresses each with 64 bits of data
	 
	 //reg [8:0] ram_memory [0:64];	// reduced ram memory size for debugging purposes
	 reg [DATA_BUS_WIDTH - 1:0] ram_private;	// temp variable for ram_memory
	 // reg [DATA_BUS_WIDTH - 1:0] read_private; // temp variable for readData
	 
	 // Initialize memory with random data
	 integer i;
	 
	 initial	 
	 begin
		// read_private <= 0;
		
		for(i = 0; i < NUM_DATA_ADDRESSES; i = i + 1)
		begin
			ram_memory[i] = 0;
		end
		
		ram_memory[16] = 8'd20;
		ram_memory[32] = 8'd22;
		ram_memory[48] = 8'd0;
	 end
	 
	 // Read or write data
	 
	 always @ (posedge clk)
	 begin
		if(cs)	// if chip select is on (allow access to memory)
		begin
			if(memRead)	// read memory
			begin
				ram_private[7:0] <= ram_memory[address];
				ram_private[15:8] <= ram_memory[address + 1];
				ram_private[23:16] <= ram_memory[address + 2];
				ram_private[31:24] <= ram_memory[address + 3];
				ram_private[39:32] <= ram_memory[address + 4];
				ram_private[47:40] <= ram_memory[address + 5];
				ram_private[55:48] <= ram_memory[address + 6];
				ram_private[63:56] <= ram_memory[address + 7];
			end
			else if(memWrite)	// write memory
				ram_memory[address] <= writeData[7:0];
				ram_memory[address + 1] <= writeData[15:8];
				ram_memory[address + 2] <= writeData[23:16];
				ram_memory[address + 3] <= writeData[31:24];
				ram_memory[address + 4] <= writeData[39:32];
				ram_memory[address + 5] <= writeData[47:40];
				ram_memory[address + 6] <= writeData[55:48];
				ram_memory[address + 7] <= writeData[63:56];
		end 
		else	// if chip select is off (no access to memory)
			ram_private <= 64'bz;
	 end
	 assign readData = ram_private;
	 
endmodule