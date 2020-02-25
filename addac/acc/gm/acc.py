from random import randint
from typing import Dict

from gm.logic_block import LogicBlock
from gm.wire import Wire


class Acc(LogicBlock):
    def __init__(self, a: Wire, clk: Wire, y: Wire):
        self.lastClk: int = 0
        super().__init__({'a': a, 'clk': clk}, {'y': y})

    def operation(self, inputs: Dict[str, int]) -> Dict[str, int]:
        output: Dict = {'y': inputs['a']} if inputs['clk'] == 1 and self.lastClk == 0 else {}
        self.lastClk = inputs['clk']
        return output


def create_acc_tvs():
    a, clk = Wire(), Wire()
    y = Wire()
    Acc(a=a, clk=clk, y=y)

    file = open('../simulation/modelsim/acc.tv', 'w')
    file.write('0_0_x')
    file.write('0_1_x')
    file.write('0_0_x')

    for i in range(15):  # gera 15 casos de teste
        if randint(0, 2) == 0:  # inverte clock 1/3 de chance
            clock = 1 - clk.data
            clk.set(clock)
        else:  # inverte entrada 2/3 de chance
            data = 1 - a.data
            a.set(data)

        # x_clk_y
        file.write("{:1b}_{:1b}_{:1b}\n".format(a, clk, y))

    file.close()


if __name__ == '__main__':
    create_acc_tvs()
