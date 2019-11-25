from __future__ import annotations

from abc import ABC, abstractmethod
from typing import List, Callable


class Wire:
    def __init__(self):
        self.data: int = 0
        self.listeners: List[WireListener] = []

    def listen(self, listener: WireListener):
        listener.on_wire_change()
        self.listeners.append(listener)

    def remove_listener(self, listener: WireListener):
        self.listeners.remove(listener)

    def notify_listeners(self):
        for listener in self.listeners:
            listener.on_wire_change()

    def set(self, data: int):
        self.data = data
        self.notify_listeners()

    def __str__(self):
        return format(self.data, '04b')

    def __format__(self, format_spec):
        return format(self.data, format_spec)


class WireListener(ABC):
    @abstractmethod
    def on_wire_change(self):
        pass
