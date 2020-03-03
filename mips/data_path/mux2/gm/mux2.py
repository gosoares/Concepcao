from typing import Dict, Optional

from data_path.gm.logic import Logic
from data_path.gm.logic_component import LogicComponent


class Mux2(LogicComponent):
    def __init__(self, d0: Logic, d1: Logic, sel: Logic, y: Logic):
        super().__init__(inputs={'d0': d0, 'd1': d1, 'sel': sel}, outputs={'y': y})

    def operation(self, inputs) -> Dict[str, Optional[int]]:
        y = inputs.d0 if inputs.sel == 0 else inputs.d1
        return {'y': y}


def create_mux2_tvs():
    d0, d1, sel, y = Logic(1), Logic(1), Logic(1), Logic(1)
    mux2 = Mux2(d0, d1, sel, y)

    #  d0_d1_sel_y
    file = open('../simulation/modelsim/mux2.tv', 'w')

    for id0 in [0, 1]:
        d0.set(id0)
        for id1 in [0, 1]:
            d1.set(id1)
            for isel in [0, 1]:
                sel.set(isel)
                mux2.write_in(file)

    file.close()


if __name__ == '__main__':
    create_mux2_tvs()
