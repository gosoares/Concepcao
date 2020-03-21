from typing import Dict, Optional

from data_path.gm.logic import Logic
from data_path.gm.logic_component import LogicComponent

from random import randint


class ShiftLeft32(LogicComponent):
    def __init__(self, a: Logic, y: Logic):
        super().__init__({'a': a}, {'y': y})

    def operation(self, inputs) -> Dict[str, Optional[int]]:
        if inputs.a is None:
            return {'y': None}

        y = (inputs.a << 2) & 0xFFFFFFFF
        return {'y': y}


def create_shift_left_tvs():
    a, y = Logic(32), Logic(32)
    sl = ShiftLeft32(a, y)

    #  a_y
    file = open('../simulation/modelsim/shift_left32.tv', 'w')

    # testa com 20 numeros aleatorios
    for _ in range(20):
        a.set(randint(0, 0xFFFFFFFF))
        sl.write_in(file)

    file.close()


if __name__ == '__main__':
    create_shift_left_tvs()
