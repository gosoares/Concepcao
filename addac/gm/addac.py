from random import randint

from acc.gm.acc import Acc
from adder.gm.adder import Adder
from gm.wire import Wire
from inv.gm.inverter import Inverter
from mux.gm.mux import Mux


class Addac:
    def __init__(self, a: Wire, sel0: Wire, sel1: Wire, clk: Wire):
        inv = Inverter(a)
        mux0 = Mux(data1=a, data2=inv.y, sel=sel0)
        adder = Adder(a=mux0.y, cin=sel0, b=Wire())
        mux1 = Mux(data1=mux0.y, data2=adder.y, sel=sel1)
        acc = Acc(x=mux1.y, clk=clk)
        adder.add_input('b', acc.y)

        self.s = mux1.y
        self.cout = adder.cout
        self.acc = acc.y


def main():
    a = Wire()
    sel0 = Wire()
    sel1 = Wire()
    clk = Wire()
    addac = Addac(a=a, sel0=sel0, sel1=sel1, clk=clk)

    file = open('addac.tv', 'w')
    file.write("# a_sel0_sel1_clk_cout_s\n")

    for s0 in [0, 1]:
        sel0.set(s0)
        for s1 in [0, 1]:
            sel1.set(s1)
            for i in range(50):  # 50 casos de teste para cada função
                if randint(0, 2) == 0:  # inverte clock 1/3 de chance
                    clock = 1 - clk.data
                    clk.set(clock)
                else:  # muda entrada 2/3 de chance
                    data = randint(0, 15)
                    a.set(data)

                file.write('{:04b}_{:1b}_{:1b}_{:1b}_{:1b}_{:04b}\n'.format(a, sel0, sel1, clk, addac.cout, addac.s))
    file.close()
    return


if __name__ == '__main__':
    main()
