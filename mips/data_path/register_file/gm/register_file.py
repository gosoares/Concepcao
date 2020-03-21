from typing import List

from data_path.decoder5x32.gm.decoder5x32 import Decoder5x32
from data_path.flopenr.gm.flopenr import FlopEnR
from data_path.gm.logic import Logic
from data_path.gm.logic_operations import And
from data_path.gm.logic_bits_joiner import LogicBitsJoiner
from data_path.gm.logic_bits_splitter import LogicBitsSplitter
from data_path.mux32.gm.mux32 import Mux32


class RegisterFile:
    def __init__(self, RegA: Logic, RegB: Logic, RegC: Logic, clk: Logic, reset: Logic, dataIn: Logic, RegWrite: Logic,
                 RD1: Logic, RD2: Logic):
        # decode write address
        writeAddress = Logic(32)
        writeReg: List[Logic] = [Logic(1) for _ in range(32)]  # 32 bits of write address
        Decoder5x32(RegC, writeAddress)
        LogicBitsSplitter(writeAddress, writeReg)

        # create registers
        registersOut = [Logic(1) for _ in range(32)]
        for i in range(32):
            writeEnable = Logic(1)
            And(RegWrite, writeReg[i], writeEnable)
            FlopEnR(clk=clk, en=writeEnable, rst=reset, d=dataIn, q=registersOut[i])

        # create muxes
        muxIn = Logic(32)
        LogicBitsJoiner(registersOut, muxIn)
        Mux32(muxIn, RegA, RD1)
        Mux32(muxIn, RegB, RD2)


def create_register_file_tvs():
    RegA, RegB, RegC = Logic(5), Logic(5), Logic(5)
    clk, reset, dataIn, RegWrite = Logic(1), Logic(1), Logic(1), Logic(1)
    RD1, RD2 = Logic(1), Logic(1)

    RegisterFile(RegA, RegB, RegC, clk, reset, dataIn, RegWrite, RD1, RD2)

    #  RegA_RegB_RegC_clk_reset_dataIn_RegWrite_RD1_RD2
    file = open('../simulation/modelsim/register_file.tv', 'w')

    def write_vector():
        file.write('{}_{}_{}_{}_{}_{}_{}_{}_{}\n'.format(RegA, RegB, RegC, clk, reset, dataIn, RegWrite, RD1, RD2))

    # initialize
    RegA.set(1), RegB.set(1), RegC.set(1), clk.set(0), reset.set(0), dataIn.set(0), RegWrite.set(0), write_vector()

    # reset
    reset.set(1), clk.set(1), write_vector()
    clk.set(0), write_vector()
    clk.set(1), reset.set(0), write_vector()

    # set 1 and read
    RegWrite.set(1), dataIn.set(1)
    for i in range(32):
        RegC.set(i), clk.set(0), RegA.set(i), write_vector()
        clk.set(1), write_vector()
        clk.set(0), RegB.set(i), write_vector()
        clk.set(1), write_vector()

    file.close()


if __name__ == '__main__':
    create_register_file_tvs()
