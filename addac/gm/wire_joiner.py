from typing import Dict
from typing import List

from gm.logic_block import LogicBlock
from gm.wire import Wire


class WireJoiner(LogicBlock):
    def __init__(self, bits: List[Wire], y: Wire):
        super(WireJoiner, self).__init__({'bit{}'.format(i): bits[i] for i in range(4)}, {'y': y})

    def operation(self, inputs: Dict[str, int]) -> Dict[str, int]:
        bits = [inputs['bit{}'.format(i)] for i in range(4)]
        out = 0
        for i in range(4):
            out += (bits[i] << i)

        return {'y': out}
