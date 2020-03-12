from data_path.gm.logic import Logic
from data_path.gm.logic_bits_joiner import LogicBitsJoiner
from data_path.gm.logic_bits_splitter import LogicBitsSplitter
from typing import List

from data_path.mux2.gm.mux2 import Mux2
from data_path.mux4.gm.mux4 import Mux4


class Mux32:
    def __init__(self, d: Logic, sel: Logic, y: Logic):
        # separa os 32 bits do d
        ds: List[Logic] = [Logic(1) for _ in range(32)]
        LogicBitsSplitter(d, ds)
        # separa os bits do sel
        sels: List[Logic] = [Logic(1) for _ in range(5)]
        LogicBitsSplitter(sel, sels)

        # saida dos mux intermediarios
        ymux1: List[Logic] = [Logic(1) for _ in range(8)]
        ymux2: List[Logic] = [Logic(1) for _ in range(2)]

        # primeira camada de muxes
        selm1 = Logic(2)
        LogicBitsJoiner(sels[0:2], selm1)
        for m in range(8):
            Mux4(ds[4 * m + 0], ds[4 * m + 1], ds[4 * m + 2], ds[4 * m + 3], selm1, ymux1[m])

        # segunda camada de bits
        selm2 = Logic(2)
        LogicBitsJoiner(sels[2:4], selm2)
        for m in range(2):
            Mux4(ymux1[4 * m + 0], ymux1[4 * m + 1], ymux1[4 * m + 2], ymux1[4 * m + 3], selm2, ymux2[m])

        # ultimo mux
        Mux2(ymux2[0], ymux2[1], sels[4], y)


def create_mux32_tvs():
    d, sel, y = Logic(32), Logic(5), Logic(1)

    Mux32(d, sel, y)

    #  d0_d1_d2_d3_sel_y
    file = open('../simulation/modelsim/mux32.tv', 'w')

    def write_vector():
        file.write('{:032b}_{:05b}_{:01b}\n'.format(d, sel, y))

    # test only selected = 1
    for dsel in range(32):
        data = 1 << dsel
        sel.set(dsel)
        d.set(data)
        write_vector()

    # test only selected = 0
    for dsel in range(32):
        data = ~(1 << dsel) & (2 ** 32 - 1)
        sel.set(dsel)
        d.set(data)
        write_vector()

    file.close()


if __name__ == '__main__':
    create_mux32_tvs()
