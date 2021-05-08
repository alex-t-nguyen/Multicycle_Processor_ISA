
// Sample Instruction Set Architecture Design
// 1) Choose 2 operand data operations - accumulator mode
// 2) Choose Register names indexed as R<integer> valid for [0..NUM_REGISTERS-1]
// 3) (R0) <-> 0 
module decode_instruction(
  instruction,
  reg_dest,    
  reg_source,   
  reg_n,
  immediate,
  opcode
  ) ;
  `include "params.v"

  input [INSTRUCTION_WIDTH-1:0] instruction ;
  output [REGFILE_ADDR_BITS-1:0] reg_source ;
  output [REGFILE_ADDR_BITS-1:0] reg_n ;
  output [REGFILE_ADDR_BITS-1:0] reg_dest ;
  output [IMMEDIATE_WIDTH-1:0] immediate ;
  output [WIDTH_OPCODE-1:0] opcode ;

  //   Ri .... R3  log 4 base 2 = 2
  // Instruction format 1: Data computation 
  // ASSEMBLY: add R1, R2  ; R3 = R1 + R2 ;
  // opcode | reg_dest | reg_source | reg_target | unused  
  //   5    |    2     |     2           2       8      // 19 - 11  = 8
  parameter OPCODE_LSB = INSTRUCTION_WIDTH - WIDTH_OPCODE ;
  assign opcode = instruction[INSTRUCTION_WIDTH-1:OPCODE_LSB];
  // assign opcode = instruction[18:14];
  // This gives 19-1 : 19-5 or [18:14]   18 17 16 15 14
  //
  parameter DEST_LSB = OPCODE_LSB - REGFILE_ADDR_BITS ;
  assign reg_dest = instruction[OPCODE_LSB-1:DEST_LSB] ;
  // assign reg_dest = instruction[13:12] ;
  // This gives 19-5-1 : 19-5-2 or [13:12]   13 12
  //
  // Add parameter here:
  assign reg_source = instruction[11:10] ;
  // This gives 19-5-2-1 : 19-5-2-2 or [11:10]   11 10

  assign reg_n = instruction[9:8] ;
  // This gives 19-5-2-2-1 : 19-5-2-2-2 or [9:8]   9 8

  assign immediate = instruction[IMMEDIATE_WIDTH-1:0] ;
  // This gives 19-5-2-2-2-1 : 19-5-2-2-2-8 or [7:0]   7 6 5 4 3 2 1 0

  // Instruction formats:
  //
  // Instruction format: No Operation or nop
  // ASSEMBLY: nop
  // opcode = INSTR_NOP
  // opcode | unused
  //   5    |   14      // 19 - 5  = 14
  //

  // Instruction format: Add or add
  // ASSEMBLY: add R3, R1, R2  ; R3 <= R1 + R2 ;
  // opcode = INSTR_ADD
  // opcode | reg_dest | reg_source | reg_n | unused  
  //   5    |    2     |      2     |   2   |   8     // 19 - 11  = 8

  // Instruction format: Add immediate or addi
  // ASSEMBLY: addi R2, [R1, immediate] : R2 <= R1 + immediate
  // opcode INSTR_ADD
  // opcode | reg_dest | reg_source | unused | immediate
  //    5   |    2     |      2     |   2    |     8      // 19 - 9 - 8 = 2

  // Instruction format: Load Register or lr
  // ASSEMBLY: lr RDest, [RSource, Immediate] : lr R2, [R1, offset] or load [(R1) + offset] -> R2
  // opcode = INSTR_LR
  // opcode | reg_dest | reg_source | unused | immediate   
  //   5    |    2     |    2       |   2    |     8      // 19 - 9 - 8 = 2
  
  // Instruction format: Save Register or sr
  // ASSEMBLY: sr [RDest, Immediate], Rsource : sr [R1, offset], R2 or save R2 -> ((R1) + offset)
  // opcode = INSTR_SR
  // opcode | reg_dest | reg_source | unused | immediate   
  //   5    |    2     |     2      |   2    |     8        // 19 - 9 - 8 = 2
    
  // Instruction format: Branch less than or equal or BLEQ
  // ASSEMBLY: bleq RSource, Rn, label : RSource <= Rn -> branch to label
  //           = (address(label) - address(PC + 4)) >> 2
  //           = newAddress / 4
  //           = Number of instructions to move forwards or backwards
  // opcode = INSTR_BLEQ
  // opcode | unused | reg_source | reg_n | immediate
  //    5   |    2   |      2     |   2   |     8       // 19 - 9 - 8 = 2

  // ----------------------------------------- START PROGRAM 1 ----------------------------------------------
  //
  // Program C = A + B   A @ 0x10 B @ 0x20 C @ 0x30
  // lr R1, [R0, 0x10]
  // lr R2, [R0, 0x20]
  // add R3, R1, R2  ; R3 <= (R1) + (R2)
  // sr [R0, 0x30], R3
  //
  // Program machine encoding:
  // lr opcode = 8. lr R1, [R0,0x10]
  // opcode | reg_dest | reg_source | unused | immediate   
  //   5    |    2     |    2       |   2    |    8       // 19 - 9 - 8 = 2
  // 01000       01         00          00     0001 0000
  // regroup bits:
  // 0010 0001 0000 0001 0000
  // hex value:
  // 0x21010
  //
  // lr opcode = 8. lr R2, R0[0x20]
  // opcode | reg_dest | reg_source | unused | immediate   
  //   5    |    2     |     2      |   2    |     8       // 18 - 9 - 8 = 2
  // 01000       10          00         00     0001 0100
  // regroup bits:
  // 0010 0010 0000 0001 0100
  // hex value:
  // 0x22014
  //
  // add opcode = 1. add R3, R1, R2  ; R3 <= (R1) + (R2)
  // opcode | reg_dest | reg_source | unused | unused   
  //   5    |    2     |     2      |    2   |    8     // 26 - 11 - 12 = 3
  // 00001       11          01         10    0000 0000
  // regroup bits:
  // 0000 0111 0110 0000 0000
  // hex value:
  // 0x07600
  //
  // sr opcode = 9. sr [Rd, 0x30], R2
  // opcode | reg_dest | reg_source | unused | immediate   
  //   5    |    3     |    3       |   3    |    12     // 26 - 11 - 12 = 3
  // 01001       00         10         00      0011 0000
  // regroup bits:
  // 0010 0100 1000 0011 0000
  // hex value:
  // 0x24830
  //
  // Program 1:
  // 0x21010
  // 0x22014
  // 0x07600
  // 0x24830
  //
  // ----------------------------------------- END PROGRAM 1 ----------------------------------------------
  //
  // ----------------------------------------- START PROGRAM 2 ----------------------------------------------
  //
  // Program 2:
  // int sum = 0 ;
  // for( i = 0 ; i <= 10 ; i++ ){
  //   sum += i ; 
  // }
  //
  // Assembly code for sum progam here:
  //        lr R1, [R0, 0];  // int sum = 0
  //        lr R2, [R0, 0];  // int i = 0;
  //        addi R3, [R0, 10]; // max limit for i
  // loop:  add R1, R1, R2;  // sum += i
  //        addi R2, [R2, 1];  // i++
  //        bleq R2, R3, loop;  // i<=10, branch back to loop
  //
  // Machine code sum progam here:
  // lr opcode = 8. lr R1, [R0,0]
  // opcode | reg_dest | reg_source | unused | immediate   
  //   5    |    2     |    2       |   2    |    8       // 19 - 9 - 8 = 2
  // 01000       01         00          00     0000 0000
  // regroup bits:
  // 0010 0001 0000 0000 0000
  // hex value:
  // 0x21000
  //
  // lr opcode = 8. lr R2, [R0,0]
  // opcode | reg_dest | reg_source | unused | immediate   
  //   5    |    2     |    2       |   2    |    8       // 19 - 9 - 8 = 2
  // 01000       10         00          00     0000 0000
  // regroup bits:
  // 0010 0010 0000 0000 0000
  // hex value:
  // 0x22000
  //
  // addi opcode = 2. addi R3, [R0,10]
  // opcode | reg_dest | reg_source | unused | immediate   
  //   5    |    2     |    2       |   2    |    8       // 19 - 9 - 8 = 2
  // 00010       11         00          00     0000 1010
  // regroup bits:
  // 0000 1011 0000 0000 1010
  // hex value:
  // 0x0B00A
  //
  // add opcode = 1. add R1, R1, R2
  // opcode | reg_dest | reg_source | reg_n | unused   
  //   5    |    2     |    2       |   2   |    8       // 19 - 11 = 8
  // 00001       01         10          10     0000 0000
  // regroup bits:
  // 0000 1001 1010 0000 0000
  // hex value:
  // 0x05A00
  //
  // addi opcode = 2. addi R2, [R2,1]
  // opcode | reg_dest | reg_source | unused | immediate   
  //   5    |    2     |    2       |   2    |    8       // 19 - 9 - 8 = 2
  // 00010       10         10          00     0000 0001
  // regroup bits:
  // 0000 1010 1000 0000 0001
  // hex value:
  // 0x0A801
  // 
  // bleq opcode = 13. bleq R2, R3, loop
  // opcode | unused | reg_source | reg_n | immediate   
  //   5    |    2   |    2       |   2   |    8       // 19 - 9 - 8 = 2
  // 01101       00       10          11    1111 1110
  // regroup bits:
  // 0011 0100 1011 1111 1110
  // hex value:
  // 0x34BFE
  //
  // Program 2:
  // 0x21000
  // 0x22000
  // 0x0B00A
  // 0x05A00
  // 0x0A801
  // 0x34BFE

  // ----------------------------------------- END PROGRAM 2 ----------------------------------------------

  // Other Instruction Formats (Not used for the 2 programs above)
  //
  // Instruction format: AND or and
  // ASSEMBLY: and R3, R1, R2  ; R3 <= R1 & R2 ;
  // opcode = INSTR_AND = 14
  // opcode | reg_dest | reg_source | reg_n | unused  
  //   5    |    2     |      2     |   2   |   8     // 19 - 11  = 8
  // 01110  |    11    |      01    |   10  | 0000 0000
  // regroup bits:
  // 0011 1011 0110 0000 0000
  // hex value:
  // 0x3B500

  // Instruction format: Subtract or subt
  // ASSEMBLY: sub R3, R1, R2  ; R3 <= R1 - R2 ;
  // opcode = INSTR_SUB = 3
  // opcode | reg_dest | reg_source | reg_n | unused  
  //   5    |    2     |      2     |   2   |   8     // 19 - 11  = 8
  // 00011  |    11    |      01    |   10  | 0000 0000
  // regroup bits:
  // 0000 1111 0110 0000 0000
  // hex value:
  // 0x0F600

  // Instruction format: Multiply or mult
  // ASSEMBLY: mult R3, R1, R2  ; R3 <= R1 * R2 ;
  // opcode = INSTR_MULT = 5
  // opcode | reg_dest | reg_source | reg_n | unused  
  //   5    |    2     |      2     |   2   |   8     // 19 - 11  = 8
  // 00101  |    11    |      01    |   10  | 0000 0000
  // regroup bits:
  // 0001 0111 0110 0000 0000
  // hex value:
  // 0x17500

  // Instruction format: Divide or div
  // ASSEMBLY: div R3, R1, R2  ; R3 <= R1 / R2 ;
  // opcode = INSTR_DIV = 7
  // opcode | reg_dest | reg_source | reg_n | unused  
  //   5    |    2     |      2     |   2   |   8     // 19 - 11  = 8
  // 00111  |    11    |      01    |   10  | 0000 0000
  // regroup bits:
  // 0001 1111 0110 0000 0000
  // hex value:
  // 0x1F500

  // Instruction format: Branch on equal or beq
  // ASSEMBLY: beq R1, R2, label  ; R1 == R2 -> branch to label ; (label = -3 instructions)
  // opcode = INSTR_BEQ = 18
  // opcode | reg_dest | reg_source | unused | immediate  
  //   5    |    2     |      2     |   2    |   8        // 19 - 11  = 8
  // 10010  |    01    |      10    |   00   | 1111 1110
  // regroup bits:
  // 0100 1001 1000 1111 1110
  // hex value:
  // 0x298FE

  // Instruction format: Branch on not equals or bneq
  // ASSEMBLY: bneq R1, R2, label  ; R1 != R2 -> branch to label ; (label = -3 instructions)
  // opcode = INSTR_BNEQ = 19
  // opcode | reg_dest | reg_source | unused | immediate
  //   5    |    2     |      2     |   2    |   8     // 19 - 11  = 8
  // 10011  |    01    |      01    |   00   | 1111 1110
  // regroup bits:
  // 0100 1101 0100 1111 1110
  // hex value:
  // 0x4D4FE

  // Instruction format: Branch on greater than or equal or bgeq
  // ASSEMBLY: bgeq R1, R2, label  ; R1 >= R2 -> branch to label ; (label = -3 instructions)
  // opcode = INSTR_BGEQ = 22
  // opcode | reg_dest | reg_source | unused | immediate  
  //   5    |    2     |      2     |   2    |   8     // 19 - 11  = 8
  // 10110  |    01    |      01    |   00   | 1111 1110
  // regroup bits:
  // 0101 1001 0100 1111 1110
  // hex value:
  // 0x594FE

  // Instruction format: Branch on greater than or bgt
  // ASSEMBLY: bgt R1, R2, label  ; R1 > R2 -> branch to label ; (label = -3 instructions)
  // opcode = INSTR_BGT = 23
  // opcode | reg_dest | reg_source | unused | immediate  
  //   5    |    2     |      2     |   2    |   8     // 19 - 11  = 8
  // 10111  |    01    |      01    |   00   | 1111 1110
  // regroup bits:
  // 0101 1101 0100 1111 1110
  // hex value:
  // 0x5D4FE

  // Instruction format: Move or mov
  // ASSEMBLY: mov R1, R2  ; R1 <= R2 ;
  // opcode = INSTR_MOV = 27
  // opcode | reg_dest | reg_source | unused | unused  
  //   5    |    2     |      2     |   2    |   8     // 19 - 11  = 8
  // 11011  |    01    |      10    |   00   | 0000 0000
  // regroup bits:
  // 0110 1101 1000 0000 0000
  // hex value:
  // 0x6D800

  // Instruction format: Load address or la
  // ASSEMBLY: la R3, [R1, offset]  ; R3 <= R1 + offset ; (offset 140)
  // opcode = INSTR_LA = 13
  // opcode | reg_dest | reg_source | unused | immediate 
  //   5    |    2     |      2     |   2    |   8     // 19 - 11  = 8
  // 01101  |    11    |      01    |   00   | 1000 1100
  // regroup bits:
  // 0011 0111 0100 1000 1100
  // hex value:
  // 0x3748C

endmodule
