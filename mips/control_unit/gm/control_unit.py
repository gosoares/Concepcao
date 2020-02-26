from control_unit.main_controller.gm.main_controller import MainController
from control_unit.alu_decoder.gm.alu_decoder import alu_decoder
from control_unit.gm.   definitions import *


class ControlUnit:
    def __init__(self):
        mc = MainController()
        self.mc = mc
        self.state = mc.state
        self.nextState = mc.nextState
        self.MemtoReg = mc.MemtoReg
        self.RegDst = mc.RegDst
        self.IorD = mc.IorD
        self.PCSrc = mc.PCSrc
        self.ALUSrcB = mc.ALUSrcB
        self.ALUSrcA = mc.ALUSrcA
        self.IRWrite = mc.IRWrite
        self.MemWrite = mc.MemWrite
        self.PCWrite = mc.PCWrite
        self.BranchEQ = mc.BranchEQ
        self.BranchNE = mc.BranchNE
        self.RegWrite = mc.RegWrite
        self.ALUControl = None

    def get_next_state(self, Opcode, Funct):
        self.mc.get_next_state(Opcode)

        self.state = self.mc.state
        self.nextState = self.mc.nextState
        self.MemtoReg = self.mc.MemtoReg
        self.RegDst = self.mc.RegDst
        self.IorD = self.mc.IorD
        self.PCSrc = self.mc.PCSrc
        self.ALUSrcB = self.mc.ALUSrcB
        self.ALUSrcA = self.mc.ALUSrcA
        self.IRWrite = self.mc.IRWrite
        self.MemWrite = self.mc.MemWrite
        self.PCWrite = self.mc.PCWrite
        self.BranchEQ = self.mc.BranchEQ
        self.BranchNE = self.mc.BranchNE
        self.RegWrite = self.mc.RegWrite
        self.ALUControl = alu_decoder(self.mc.ALUOp, Opcode, Funct)

    def go_next_state(self, rst):
        self.mc.go_next_state(rst)
        self.state = self.mc.state


def create_control_unit_tvs():
    file = open('control_unit_input.txt', 'r')
    out = open('../simulation/modelsim/control_unit.tv', 'w')
    clk = 0
    c = ControlUnit()
    rst = 1
    Opcode = None
    Funct = None
    finished = True

    while True:
        if finished:
            finished = False
            inp = file.readline()
            if not inp or inp is None:
                break

            rst = int(inp[0])
            Opcode = int(inp[2:8], 2)
            Funct = int(inp[9:15], 2)

        if clk == 1 or rst == 1:
            c.go_next_state(rst)
            c.get_next_state(Opcode, Funct)
            if c.state == S0:
                finished = True

        sout = "{:1b}_{:1b}_{:06b}_{:06b}_{:04b}_{:1b}_{:1b}_{:1b}_{:02b}_{:02b}_{:1b}_{:1b}_{:1b}_{:1b}_{:1b}_{:1b}" \
               "_{:1b}_{:03b}\n".format(clk, rst, Opcode, Funct, c.state, c.MemtoReg, c.RegDst, c.IorD, c.PCSrc,
                                        c.ALUSrcB, c.ALUSrcA, c.IRWrite, c.MemWrite, c.PCWrite, c.BranchEQ, c.BranchNE,
                                        c.RegWrite, c.ALUControl)
        print(sout, end="")
        out.write(sout)

        clk = 1 - clk

    out.close()
    file.close()


if __name__ == '__main__':
    create_control_unit_tvs()
