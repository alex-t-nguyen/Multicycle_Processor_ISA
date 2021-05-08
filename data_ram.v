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
	 
	 reg [DATA_BUS_WIDTH - 1:0] ram_memory [0:NUM_DATA_ADDRESSES - 1];	// 512 rows x 64 columns -> 512 addresses each with 64 bits of data
	 reg [DATA_BUS_WIDTH - 1:0] ram_private;	// temp variable for ram_memory
	 reg [DATA_BUS_WIDTH - 1:0] read_private; // temp variable for readData
	 
	 // Initialize memory with random data
	 integer i;
	 
	 initial	 
	 begin
		read_private <= 0;
		
		for(i = 0; i < NUM_DATA_ADDRESSES; i = i + 1)
		begin
			ram_memory[i] = i;
		end
		
		$display("Data value at mem[%0d] = %0d", 49, ram_memory[49]);
	 end
	 
	 // Read or write data
	 
	 always @ (posedge clk)
	 begin
		if(cs)	// if chip select is on (allow access to memory)
		begin
			if(memRead)	// read memory
				ram_private[DATA_BUS_WIDTH - 1:0] <= ram_memory[address];
			else if(memWrite)	// write memory
				ram_memory[address] <= writeData[DATA_BUS_WIDTH - 1:0];
		end 
		else	// if chip select is off (no access to memory)
			ram_private <= 64'bz;
	 end
	 assign readData = ram_private;

endmodule
