from typing import List, Dict, Optional

from data_path.gm.logic import Logic
from data_path.gm.logic_component import LogicComponent


class LogicBitsJoiner(LogicComponent):
    def __init__(self, bits: List[Logic], y: Logic):
        self.n_bits = y.n_bits
        super(LogicBitsJoiner, self).__init__({'bit{}'.format(i): bits[i] for i in range(self.n_bits)}, {'y': y})

    def operation(self, inputs: Dict[str, int]) -> Dict[str, Optional[int]]:
        bits = [getattr(inputs, 'bit{}'.format(i)) for i in range(self.n_bits)]
        for d in bits:
            if d is None:
                return {'y': None}
        out = 0
        for i in range(self.n_bits):
            out += (bits[i] << i)

        return {'y': out}
