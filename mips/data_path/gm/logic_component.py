from __future__ import annotations

from abc import abstractmethod
from collections import namedtuple
from typing import Dict, Optional, TextIO

from data_path.gm.logic import Logic, LogicListener


class LogicComponent(LogicListener):
    def __init__(self, inputs: Dict[str, Logic], outputs: Dict[str, Logic]):
        self.inputs = inputs
        self.outputs = outputs
        for inp in inputs.values():
            inp.listen(self)

    def notify(self):
        values: Dict[str, Optional[int]] = {k: v.data for k, v in self.inputs.items()}
        Inputs = namedtuple('Inputs', values)
        result = self.operation(Inputs(**values))
        for k, v in result.items():
            self.outputs[k].set(v)

    def add_input(self, name: str, a: Logic):
        if name in self.inputs:
            self.inputs[name].remove_listener(self)

        self.inputs[name] = a
        a.listen(self)

    @abstractmethod
    def operation(self, inputs) -> Dict[str, Optional[int]]:
        pass

    def __str__(self):
        i = '_'.join(map(str, self.inputs.values()))
        o = '_'.join(map(str, self.outputs.values()))
        return '{}_{}'.format(i, o)

    def write_in(self, file: TextIO):
        file.write('{}\n'.format(self))

