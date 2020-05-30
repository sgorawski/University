from decimal import Decimal as D


def d6(value):
    return D(value).quantize(D('0.000_001'))
