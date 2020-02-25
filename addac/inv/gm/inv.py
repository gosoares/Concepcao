from typing import Dict

from gm.logic_block import LogicBlock
from gm.wire import Wire


class Inv(LogicBlock):
    def __init__(self, a: Wire, y: Wire):
        super().__init__({'x': a}, {'y': y})

    def operation(self, inputs: Dict[str, int]) -> Dict[str, int]:
        x = inputs['x']
        y = ~x & 1
        return {'y': y}


def create_inv_tvs():
    a = Wire()
    y = Wire()
    Inv(a, y)
    file = open('../simulation/modelsim/inv.tv', 'w')
    for i in [0, 1]:
        a.set(i)
        # a_y
        file.write("{:1b}_{:1b}\n".format(a, y))
    file.close()


if __name__ == '__main__':
    create_inv_tvs()
