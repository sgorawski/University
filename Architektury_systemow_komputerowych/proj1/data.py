"""Autor: Slawomir Gorawski"""

from typing import Set, Dict
from enum import Enum, auto

from coding import Coding


R_RD_RS_RT_INSTRUCTIONS: Set[str] = {
    'add', 'addu', 'sub', 'subu', 'and', 'xor', 'or', 'nor', 'slt', 'sltu',
}

R_RD_RT_RS_INSTRUCTIONS: Set[str] = {
    'sllv', 'srlv', 'srav',
}

R_RD_RT_SA_INSTRUCTIONS: Set[str] = {
    'sll', 'srl', 'sra',
}

R_RS_RT_INSTRUCTIONS: Set[str] = {
    'mult', 'multu', 'div', 'divu',
}

R_RD_INSTRUCTIONS: Set[str] = {
    'mfhi', 'mflo',
}

R_RS_INSTRUCTIONS: Set[str] = {
    'mthi', 'mtlo',
}

I_RT_RS_IMM_INSTRUCTIONS: Set[str] = {
    'addi', 'addiu', 'slti', 'sltiu', 'andi', 'ori', 'xori',
}

I_RT_IMM_INSTRUCTIONS: Set[str] = {
    'lui',
}

INSTRUCTION_CODINGS: Dict[Coding, Set[str]] = {
    Coding.R_RD_RS_RT:  R_RD_RS_RT_INSTRUCTIONS,
    Coding.R_RD_RT_RS:  R_RD_RT_RS_INSTRUCTIONS,
    Coding.R_RD_RT_SA:  R_RD_RT_SA_INSTRUCTIONS,
    Coding.R_RS_RT:     R_RS_RT_INSTRUCTIONS,
    Coding.R_RD:        R_RD_INSTRUCTIONS,
    Coding.R_RS:        R_RS_INSTRUCTIONS,
    Coding.I_RT_RS_IMM: I_RT_RS_IMM_INSTRUCTIONS,
    Coding.I_RT_IMM:    I_RT_IMM_INSTRUCTIONS,
}

OPCODE: Dict[str, int] = {
    'lui':   0xF,
    'addi':  0x8,
    'addiu': 0x9,
    'slti':  0xA,
    'sltiu': 0xB,
    'andi':  0xC,
    'ori':   0xD,
    'xori':  0xE,
}

FUNCT: Dict[str, int] = {
    'sll':   0x0,
    'srl':   0x2,
    'sra':   0x3,
    'sllv':  0x4,
    'srlv':  0x6,
    'srav':  0x7,
    'mfhi':  0x10,
    'mthi':  0x11,
    'mflo':  0x12,
    'mtlo':  0x13,
    'mult':  0x18,
    'multu': 0x19,
    'div':   0x1A,
    'divu':  0x1B,
    'add':   0x20,
    'addu':  0x21,
    'sub':   0x22,
    'subu':  0x23,
    'and':   0x24,
    'or':    0x25,
    'xor':   0x26,
    'nor':   0x27,
    'slt':   0x2A,
    'sltu':  0x2B,
}
