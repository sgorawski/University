"""Autor: Slawomir Gorawski"""

from typing import NamedTuple, List

from coding import Coding
from data import INSTRUCTION_CODINGS


class Token(NamedTuple):
    coding: Coding
    instruction: str
    operands: List[int]


def get_coding(instruction: str) -> Coding:
    for coding, instructions in INSTRUCTION_CODINGS.items():
        if instruction in instructions:
            return coding


def parse_register(reg: str) -> int:
    try:
        return int(reg)
    except ValueError:
        if reg == 'zero': return 0
        if reg == 'at':   return 1
        if reg == 'gp':   return 28
        if reg == 'sp':   return 29
        if reg == 'fp':   return 30
        if reg == 'ra':   return 31
        num = lambda reg: int(reg[1:])
        if reg[0] == 'v': return num(reg) + 2
        if reg[0] == 'a': return num(reg) + 4
        if reg[0] == 't': return num(reg) + (8 if num(reg) < 8 else 16)
        if reg[0] == 's': return num(reg) + 16
        if reg[0] == 'k': return num(reg) + 24


def parse_operand(op: str) -> int:
    try:
        return int(op)
    except ValueError:
        return parse_register(op[1:])


def decode_line(line: str) -> Token:
    # remove comment
    line = line.split('#')[0]
    # split by tabs (ignore trailing)
    instruction, operands = line.split('\t')[:2]
    # strip whitespace
    instruction = instruction.strip()
    operands = [op.strip() for op in operands.split(',')]
    # tokenize
    return Token(
        get_coding(instruction),
        instruction,
        [parse_operand(op) for op in operands]
    )
