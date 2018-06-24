"""Autor: Slawomir Gorawski"""

from fileinput import FileInput, input
from typing import Generator, Union, Dict

from coding import Coding
from lexer import decode_line
import meta


META: Dict[Coding, Union[meta.R, meta.I]] = {
    Coding.R_RD_RS_RT:  meta.RRdRsRt,
    Coding.R_RD_RT_RS:  meta.RRdRtRs,
    Coding.R_RD_RT_SA:  meta.RRdRtSa,
    Coding.R_RS_RT:     meta.RRsRt,
    Coding.R_RD:        meta.RRd,
    Coding.R_RS:        meta.RRs,
    Coding.I_RT_RS_IMM: meta.IRtRsImm,
    Coding.I_RT_IMM:    meta.IRtImm,
}


def mips_to_bin(mips: FileInput) -> Generator[str, None, None]:
    address: int = 0
    yield ".text"
    for line in mips:
        line = line.strip()
        token = decode_line(line)
        meta = META[token.coding]
        instr = meta(token.instruction, *token.operands)
        yield '\t'.join(["%0.8X" % address, instr.encode(), line])
        address += 4


if __name__ == '__main__':
    for line in mips_to_bin(input()):
        print(line)
