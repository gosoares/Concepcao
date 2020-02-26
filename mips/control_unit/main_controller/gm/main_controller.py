from control_unit.gm.definitions import *


class MainController:
    def __init__(self):
        self.state = S0
        self.nextState = S1
        self.MemtoReg = 0b0
        self.RegDst = 0b0
        self.IorD = 0b0
        self.PCSrc = 0b00
        self.ALUSrcB = 0b01
        self.ALUSrcA = 0b0
        self.IRWrite = True
        self.MemWrite = False
        self.PCWrite = True
        self.BranchEQ = False
        self.BranchNE = False
        self.RegWrite = False
        self.ALUOp = 0b00

    def get_next_state(self, opcode):
        # atribui valor padrao aos sinais
        # para depois atribuir somente os
        # sinais do estado atual
        self.MemtoReg = 0b0
        self.RegDst = 0b0
        self.IorD = 0b0
        self.PCSrc = 0b00
        self.ALUSrcB = 0b00
        self.ALUSrcA = 0b0
        self.IRWrite = False
        self.MemWrite = False
        self.PCWrite = False
        self.BranchEQ = False
        self.BranchNE = False
        self.RegWrite = False
        self.ALUOp = 0b00

        if self.state == S0:
            self.IorD = 0b0
            self.ALUSrcA = 0b0
            self.ALUSrcB = 0b01
            self.ALUOp = 0b00
            self.PCSrc = 0b00
            self.IRWrite = True
            self.PCWrite = True

            self.nextState = S1

        elif self.state == S1:
            self.ALUSrcA = 0b0
            self.ALUSrcB = 0b11
            self.ALUOp = 0b00

            if opcode in [SW, LW]:
                self.nextState = S2
            elif opcode in R_TYPE:
                self.nextState = S6
            elif opcode == BEQ:
                self.nextState = S8
            elif opcode in I_TYPE:
                self.nextState = S9
            elif opcode == J:
                self.nextState = S11
            elif opcode == BNE:
                self.nextState = S12
            else:
                raise ValueError

        elif self.state == S2:
            self.ALUSrcA = 0b1
            self.ALUSrcB = 0b10
            self.ALUOp = 0b00

            if opcode == LW:
                self.nextState = S3
            elif opcode == SW:
                self.nextState = S5

        elif self.state == S3:
            self.IorD = 0b1

            self.nextState = S4

        elif self.state == S4:
            self.RegDst = 0b0
            self.MemtoReg = 0b1
            self.RegWrite = True

            self.nextState = S0

        elif self.state == S5:
            self.IorD = 0b1
            self.MemWrite = True

            self.nextState = S0

        elif self.state == S6:
            self.ALUSrcA = 0b1
            self.ALUSrcB = 0b00
            self.ALUOp = 0b10

            self.nextState = S7

        elif self.state == S7:
            self.RegDst = 0b1
            self.MemtoReg = 0b0
            self.RegWrite = True

            self.nextState = S0

        elif self.state == S8:
            self.ALUSrcA = 0b1
            self.ALUSrcB = 0b00
            self.ALUOp = 0b01
            self.PCSrc = 0b01
            self.BranchEQ = True

            self.nextState = S0

        elif self.state == S9:
            self.ALUSrcA = 0b1
            self.ALUSrcB = 0b10
            self.ALUOp = 0b11

            self.nextState = S10

        elif self.state == S10:
            self.RegDst = 0b0
            self.MemtoReg = 0b0
            self.RegWrite = True

            self.nextState = S0

        elif self.state == S11:
            self.PCSrc = 0b10
            self.PCWrite = True

            self.nextState = S0

        elif self.state == S12:
            self.ALUSrcA = 0b1
            self.ALUSrcB = 0b00
            self.ALUOp = 0b01
            self.PCSrc = 0b01
            self.BranchNE = True

            self.nextState = S0

        else:
            raise ValueError

        return self.nextState

    def go_next_state(self, rst):
        if rst == 1:
            self.state = S0
        else:
            self.state = self.nextState


def create_main_controller_tvs():
    file = open('main_controller_input.txt', 'r')
    out = open('../simulation/modelsim/main_controller.tv', 'w')
    clk = 0
    mc = MainController()
    rst = 1
    opcode = None
    finished = True

    while True:
        if finished:
            finished = False
            inp = file.readline()
            if not inp or inp is None:
                break

            rst = int(inp[0])
            opcode = int(inp[2:8], 2)

        if clk == 1 or rst == 1:
            mc.go_next_state(rst)
            mc.get_next_state(opcode)
            if mc.state == S0:
                finished = True

        sout = "{:1b}_{:1b}_{:06b}_{:04b}_{:1b}_{:1b}_{:1b}_{:02b}_{:02b}_{:1b}_{:1b}_{:1b}_{:1b}_{:1b}_{:1b}_{:1b}" \
               "_{:02b}\n".format(clk, rst, opcode, mc.state, mc.MemtoReg, mc.RegDst, mc.IorD, mc.PCSrc, mc.ALUSrcB,
                                  mc.ALUSrcA, mc.IRWrite, mc.MemWrite, mc.PCWrite, mc.BranchEQ, mc.BranchNE,
                                  mc.RegWrite, mc.ALUOp)
        print(sout, end="")
        out.write(sout)

        clk = 1 - clk

    out.close()
    file.close()


if __name__ == '__main__':
    create_main_controller_tvs()
