from control_unit.gm.definitions import *


class AluFunctions:
    AND = 0b000
    OR = 0b001
    ADD = 0b010
    SUB = 0b110
    SLT = 0b111
    NOR = 0b101
    XOR = 0b011


def alu_decoder(alu_op, opcode, funct):
    alu_f = None

    if alu_op == 0b00:
        alu_f = AluFunctions.ADD

    elif alu_op == 0b01:
        alu_f = AluFunctions.SUB

    elif alu_op == 0b10:
        if funct == ADD:
            alu_f = AluFunctions.ADD
        elif funct == SUB:
            alu_f = AluFunctions.SUB
        elif funct == AND:
            alu_f = AluFunctions.AND
        elif funct == OR:
            alu_f = AluFunctions.OR
        elif funct == NOR:
            alu_f = AluFunctions.NOR
        elif funct == XOR:
            alu_f = AluFunctions.XOR
        elif funct == SLT:
            alu_f = AluFunctions.SLT
        else:
            raise ValueError

    elif alu_op == 0b11:
        if opcode == ADDI:
            alu_f = AluFunctions.ADD
        elif opcode == ORI:
            alu_f = AluFunctions.OR
        elif opcode == XORI:
            alu_f = AluFunctions.XOR
        elif opcode == SLTI:
            alu_f = AluFunctions.SLT
        else:
            raise ValueError
    else:
        raise ValueError

    return alu_f


def create_alu_decoder_tvs():
    R = 0b000000
    X = 0b000000
    operations = [(0b00, X, X), (0b01, X, X), (0b10, R, ADD), (0b10, R, SUB), (0b10, R, AND), (0b10, R, OR),
                  (0b10, R, NOR), (0b10, R, XOR), (0b10, R, SLT), (0b11, ADDI, X), (0b11, ORI, X), (0b11, XORI, X),
                  (0b11, SLTI, X)]

    out = open('../simulation/modelsim/alu_decoder.tv', 'w')

    for ALUOp, opcode, funct in operations:
        ALUControl = alu_decoder(ALUOp, opcode, funct)
        out.write("{:02b}_{:06b}_{:06b}_{:03b}\n".format(ALUOp, opcode, funct, ALUControl))

    out.close()


if __name__ == '__main__':
    create_alu_decoder_tvs()
