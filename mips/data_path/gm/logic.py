from __future__ import annotations

from abc import ABC, abstractmethod
from typing import List, Optional


class Logic:
    def __init__(self, n_bits: int):
        self.data: Optional[int] = None
        self.n_bits = n_bits
        self.listeners: List[LogicListener] = []

    def listen(self, listener: LogicListener):
        listener.notify()
        self.listeners.append(listener)

    def remove_listener(self, listener: LogicListener):
        self.listeners.remove(listener)

    def notify_listeners(self):
        for listener in self.listeners:
            listener.notify()

    def set(self, data: Optional[int]):
        if data is None:
            self.data = None
        else:
            self.data = data & (2 ** self.n_bits - 1)
        self.notify_listeners()

    def __str__(self):
        if self.data is None:
            return 'x' * self.n_bits
        return format(self.data, '0{}b'.format(self.n_bits))

    def __format__(self, format_spec):
        if self.data is None:
            return 'x' * self.n_bits
        return format(self.data, format_spec)


class LogicListener(ABC):
    @abstractmethod
    def notify(self):
        pass
