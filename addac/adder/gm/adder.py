from typing import Dict

from gm.logic_block import LogicBlock
from gm.wire import Wire


class Adder(LogicBlock):
    def __init__(self, a: Wire, b: Wire, cin: Wire):
        inputs = {
            'a': a,
            'b': b,
            'cin': cin
        }
        super().__init__(inputs, ['y', 'cout'])
        self.cout = self.outputs['cout']

    def operation(self, inputs: Dict[str, int]) -> Dict[str, int]:
        a, b, cin = inputs['a'], inputs['b'], inputs['cin']

        p = a ^ b
        sum_ = p ^ cin
        cout = a & b | (p & cin)

        return {
            'y': sum_,
            'cout': cout
        }


def create_adder_tvs():
    a = Wire()
    b = Wire()
    cin = Wire()
    adder = Adder(a=a, b=b, cin=cin)

    file = open('../simulation_modelsim/adder.tv', 'w')
    file.write("# a_b_cin_cout_y\n")
    for i1 in [0, 1]:
        a.set(i1)
        for i2 in [0, 1]:
            b.set(i2)
            for c in [0, 1]:
                cin.set(c)
                file.write("{:1b}_{:1b}_{:1b}_{:1b}_{:1b}\n".format(a, b, cin, adder.cout, adder.y))
    file.close()


if __name__ == '__main__':
    create_adder_tvs()
