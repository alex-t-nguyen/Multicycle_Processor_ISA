`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:23:25 04/30/2021 
// Design Name: 
// Module Name:    Multi_Cycle_Computer 
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
module Multi_Cycle_Computer(
    clk,
    reset,
    program_out
    );
	 
	 `include "params.v"
	 
	 input clk;
    input reset;
    output [DATA_BUS_WIDTH - 1:0] program_out; 
	 supply1 VDD;
	 supply0 gnd;
	 
	 wire clock_delayed;
	 
	 // instruction wires
	 wire [ADDRESS_BUS_WIDTH - 1:0] pc_address;
	 wire [ADDRESS_BUS_WIDTH - 1:0] pc_next_address;
	 wire [INSTRUCTION_WIDTH - 1:0] instruction;
	 wire [INSTRUCTION_WIDTH - 1:0] imem_data;
	 wire [INSTRUCTION_WIDTH - WIDTH_OPCODE:0] instr_no_opcode;
	 
	 // data wires
	 wire [ADDRESS_BUS_WIDTH - 1:0] reset_address;
	 wire [ADDRESS_BUS_WIDTH - 1:0] jump_address;
	 
	 wire [DATA_BUS_WIDTH - 1:0] mem_data;	// data coming out of memory (input into data register)
	 wire [DATA_BUS_WIDTH - 1:0] user_data; // data  in data register after loaded from memory (data user wants)
	 wire [DATA_BUS_WIDTH - 1:0] regfile_data; // data written into register file (loaded into a register)
	 
	 // reigster file wires
	 wire [REGFILE_ADDR_BITS - 1:0] dest_reg;
	 wire [REGFILE_ADDR_BITS - 1:0] src_reg;
	 wire [REGFILE_ADDR_BITS - 1:0] n_reg;
	 wire [REGFILE_ADDR_BITS - 1:0] write_reg;
	 
	// ALU input wires
	wire [DATA_BUS_WIDTH - 1:0] alu_A;
	wire [DATA_BUS_WIDTH - 1:0] alu_B;
	
	// immediate wires
	wire [IMMEDIATE_WIDTH - 1:0] immediate;
	wire [DATA_BUS_WIDTH - 1:0] sign_extended_imm;	// immediate after sign extension
	wire [DATA_BUS_WIDTH - 1:0] branch_imm;	// immediate after sign extension & left shift 2
	
	// ALU control wires
	wire [ALU_OP_NUM_BITS - 1:0] alu_op;
	
	// Data registers
	wire [DATA_BUS_WIDTH - 1:0] regfile_outA;
	wire [DATA_BUS_WIDTH - 1:0] regfile_outB;
	wire [DATA_BUS_WIDTH - 1:0] reg_A_saved;
	wire [DATA_BUS_WIDTH - 1:0] reg_B_saved;
	wire [DATA_BUS_WIDTH - 1:0] alu_out;
	wire [DATA_BUS_WIDTH - 1:0] alu_out_buffer;
	wire alu_out_zero;
	
	// Control wires
	wire [0:0] alu_srcA_select;
	wire [1:0] alu_srcB_select;
	wire [1:0] pc_select;
	wire reg_dst;
	wire RegWrite;
	wire mem_or_alu;
	wire IRWrite;
	wire MemRead;
	wire MemWrite;
	//wire DnotI;	// not used because no mux b/c instr & data mem separate
	wire PCWrite;
	wire PCWriteCond;
	wire mem_select;
	wire [WIDTH_OPCODE - 1:0] opcode;	// Opcode input into Control to determine alu_op
	wire branch_cond;
	wire pc4_or_branch;
	
	assign reset_address = 10'd512; // address 512 is first address for instructions (0x200)
	assign jump_address = 10'd512;
	assign program_out = mem_data;
	
	// program counter
	address_register program_counter(.clk(clk), .in_data(pc_next_address), .out_data(pc_address), .enable(pc4_or_branch));
	
	assign #30 clock_delayed = clk;
	
	instruction_ram imem(.clk(clock_delayed), .address(pc_address), 
								.memRead(VDD), // Harvard architecture - instruction memory is always read, no writing
								.memWrite(gnd), 
								.data(imem_data));
					
	data_ram dmem(.clk(clk), 
					  .address(alu_out_buffer[ADDRESS_BUS_WIDTH - 1:0]), // Address of data memory is calculated from ALU
					  .memRead(MemRead), .memWrite(MemWrite), .writeData(reg_B_saved), .readData(mem_data), 
					  .cs(mem_select));	// chip select is the mem_select in control -> control access to memory or not
	
	// Store instructions fetched from memory
   instruction_register iregister(.clk(clk), .in_data(imem_data), .instruction(instruction), .enable(IRWrite));
	
	// Store data fetched from memory
	data_register dmem_register(.clk(clock_delayed), .in_data(mem_data), .out_data(user_data), .enable(mem_select));
	
	// Decode instruction in instruction register
	decode_instruction decoder(.instruction(instruction), .reg_dest(dest_reg), .reg_source(src_reg), .reg_n(n_reg), .immediate(immediate), .opcode(opcode));
	
	// Register file
	regfile regfile(.read_address1(src_reg),
					 .read_address2(n_reg),
					 .read_data1(regfile_outA),
					 .read_data2(regfile_outB),
					 .write_address(write_reg),
					 .write_data(regfile_data),
					 .write_enable(RegWrite),
					 .clk(clk)
					 );
	 
	 // Registers to hold contents
	 data_register regA(.clk(clk), .in_data(regfile_outA), .out_data(reg_A_saved), .enable(VDD));
	 data_register regB(.clk(clk), .in_data(regfile_outB), .out_data(reg_B_saved), .enable(VDD));
	 
	 // Mux to select destination register
	 dest_reg_mux2 reg_dst_select(.data0(n_reg), .data1(dest_reg), .select(reg_dst), .dataOut(write_reg));
	 
	 // Mux to select where data comes from
	 data_mux2 regfile_data_select(.data0(alu_out_buffer), .data1(user_data), .select(mem_or_alu), .dataOut(regfile_data));
	 
	 // Mux to select ALU src1 input
	 data_mux2 alu_src1_select(.data0({54'b0,pc_address}), .data1(reg_A_saved), .select(alu_srcA_select), .dataOut(alu_A));
	 
	 // Sign extender
	 sign_extend se(.imm(immediate), .out(sign_extended_imm));
	 
	 // Left Shifter
	 left_shift ls(.shiftIn(sign_extended_imm), .shiftOut(branch_imm));
	 
	 // Mux to select ALU src2 input
	 data_mux4 alu_src2_select(.data0(reg_B_saved), .data1(64'h4), .data2(sign_extended_imm), .data3(branch_imm), .select(alu_srcB_select), .dataOut(alu_B));
	 
	 // Left Shift 2 for jump address
	 //pc_shifter pc_shift(.shiftIn(instr_no_opcode), .shiftOut(jump_address));
	 
	 // ALU
	 alu alu(.srcA(alu_A),
			 .srcB(alu_B),
			 .ALU_Op(alu_op),
			 .result(alu_out),
			 .zero(alu_out_zero)
	 );
	 
	 // Data register to hold the value of the ALU
	 data_register ALU_out(.clk(clk), .in_data(alu_out), .out_data(alu_out_buffer), .enable(VDD));
	 
	 // Mux to select next PC address
	 addr_mux4 pc_addr_select(.data0(alu_out[ADDRESS_BUS_WIDTH - 1:0]),
							 .data1(alu_out_buffer[ADDRESS_BUS_WIDTH - 1:0]),
							 .data2(jump_address),
							 .data3(reset_address),
							 .select(pc_select),
							 .dataOut(pc_next_address));
							 
	 or2to1 pc_write_branch_control(.data_in1(branch_cond),
									.data_in2(PCWrite),
									.data_out(pc4_or_branch),
									.enable(VDD)
									);
							 
	 and2to1 pc_branch_alu0_control(.data_in1(alu_out_zero), 
									.data_in2(PCWriteCond), 
									.data_out(branch_cond), 
									.enable(VDD)
									);
	 
	 // Control unit
	 control CPU_control(.clk(clk),
							 .reset(reset),
							 //.instruction(instruction),
							 .RegDst(reg_dst),
							 .ALUSrcA(alu_srcA_select),
							 .ALUSrcB(alu_srcB_select),
							 .RegWrite(RegWrite),
							 .MemToReg(mem_or_alu),
							 .IRWrite(IRWrite),
							 .MemWrite(MemWrite),
							 .MemRead(MemRead),
							 //.DnotI(gnd),	// DnotI not used because Instr & Data mem are separate so no mux needed
							 .PCWrite(PCWrite),
							 .ALUOp(alu_op),
							 .PCSource(pc_select),
							 .PCWriteCond(PCWriteCond),
							 .mem_select(mem_select),
							 .alu_zero(alu_out_zero),
							 .opcode(opcode)
							 );

endmodule