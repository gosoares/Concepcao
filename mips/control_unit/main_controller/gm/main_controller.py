from control_unit.gm.definitions import *


class MainController:
    def __init__(self):
        self.state = S0

    def go_next_state(self, rst, opcode):
        next_state = None
        if rst:
            next_state = S0
        elif self.state == S0:
            next_state = S1
        elif self.state == S1:
            if opcode in [SW, LW]:
                next_state = S2
            elif opcode in R_TYPE:
                next_state = S6
            elif opcode == BEQ:
                next_state = S8
            elif opcode in I_TYPE:
                next_state = S9
            elif opcode == J:
                next_state = S11
            elif opcode == BNE:
                next_state = S12
            else:
                raise ValueError
        elif self.state == S2:
            if opcode == LW:
                next_state = S3
            elif opcode == SW:
                next_state = S5

        elif self.state == S3:
            next_state = S4

        elif self.state == S4:
            next_state = S0

        elif self.state == S5:
            next_state = S0

        elif self.state == S6:
            next_state = S7

        elif self.state == S7:
            next_state = S0

        elif self.state == S8:
            next_state = S0

        elif self.state == S9:
            next_state = S10

        elif self.state == S10:
            next_state = S0

        elif self.state == S11:
            next_state = S0

        elif self.state == S12:
            next_state = S0

        else:
            raise ValueError

        self.state = next_state
        return next_state


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
            main_controller.go_next_state(rst, opcode)
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
