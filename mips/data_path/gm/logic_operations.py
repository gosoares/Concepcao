from typing import Dict, Optional

from data_path.gm.logic import Logic
from data_path.gm.logic_component import LogicComponent


class And(LogicComponent):
    def __init__(self, a: Logic, b: Logic, y: Logic):
        super().__init__({'a': a, 'b': b}, {'y': y})

    def operation(self, inputs) -> Dict[str, Optional[int]]:
        y = None
        if inputs.a is not None and inputs.b is not None:
            y = inputs.a & inputs.b
        return {'y': y}


class Or(LogicComponent):
    def __init__(self, a: Logic, b: Logic, y: Logic):
        super().__init__({'a': a, 'b': b}, {'y': y})

    def operation(self, inputs) -> Dict[str, Optional[int]]:
        y = None
        if inputs.a is not None and inputs.b is not None:
            y = inputs.a | inputs.b
        return {'y': y}


class Nor(LogicComponent):
    def __init__(self, a: Logic, b: Logic, y: Logic):
        super().__init__({'a': a, 'b': b}, {'y': y})

    def operation(self, inputs) -> Dict[str, Optional[int]]:
        y = None
        if inputs.a is not None and inputs.b is not None:
            y = ~(inputs.a | inputs.b)
        return {'y': y}


class Xor(LogicComponent):
    def __init__(self, a: Logic, b: Logic, y: Logic):
        super().__init__({'a': a, 'b': b}, {'y': y})

    def operation(self, inputs) -> Dict[str, Optional[int]]:
        y = None
        if inputs.a is not None and inputs.b is not None:
            y = inputs.a ^ inputs.b
        return {'y': y}
