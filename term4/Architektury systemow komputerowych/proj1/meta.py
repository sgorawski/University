"""Autor: Slawomir Gorawski"""

from typing import NamedTuple

from data import OPCODE, FUNCT


class R(NamedTuple):
    name: str
    rd: int = 0
    rs: int = 0
    rt: int = 0
    shamt: int = 0

    def encode(self) -> str:
        return ("%0.8X" % (
            (self.rs << 21)
             + (self.rt << 16)
             + (self.rd << 11)
             + (self.shamt << 6)
             + FUNCT[self.name]
        ))


class I(NamedTuple):
    name: str
    rt: int = 0
    rs: int = 0
    immediate: int = 0

    def encode(self) -> str:
        return ("%0.8X" % (
            (OPCODE[self.name] << 26)
            + (self.rs << 21)
            + (self.rt << 16)
            + (self.immediate & 0xFFFF)
        ))


class RRdRsRt(R):
    def __new__(cls: R, name: str, rd: int, rs: int, rt: int) -> R:
        return super().__new__(cls, name=name, rd=rd, rs=rs, rt=rt)


class RRdRtRs(R):
    def __new__(cls: R, name: str, rd: int, rt: int, rs: int) -> R:
        return super().__new__(cls, name=name, rd=rd, rt=rt, rs=rs)


class RRdRtSa(R):
    def __new__(cls: R, name: str, rd: int, rt: int, sa: int) -> R:
        return super().__new__(cls, name=name, rd=rd, rt=rt, shamt=sa)


class RRsRt(R):
    def __new__(cls: R, name: str, rs: int, rt: int) -> R:
        return super().__new__(cls, name=name, rs=rs, rt=rt)


class RRd(R):
    def __new__(cls: R, name: str, rd: int) -> R:
        return super().__new__(cls, name=name, rd=rd)


class RRs(R):
    def __new__(cls: R, name: str, rs: int) -> R:
        return super().__new__(cls, name=name, rs=rs)


class IRtRsImm(I):
    def __new__(cls: I, name: str, rt: int, rs: int, imm: int) -> I:
        return super().__new__(cls, name=name, rt=rt, rs=rs, immediate=imm)


class IRtImm(I):
    def __new__(cls: I, name: str, rt: int, imm: int) -> I:
        return super().__new__(cls, name=name, rt=rt, immediate=imm)
