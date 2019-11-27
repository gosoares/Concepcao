from random import randint

from acc.gm.acc import Acc
from adder.gm.adder import Adder
from gm.wire import Wire
from inv.gm.inverter import Inverter
from mux.gm.mux import Mux


class Addac:
    def __init__(self, a: Wire, sel0: Wire, sel1: Wire, clk: Wire, cin: Wire = None):
        inv = Inverter(a)
        mux0 = Mux(d0=a, d1=inv.y, sel=sel0)
        adder_cin = sel0 if cin is None else cin
        adder = Adder(a=mux0.y, cin=adder_cin, b=Wire())
        mux1 = Mux(d0=mux0.y, d1=adder.y, sel=sel1)
        acc = Acc(x=mux1.y, clk=clk)
        adder.add_input('b', acc.y)

        self.s = mux1.y
        self.cout = adder.cout


def create_addac_tvs():
    a = Wire()
    sel0 = Wire()
    sel1 = Wire()
    clk = Wire()
    addac = Addac(a=a, sel0=sel0, sel1=sel1, clk=clk)

    file = open('../simulation_modelsim/addac.tv', 'w')
    file.write("# sel0_sel1_a_clk_cout_s\n")

    for s0 in [0, 1]:
        sel0.set(s0)
        for s1 in [0, 1]:
            sel1.set(s1)
            for i in range(15):  # 15 casos de teste para cada função
                if randint(0, 2) == 0:  # inverte clock 1/3 de chance
                    clock = 1 - clk.data
                    clk.set(clock)
                else:  # inverte entrada 2/3 de chance
                    data = 1 - a.data
                    a.set(data)

                file.write('{:1b}_{:1b}_{:1b}_{:1b}_{:1b}_{:1b}\n'.format(sel0, sel1, a, clk, addac.cout, addac.s))
    file.close()
    return


if __name__ == '__main__':
    create_addac_tvs()
