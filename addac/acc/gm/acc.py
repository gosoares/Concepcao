from random import randint
from typing import Dict

from gm.logic_block import LogicBlock
from gm.wire import Wire


class Acc(LogicBlock):
    def __init__(self, x: Wire, clk: Wire):
        self.lastClk: int = 0
        super().__init__({'x': x, 'clk': clk}, ['y'])

    def operation(self, inputs: Dict[str, int]) -> Dict[str, int]:
        output: Dict = {'y': inputs['x']} if inputs['clk'] == 1 and self.lastClk == 0 else {}
        self.lastClk = inputs['clk']
        return output


def main():
    x = Wire()
    clk = Wire()
    acc = Acc(x=x, clk=clk)

    file = open('acc.tv', 'w')
    file.write("# x_clk_y\n")

    clock: int = 0
    data: int = 0

    for i in range(50):  # gera 50 casos de teste
        if randint(0, 1) == 0:  # muda dado
            data = randint(0, 15)
            x.set(data)
        else:  # inverte clock
            clock = 1 - clock
            clk.set(clock)

        file.write("{:04b}_{:1b}_{:04b}\n".format(data, clock, acc.y))

    file.close()


if __name__ == '__main__':
    main()

