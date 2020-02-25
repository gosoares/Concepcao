from random import randint

from acc.gm.acc import Acc
from adder.gm.adder import Adder
from gm.wire import Wire
from inv.gm.inv import Inv
from mux.gm.mux import Mux


class Addac:
    def __init__(self, a: Wire, sel0: Wire, sel1: Wire, clk: Wire, cin: Wire, s: Wire, cout: Wire):
        a_inv = Wire()
        Inv(a=a, y=a_inv)

        mux0_y = Wire()
        Mux(d0=a, d1=a_inv, sel=sel0, y=mux0_y)

        acc_y, adder_y = Wire(), Wire()
        Adder(a=mux0_y, b=acc_y, cin=cin, s=adder_y, cout=cout)

        Mux(d0=mux0_y, d1=adder_y, sel=sel1, y=s)

        Acc(a=s, clk=clk, y=acc_y)


def create_addac_tvs():
    a, sel0, sel1, clk = Wire(), Wire(), Wire(), Wire()
    s, cout = Wire(), Wire()
    Addac(a=a, sel0=sel0, sel1=sel1, clk=clk, s=s, cout=cout, cin=sel0)

    file = open('../simulation/modelsim/addac.tv', 'w')
    # borda de subida no começo para inicializar o acumulador
    file.write('0_0_0_0_x_x\n')
    file.write('0_0_0_1_x_x\n')
    file.write('0_0_0_0_x_x\n')

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

                # sel0_sel1_a_clk_cout_s
                file.write('{:1b}_{:1b}_{:1b}_{:1b}_{:1b}_{:1b}\n'.format(sel0, sel1, a, clk, cout, s))
    file.close()
    return


if __name__ == '__main__':
    create_addac_tvs()
