// Here are the parameter definitions for all modules
parameter ADDRESS_BUS_WIDTH = 10 ;
parameter NUM_ADDRESS = 1024 ;
parameter PROGRAM_LOAD_ADDRESS = 512 ; // 0x200
parameter DATA_BUS_WIDTH = 64 ;
parameter REGFILE_ADDR_BITS = 2 ;
parameter NUM_REGISTERS = 4 ;
parameter WIDTH_REGISTER_FILE = 64 ;
parameter INSTRUCTION_WIDTH = 19 ;
parameter IMMEDIATE_WIDTH = 8 ;
parameter NUM_INSTRUCTIONS = 32 ;
parameter WIDTH_OPCODE = 5 ;  // log 2 NUM_INSTRUCTIONS

// OP CODES
parameter INSTR_NOP = 0 ;  // No operation 
parameter INSTR_ADD = 1 ;  // Add 
parameter INSTR_ADDI = 2 ;  // Add immediate 
parameter INSTR_SUB  = 3 ;  // Subtract 
// parameter INSTR_SUBI = 4 ;  // Subtract immediate
parameter INSTR_MULT = 4 ;  // Multiply 
// parameter INSTR_MULI = 6 ;  // Multiply immediate
parameter INSTR_DIV = 5 ;  // Divide 
// parameter INSTR_DIVI = 8 ;  // Divide immediate
// parameter INSTR_MOD = 9 ;  // Modulus
parameter INSTR_AND = 6 ;  // AND 
parameter INSTR_MOV = 7 ;  // Move 
parameter INSTR_LR = 8 ;  // Load register 
parameter INSTR_SR = 9 ;  // Save register 
// parameter INSTR_LI = 12 ; // Load immediate
parameter INSTR_LA = 10 ;  // Load address 
// parameter INSTR_OR = 15 ;  // OR
// parameter INSTR_ANDI  = 16 ;  // AND immediate
// parameter INSTR_ORI = 17 ;  // OR immediate
parameter INSTR_BEQ = 11 ;  // Branch on equal 
parameter INSTR_BNEQ = 12 ;  // Branch on not equal 
parameter INSTR_BLEQ = 13 ;  // Branch on less than equal 
// parameter INSTR_BLT = 21 ;  // Branch on less than
parameter INSTR_BGEQ = 14 ;  // Branch on greater then equal 
parameter INSTR_BGT = 15 ;  // Branch on greater than 
// parameter INSTR_J = 24 ;  // Jump
// parameter INSTR_JR = 25 ;  // Jump register
// parameter INSTR_JAL = 26 ;  // Jump and link

// parameter INSTR_SLL = 28 ;  // Shift left logical
// parameter INSTR_SRL = 29 ;  // Shift right logiacal
// parameter INSTR_XOR = 30 ;  // XOR
// parameter INSTR_NOT = 31 ;  // Invert

//    register file index 4 it takes 2 bits to encode r0...r3
//   addr  --------------------
//           63             0 
//      r0   .............         Address has nothing to do with the size of data!
//      r1   width of data         Address  Data tupple (A,D)
//                            
//       .                    
//       .                    
//       .                    
//                         
//      r3                   
//                            
//         --------------------
//
//	Definition for computer control
parameter NUM_STATE_BITS = 4;
parameter STATE_RESET = 0;
parameter STATE_IF = 1;
parameter STATE_ID = 2;
//parameter STATE_MEM_ADDRESS_COMPU = 3;
parameter STATE_LR_ADDR = 3;
parameter STATE_SR_ADDR = 4;
//parameter STATE_MEM_LOAD = 4;
//parameter STATE_MEM_WRITE_BACK = 5;
//parameter STATE_MEM_STORE = 6;
parameter STATE_REG_X = 5;
//parameter STATE_REG_COMPL = 8;
parameter STATE_BRANCH_COMPL = 6;
parameter STATE_MOVE = 7;
parameter STATE_ADDI = 8;
parameter STATE_LOAD_ADDR = 8;
parameter STATE_MEM_LOAD = 9;
parameter STATE_MEM_WRITEBACK = 10;
parameter STATE_MEM_STORE = 12;
parameter STATE_ALU_WB = 13;
parameter STATE_ERROR = 14;
//parameter STATE_JUMP_COMPL = 10;
//parameter STATE_REG_IMM_X = 11;

// ALU Parameters
parameter ALU_OP_NUM_BITS = 3;
parameter ALU_NUM_OPS = 1 << ALU_OP_NUM_BITS; // 2^3 = 8
parameter ALU_OP_ADD = 0;
parameter ALU_OP_SUB = 1;

// PC Select mux value parameters
parameter PC_SELECT_ALU = 0;
parameter PC_SELECT_ALU_BUF = 1;
parameter PC_SELECT_JUMP = 2;
parameter PC_SELECT_RESET = 3;

// Calculated parameters
parameter NUM_ADDRESSES = 1 << ADDRESS_BUS_WIDTH;
