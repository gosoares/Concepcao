from typing import List, Dict

from data_path.gm.logic import Logic
from data_path.gm.logic_component import LogicComponent


class LogicBitsSplitter(LogicComponent):
    def __init__(self, a: Logic, bits: List[Logic]):
        self.a_bits = a.n_bits
        bits_out = {'bit{}'.format(i): bits[i] for i in range(self.a_bits)}
        super().__init__({'a': a}, bits_out)

    def operation(self, inputs) -> Dict[str, int]:
        if inputs.a is None:
            a_bits = [None for _ in range(self.a_bits)]
        else:
            a_bits = [(inputs.a >> x) & 1 for x in range(self.a_bits)]
        return {'bit{}'.format(i): a_bits[i] for i in range(self.a_bits)}

