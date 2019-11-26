from __future__ import annotations

from typing import Dict

from gm.logic_block import LogicBlock
from gm.wire import Wire


class Mux(LogicBlock):
    def __init__(self, data1: Wire, data2: Wire, sel: Wire):
        inputs = {
            'd1': data1,
            'd2': data2,
            'sel': sel,
        }
        super().__init__(inputs, ['y'])

    def operation(self, inputs: Dict[str, int]) -> Dict[str, int]:
        if inputs['sel'] == 0:
            return {'y': inputs['d1']}
        else:
            return {'y': inputs['d2']}


def create_mux_tvs():
    d1 = Wire()
    d2 = Wire()
    sel = Wire()
    mux = Mux(data1=d1, data2=d2, sel=sel)

    data_test = [0b0000, 0b1111, 0b1010, 0b0101, 0b0011, 0b1100]

    file = open('mux.tv', 'w')
    file.write("# d1_d2_sel_y\n")
    for i1 in data_test:
        d1.set(i1)
        for i2 in data_test:
            d2.set(i2)
            for s in [0, 1]:
                sel.set(s)
                file.write("{:04b}_{:04b}_{:1b}_{:04b}\n".format(i1, i2, s, mux.y.data))
    file.close()


if __name__ == '__main__':
    create_mux_tvs()
