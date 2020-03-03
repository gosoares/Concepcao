from typing import Dict

from data_path.gm.logic import Logic
from data_path.gm.logic_component import LogicComponent
from random import randint


class FlopR(LogicComponent):
    def __init__(self, clk: Logic, rst: Logic, d: Logic, q: Logic):
        self.lastClk = 0
        super().__init__(inputs={'clk': clk, 'rst': rst, 'd': d}, outputs={'q': q})

    def operation(self, inputs) -> Dict[str, int]:
        output: Dict = {}
        if inputs.rst == 1:
            output['q'] = 0
        elif inputs.clk == 1 and self.lastClk == 0:
            output['q'] = inputs.d

        self.lastClk = inputs.clk
        return output


# noinspection DuplicatedCode
def create_flopr_tvs():
    clk, rst, d, q = Logic(1), Logic(1), Logic(1), Logic(1)

    flopr = FlopR(clk, rst, d, q)

    #  clk_rst_d_q
    out = open('../simulation/modelsim/flopr.tv', 'w')

    # init
    clk.set(0), rst.set(0), d.set(0), flopr.write_in(out)

    # test reset
    rst.set(1), d.set(1), clk.set(1), flopr.write_in(out)
    clk.set(0), flopr.write_in(out)
    clk.set(1), flopr.write_in(out)

    rst.set(0)
    # test data
    for i in range(15):  # gera 15 casos de teste
        if randint(0, 2) == 0:  # inverte dado 1/3 de chance
            data = 1 - d.data
            d.set(data)
        else:  # inverte clock 2/3 de chance
            clock = 1 - clk.data
            clk.set(clock)

        # x_clk_y
        flopr.write_in(out)

    out.close()


if __name__ == '__main__':
    create_flopr_tvs()
