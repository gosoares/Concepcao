# states
S0 = 0  # Fetch
S1 = 1  # Decode
S2 = 2  # MemAdr
S3 = 3  # MemRead
S4 = 4  # Mem Writeback
S5 = 5  # MemWrite
S6 = 6  # R-type Execute
S7 = 7  # ALU Writeback
S8 = 8  # Branch EQ
S9 = 9  # I-Type Execute
S10 = 10  # I-Type Writeback
S11 = 11  # Jump
S12 = 12  # Branch NE

# instructions opcode
LW = 0b100011
SW = 0b101011
R_TYPE = {0b000000}
BEQ = 0b000100
BNE = 0b000101
J = 0b000010
ADDI = 0b001000
ORI = 0b001101
XORI = 0b001110
SLTI = 0b001010
I_TYPE = {ADDI, ORI, XORI, SLTI}

# R-Type Functs
ADD = 0b100000
SUB = 0b100010
AND = 0b100100
OR = 0b100101
NOR = 0b100111
XOR = 0b100110
SLT = 0b101010
