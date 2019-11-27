from random import randint

from gm.addac import Addac
from gm.wire import Wire
from gm.wire_joiner import WireJoiner
from gm.wire_splitter import WireSplitter


class Addac4:
    def __init__(self, a: Wire, sel0: Wire, sel1: Wire, clk: Wire):
        # separa bits em 4 wires
        splitted = WireSplitter(a)

        addac0 = Addac(a=splitted.bits[0], sel0=sel0, sel1=sel1, clk=clk, cin=sel0)
        addac1 = Addac(a=splitted.bits[1], sel0=sel0, sel1=sel1, clk=clk, cin=addac0.cout)
        addac2 = Addac(a=splitted.bits[2], sel0=sel0, sel1=sel1, clk=clk, cin=addac1.cout)
        addac3 = Addac(a=splitted.bits[3], sel0=sel0, sel1=sel1, clk=clk, cin=addac2.cout)

        # junta os bits em 1 wire
        s_bits = [addac0.s, addac1.s, addac2.s, addac3.s]
        joiner = WireJoiner(s_bits)

        # saidas
        self.s = joiner.y
        self.cout = addac3.cout


def create_addac4_tvs():
    a = Wire()
    sel0 = Wire()
    sel1 = Wire()
    clk = Wire()
    addac4 = Addac4(a=a, sel0=sel0, sel1=sel1, clk=clk)

    file = open('../simulation_modelsim/addac4.tv', 'w')
    file.write("# sel0_sel1_a_clk_cout_s\n")

    for s0 in [0, 1]:
        sel0.set(s0)
        for s1 in [0, 1]:
            sel1.set(s1)
            for i in range(60):  # 60 casos de teste para cada função
                if randint(0, 2) == 0:  # inverte clock 1/3 de chance
                    clock = 1 - clk.data
                    clk.set(clock)
                else:  # inverte entrada 2/3 de chance
                    data = randint(0, 15)
                    a.set(data)

                file.write('{:1b}_{:1b}_{:04b}_{:1b}_{:1b}_{:04b}\n'.format(sel0, sel1, a, clk, addac4.cout, addac4.s))
    file.close()


if __name__ == '__main__':
    create_addac4_tvs()
