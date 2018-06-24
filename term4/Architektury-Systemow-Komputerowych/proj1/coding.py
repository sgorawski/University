"""Autor: Slawomir Gorawski"""

from enum import Enum, auto


class Coding(Enum):
    R_RD_RS_RT  = auto()
    R_RD_RT_RS  = auto()
    R_RD_RT_SA  = auto()
    R_RS_RT     = auto()
    R_RD        = auto()
    R_RS        = auto()
    I_RT_RS_IMM = auto()
    I_RT_IMM    = auto()
