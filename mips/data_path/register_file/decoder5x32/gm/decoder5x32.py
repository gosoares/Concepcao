from typing import Dict, Optional

from data_path.gm.logic import Logic
from data_path.gm.logic_component import LogicComponent


class Decoder5x32(LogicComponent):
    def __init__(self, a: Logic, y: Logic):
        super().__init__({'a': a}, {'y': y})

    def operation(self, inputs) -> Dict[str, Optional[int]]:
        if inputs.a is None:
            return {'y': None}
        y = 1 << inputs.a
        return {'y': y}


def create_decoder_tvs():
    a = Logic(5)
    y = Logic(32)
    decoder = Decoder5x32(a, y)

    #  d0_d1_sel_y
    file = open('../simulation/modelsim/decoder5x32.tv', 'w')

    for i in range(0b00000, 0b11111 + 1):
        a.set(i)
        decoder.write_in(file)

    file.close()


if __name__ == '__main__':
    create_decoder_tvs()
