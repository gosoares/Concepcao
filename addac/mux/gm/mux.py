from __future__ import annotations

from typing import Dict

from gm.logic_block import LogicBlock
from gm.wire import Wire


class Mux(LogicBlock):
    def __init__(self, d0: Wire, d1: Wire, sel: Wire):
        inputs = {
            'd0': d0,
            'd1': d1,
            'sel': sel,
        }
        super().__init__(inputs, ['y'])

    def operation(self, inputs: Dict[str, int]) -> Dict[str, int]:
        if inputs['sel'] == 0:
            return {'y': inputs['d0']}
        else:
            return {'y': inputs['d1']}


def create_mux_tvs():
    d0 = Wire()
    d1 = Wire()
    sel = Wire()
    mux = Mux(d0=d0, d1=d1, sel=sel)

    file = open('../simulation_modelsim/mux.tv', 'w')
    file.write("# d0_d1_sel_y\n")
    for i0 in [0, 1]:
        d0.set(i0)
        for i1 in [0, 1]:
            d1.set(i1)
            for s in [0, 1]:
                sel.set(s)
                file.write("{:1b}_{:1b}_{:1b}_{:1b}\n".format(d0, d1, sel, mux.y))
    file.close()


if __name__ == '__main__':
    create_mux_tvs()
