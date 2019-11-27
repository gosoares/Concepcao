from typing import Dict

from gm.logic_block import LogicBlock
from gm.wire import Wire


class Inverter(LogicBlock):
    def __init__(self, input_: Wire):
        super().__init__({'x': input_}, ['y'])

    def operation(self, inputs: Dict[str, int]) -> Dict[str, int]:
        x = inputs['x']
        y = ~x & 1
        return {'y': y}


def create_inverter_tvs():
    a = Wire()
    inverter = Inverter(a)
    file = open('../simulation_modelsim/inverter.tv', 'w')
    file.write("# a_y\n")
    for i in [0, 1]:
        a.set(i)
        file.write("{:1b}_{:1b}\n".format(a, inverter.y))
    file.close()


if __name__ == '__main__':
    create_inverter_tvs()
