<?php
namespace Numbers;

require_once 'number.php';

class RomanFormatter implements NumberFormatter
{
    const HUNS = ['', 'C', 'CC', 'CCC', 'CD', 'D', 'DC', 'DCC', 'DCCC', 'CM'];
    const TENS = ['', 'X', 'XX', 'XXX', 'XL', 'L', 'LX', 'LXX', 'LXXX', 'XC'];
    const ONES = ['', 'I', 'II', 'III', 'IV', 'V', 'VI', 'VII', 'VIII', 'IX'];

    private $number;

    public function __construct(Number $number)
    {
        $this->number = $number;
    }

    public function toString(): string
    {
        $value = $this->number->calculateValue();
        return implode([
            str_repeat('M', intdiv($value, 1000)),
            self::HUNS[intdiv($value, 100) % 10],
            self::TENS[intdiv($value, 10) % 10],
            self::ONES[$value % 10],
        ]);
    }
}
