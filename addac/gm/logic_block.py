from __future__ import annotations

from abc import abstractmethod
from typing import List, Dict

from gm.wire import Wire, WireListener


class LogicBlock(WireListener):
    def __init__(self, inputs: Dict[str, Wire], outputs: Dict[str, Wire]):
        self.inputs = inputs
        self.outputs = outputs
        for inp in inputs.values():
            inp.listen(self)

    def on_wire_change(self):
        values: Dict[str, int] = {k: v.data for k, v in self.inputs.items()}
        result = self.operation(values)
        for k, v in result.items():
            self.outputs[k].set(v)

    def add_input(self, name: str, a: Wire):
        if name in self.inputs:
            self.inputs[name].remove_listener(self)

        self.inputs[name] = a
        a.listen(self)

    @abstractmethod
    def operation(self, inputs: Dict[str, int]) -> Dict[str, int]:
        pass
