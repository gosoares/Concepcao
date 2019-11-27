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


def create_acc_tvs():
    x = Wire()
    clk = Wire()
    acc = Acc(x=x, clk=clk)

    file = open('../simulation_modelsim/acc.tv', 'w')
    file.write("# x_clk_y\n")

    for i in range(15):  # gera 15 casos de teste
        if randint(0, 2) == 0:  # inverte clock 1/3 de chance
            clock = 1 - clk.data
            clk.set(clock)
        else:  # inverte entrada 2/3 de chance
            data = 1 - x.data
            x.set(data)

        file.write("{:1b}_{:1b}_{:1b}\n".format(x, clk, acc.y))

    file.close()


if __name__ == '__main__':
    create_acc_tvs()
