from data_path.gm.logic import Logic
from data_path.gm.logic_bits_splitter import LogicBitsSplitter
from data_path.mux2.gm.mux2 import Mux2


class Mux4:
    def __init__(self, d0: Logic, d1: Logic, d2: Logic, d3: Logic, sel: Logic, y: Logic):
        # separa os bits do sel
        sel0, sel1 = Logic(1), Logic(1)
        LogicBitsSplitter(sel, [sel0, sel1])

        # conecta 3 mux2 para format o mux4
        mux0_y, mux1_y = Logic(1), Logic(1)
        Mux2(d0, d1, sel0, mux0_y)
        Mux2(d2, d3, sel0, mux1_y)
        Mux2(mux0_y, mux1_y, sel1, y)


def create_mux4_tvs():
    d0, d1, d2, d3 = Logic(1), Logic(1), Logic(1), Logic(1)
    sel, y = Logic(2), Logic(1)

    Mux4(d0, d1, d2, d3, sel, y)

    #  d0_d1_d2_d3_sel_y
    file = open('../simulation/modelsim/mux4.tv', 'w')

    def write_vector():
        file.write('{}_{}_{}_{}_{:02b}_{}\n'.format(d0, d1, d2, d3, sel, y))

    for id0 in [0, 1]:
        d0.set(id0)
        for id1 in [0, 1]:
            d1.set(id1)
            for id2 in [0, 1]:
                d2.set(id2)
                for id3 in [0, 1]:
                    d3.set(id3)
                    for isel in range(4):
                        sel.set(isel)
                        write_vector()

    file.close()


if __name__ == '__main__':
    create_mux4_tvs()
