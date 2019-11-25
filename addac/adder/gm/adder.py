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
        sum_ = inputs['a'] + inputs['b'] + inputs['cin']
        cout = sum_ >> 4
        y = sum_ & 0b1111
        return {
            'y': y,
            'cout': cout
        }


def main():
    a = Wire()
    b = Wire()
    cin = Wire()
    adder = Adder(a=a, b=b, cin=cin)
    data_test = [0b0000, 0b1111, 0b1010, 0b0101, 0b0011, 0b1100]

    file = open('adder.tv', 'w')
    file.write("# a_b_cin_y_cout\n")
    for i1 in data_test:
        a.set(i1)
        for i2 in data_test:
            b.set(i2)
            for c in [0, 1]:
                cin.set(c)
                file.write("{:04b}_{:04b}_{:1b}_{:04b}_{:1b}\n".format(i1, i2, c, adder.y, adder.cout))
    file.close()


if __name__ == '__main__':
    main()
