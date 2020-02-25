from random import randint

from addac1.gm.addac import Addac
from gm.wire import Wire
from gm.wire_joiner import WireJoiner
from gm.wire_splitter import WireSplitter


class Addac4:
    def __init__(self,
                 a: Wire, sel0: Wire, sel1: Wire, clk: Wire,
                 s: Wire, cout: Wire
                 ):
        a_bits = [Wire() for _ in range(4)]
        WireSplitter(a, a_bits)
        s_bits = [Wire() for _ in range(4)]
        WireJoiner(s_bits, s)

        addacs_cout = [Wire() for _ in range(3)]

        Addac(
            a=a_bits[0], sel0=sel0, sel1=sel1, clk=clk, cin=sel0,
            s=s_bits[0], cout=addacs_cout[0]
        )
        Addac(
            a=a_bits[1], sel0=sel0, sel1=sel1, clk=clk, cin=addacs_cout[0],
            s=s_bits[1], cout=addacs_cout[1]
        )
        Addac(
            a=a_bits[2], sel0=sel0, sel1=sel1, clk=clk, cin=addacs_cout[1],
            s=s_bits[2], cout=addacs_cout[2]
        )
        Addac(
            a=a_bits[3], sel0=sel0, sel1=sel1, clk=clk, cin=addacs_cout[2],
            s=s_bits[3], cout=cout
        )


def create_addac4_tvs():
    a, sel0, sel1, clk = (Wire() for _ in range(4))
    s, cout = Wire(), Wire()
    Addac4(a=a, sel0=sel0, sel1=sel1, clk=clk, s=s, cout=cout)

    file = open('../simulation/modelsim/addac4.tv', 'w')
    file.write('0_0_0000_0_x_xxxx\n')
    file.write('0_0_0000_1_x_xxxx\n')
    file.write('0_0_0000_0_x_xxxx\n')

    for s0, s1 in [(0, 0), (1, 0)]:
        sel0.set(s0)
        sel1.set(s1)
        for i in range(120):  # 60 casos de teste para cada função
            if randint(0, 2) == 0:  # inverte clock 1/3 de chance
                clock = 1 - clk.data
                clk.set(clock)
            else:  # inverte entrada 2/3 de chance
                data = randint(0, 15)
                a.set(data)

            # sel0_sel1_a_clk_cout_s
            file.write('{:1b}_{:1b}_{:04b}_{:1b}_{:1b}_{:04b}\n'
                       .format(sel0, sel1, a, clk, cout, s))
    file.close()


if __name__ == '__main__':
    create_addac4_tvs()
