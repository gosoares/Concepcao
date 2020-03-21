from typing import Dict, Optional

from data_path.gm.logic import Logic
from data_path.gm.logic_component import LogicComponent


class FullAdder(LogicComponent):
    def __init__(self, a: Logic, b: Logic, cin: Logic, s: Logic, cout: Logic):
        inputs = {'a': a, 'b': b, 'cin': cin}
        outputs = {'y': s, 'cout': cout}
        super().__init__(inputs, outputs)

    def operation(self, inputs) -> Dict[str, Optional[int]]:
        if inputs.a is None or inputs.b is None or inputs.cin is None:
            return {'y': None, 'cout': None}

        a, b, cin = inputs.a, inputs.b, inputs.cin

        p = a ^ b
        sum_ = p ^ cin
        cout = a & b | (p & cin)

        return {
            'y': sum_,
            'cout': cout
        }


def create_full_adder_tvs():
    a, b, cin, y, cout = Logic(1), Logic(1), Logic(1), Logic(1), Logic(1)
    fa = FullAdder(a=a, b=b, cin=cin, s=y, cout=cout)

    file = open('../simulation/modelsim/full_adder.tv', 'w')
    for i1 in [0, 1]:
        a.set(i1)
        for i2 in [0, 1]:
            b.set(i2)
            for c in [0, 1]:
                cin.set(c)
                fa.write_in(file)
    file.close()


if __name__ == '__main__':
    create_full_adder_tvs()
