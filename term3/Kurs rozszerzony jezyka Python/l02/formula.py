from abc import ABC, abstractmethod


class Formula(ABC):
    """
    Used module abc for cleaner syntax - alternative solution
    would be to raise exceptions in methods
    """

    @abstractmethod
    def __str__(self):
        pass

    @abstractmethod
    def evaluate(self, vars_values):
        pass
