from typing import Dict

from gm.logic_block import LogicBlock
from gm.wire import Wire


class WireSplitter(LogicBlock):
    def __init__(self, a: Wire):
        bits_keys = ['bit{}'.format(i) for i in range(4)]
        super(WireSplitter, self).__init__({'a': a}, bits_keys)
        self.bits = [self.outputs[k] for k in bits_keys]

    def operation(self, inputs: Dict[str, int]) -> Dict[str, int]:
        a_bits = [(inputs['a'] >> x) & 1 for x in range(4)]
        return {'bit{}'.format(i): a_bits[i] for i in range(4)}
