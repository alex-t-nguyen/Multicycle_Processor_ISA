# Multicycle_Processor_ISA
Multicycle processor that implements a specific ISA

Your computer specification follows: </br>
Your address bus has a width of 10 bits which means that your computer must support 1024
addresses. This address space is shared between the instructions and your computer’s program data
space. The OS architect has already determined that the entry point of programs will be at the
center of the address space or 0x200. All programs will be loaded at that address and any branches
should be relative to that starting address. <br>
Your computer will have a data width of 64 bits. Your register files will be addressed using 2
bits resulting in a register file which is 4 by 64.
You are to design your own instruction set architecture with an instruction that is 19 bits wide.
Your instruction should accommodate an immediate field which has 8 bits. You should have 5 bits
devoted to instruction types which means your computer can support 32 instructions.

Your computer will need to support two simple programs: </br>
1) C ←− A + B </br>

2) int sum = 0 ; </br>
   for( i = 0 ; i <= 10 ; i++ ) { </br>
   &nbsp;&nbsp;&nbsp;sum += i ; </br>
   } </br>

**Specifications:**
- Address Bus Width: 10 bits
- Number of Addresses 1024
- Program Load Address: 0x200
- Data Bus Width: 64 bits
- Number of Register File Address Bits: 2
- Number Register File Registers: 4
- Width of Register File Register : 64
- Instruction Width: 19 bits
- Size of Immediate Field: 8 bits
- Maximum number of Instructions: 32
