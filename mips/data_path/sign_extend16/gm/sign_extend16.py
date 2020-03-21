from typing import Dict, Optional

from data_path.gm.logic import Logic
from data_path.gm.logic_component import LogicComponent
from random import randint


class SignExtend16(LogicComponent):
    def __init__(self, a: Logic, y: Logic):
        if a.n_bits != 16:
            raise ValueError('a must have 16 bits')
        if y.n_bits != 32:
            raise ValueError('y must have 32 bits')
        super().__init__({'a': a}, {'y': y})

    def operation(self, inputs) -> Dict[str, Optional[int]]:
        if inputs.a is None:
            return {'y': None}

        lastBit = inputs.a >> 15
        return {'y': inputs.a + lastBit * 0xFFFF0000}


def create_sign_extend_tvs():
    a, y = Logic(16), Logic(32)
    se = SignExtend16(a, y)

    #  a_y
    file = open('../simulation/modelsim/sign_extend16.tv', 'w')

    # testa 10 numeros positivos aleatorios
    for _ in range(10):
        a.set(randint(0, 0x7FFF))
        se.write_in(file)

    # testa 10 numeros negativos aleatorios
    for _ in range(10):
        a.set(randint(0x8000, 0xFFFF))
        se.write_in(file)

    file.close()


if __name__ == '__main__':
    create_sign_extend_tvs()
