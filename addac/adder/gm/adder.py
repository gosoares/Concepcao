from typing import Dict

from gm.logic_block import LogicBlock
from gm.wire import Wire


class Adder(LogicBlock):
    def __init__(self, a: Wire, b: Wire, cin: Wire, s: Wire, cout: Wire):
        inputs = {'a': a, 'b': b, 'cin': cin}
        outputs = {'y': s, 'cout': cout}
        super().__init__(inputs, outputs)

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
    y = Wire()
    cout = Wire()
    Adder(a=a, b=b, cin=cin, s=y, cout=cout)

    file = open('../simulation/modelsim/adder.tv', 'w')
    for i1 in [0, 1]:
        a.set(i1)
        for i2 in [0, 1]:
            b.set(i2)
            for c in [0, 1]:
                cin.set(c)
                # a_b_cin_cout_y
                file.write("{:1b}_{:1b}_{:1b}_{:1b}_{:1b}\n".format(a, b, cin, cout, y))
    file.close()


if __name__ == '__main__':
    create_adder_tvs()
