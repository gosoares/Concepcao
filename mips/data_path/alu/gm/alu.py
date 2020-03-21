from typing import List

from data_path.full_adder.gm.full_adder import FullAdder
from data_path.gm.logic import Logic
from data_path.gm.logic_bits_joiner import LogicBitsJoiner
from data_path.gm.logic_bits_splitter import LogicBitsSplitter
from data_path.gm.logic_operations import And, Or, Nor, Xor
from data_path.mux8.gm.mux8 import Mux8


class ALU:
    def __init__(self, a: Logic, b: Logic, op: Logic, slt_in: Logic, adder_cin: Logic,
                 adder_cout: Logic, adder_s: Logic, result: Logic):
        and_out, or_out, nor_out, xor_out = Logic(1), Logic(1), Logic(1), Logic(1)
        And(a, b, and_out)
        Or(a, b, or_out)
        Nor(a, b, nor_out)
        Xor(a, b, xor_out)

        op_bits: List[Logic] = [Logic(1) for _ in range(3)]
        LogicBitsSplitter(op, op_bits)  # divide bits do op

        adder_b = Logic(1)
        Xor(b, op_bits[0], adder_b)  # se op = sub nega o b
        FullAdder(a=a, b=adder_b, cin=adder_cin, s=adder_s, cout=adder_cout)

        muxIn, zero = Logic(8), Logic(1)
        zero.set(0)
        LogicBitsJoiner([and_out, or_out, adder_s, xor_out, zero, nor_out, adder_s, slt_in], muxIn)
        Mux8(muxIn, op, result)


def create_alu_tvs():
    a, b, op, slt = Logic(1), Logic(1), Logic(3), Logic(1)
    adder_cin, adder_cout, adder_s = Logic(1), Logic(1), Logic(1)
    slt.set(0)
    result = Logic(1)
    ALU(a, b, op, slt, adder_cin, adder_cout, adder_s, result)

    #  d0_d1_d2_d3_sel_y
    file = open('../simulation/modelsim/alu.tv', 'w')

    def write_vector():
        file.write('{:01b}_{:01b}_{:03b}_{:01b}_{:01b}_{:01b}_{:01b}_{:01b}\n'
                   .format(a, b, op, slt, adder_cin, adder_cout, adder_s, result))

    for iop in [0b010, 0b110, 0b000, 0b001, 0b101, 0b011, 0b111]:  # testa vez cada operacao
        op.set(iop)
        for ia in [0, 1]:
            a.set(ia)
            for ib in [0, 1]:
                b.set(ib)
                for icin in [0, 1]:
                    adder_cin.set(icin)
                    write_vector()

    file.close()


if __name__ == '__main__':
    create_alu_tvs()
