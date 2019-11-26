from typing import Dict

from gm.logic_block import LogicBlock
from gm.wire import Wire


class Inverter(LogicBlock):
    def __init__(self, input_: Wire):
        super().__init__({'x': input_}, ['y'])

    def operation(self, inputs: Dict[str, int]) -> Dict[str, int]:
        x = inputs['x']
        y = ~x & 0b1111
        return {'y': y}


def create_inverter_tvs():
    inp = Wire()
    inverter = Inverter(inp)
    file = open('inverter.tv', 'w')
    file.write("# a_y\n")
    for i in range(0, 2**4):
        inp.set(i)
        file.write("{:04b}_{:04b}\n".format(i, inverter.y.data))
    file.close()


if __name__ == '__main__':
    create_inverter_tvs()
