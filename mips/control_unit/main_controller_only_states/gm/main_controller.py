from control_unit.gm.definitions import *


class MainController:
    def __init__(self):
        self.state = S0
        self.nextState = S1

    def get_next_state(self, opcode):
        if self.state == S0:
            self.nextState = S1
        elif self.state == S1:
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
            if opcode == LW:
                self.nextState = S3
            elif opcode == SW:
                self.nextState = S5

        elif self.state == S3:
            self.nextState = S4

        elif self.state == S4:
            self.nextState = S0

        elif self.state == S5:
            self.nextState = S0

        elif self.state == S6:
            self.nextState = S7

        elif self.state == S7:
            self.nextState = S0

        elif self.state == S8:
            self.nextState = S0

        elif self.state == S9:
            self.nextState = S10

        elif self.state == S10:
            self.nextState = S0

        elif self.state == S11:
            self.nextState = S0

        elif self.state == S12:
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
    main_controller = MainController()
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
            main_controller.go_next_state(rst)
            main_controller.get_next_state(opcode)
            if main_controller.state == S0:
                finished = True

        sout = "{:1b}_{:1b}_{:06b}_{:04b}".format(clk, rst, opcode, main_controller.state)
        print(sout)
        out.write("{}\n".format(sout))

        clk = 1 - clk

    out.close()
    file.close()


if __name__ == '__main__':
    create_main_controller_tvs()
