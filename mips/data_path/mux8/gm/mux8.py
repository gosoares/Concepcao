from typing import List

from data_path.gm.logic import Logic
from data_path.gm.logic_bits_joiner import LogicBitsJoiner
from data_path.gm.logic_bits_splitter import LogicBitsSplitter
from data_path.mux2.gm.mux2 import Mux2
from data_path.mux4.gm.mux4 import Mux4


class Mux8:
    def __init__(self, d: Logic, sel: Logic, y: Logic):
        if d.n_bits != 8 or sel.n_bits != 3 or y.n_bits != 1:
            raise ValueError()

        # separa os bits do d
        ds: List[Logic] = [Logic(1) for _ in range(8)]
        LogicBitsSplitter(d, ds)
        # separa os bits do sel
        sels: List[Logic] = [Logic(1) for _ in range(3)]
        LogicBitsSplitter(sel, sels)

        ymux = [Logic(1), Logic(1)]  # saida dos mux 4
        selm1 = Logic(2)
        LogicBitsJoiner(sels[0:2], selm1)
        for m in range(2):
            Mux4(ds[4 * m + 0], ds[4 * m + 1], ds[4 * m + 2], ds[4 * m + 3], selm1, ymux[m])

        # mux2 no final
        Mux2(ymux[0], ymux[1], sels[2], y)


def create_mux8_tvs():
    d, sel, y = Logic(8), Logic(3), Logic(1)

    Mux8(d, sel, y)

    #  d0_d1_d2_d3_sel_y
    file = open('../simulation/modelsim/mux8.tv', 'w')

    def write_vector():
        file.write('{:08b}_{:03b}_{:01b}\n'.format(d, sel, y))

    # test only selected = 1
    for dsel in range(8):
        data = 1 << dsel
        sel.set(dsel)
        d.set(data)
        write_vector()

    # test only selected = 0
    for dsel in range(8):
        data = ~(1 << dsel) & (2 ** 8 - 1)
        sel.set(dsel)
        d.set(data)
        write_vector()

    file.close()


if __name__ == '__main__':
    create_mux8_tvs()
