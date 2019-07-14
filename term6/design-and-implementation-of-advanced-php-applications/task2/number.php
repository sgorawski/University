<?php
namespace Numbers;

class Number
{
    private $digits;
    private $base;

    public function __construct(array $digits, int $base)
    {
        $this->digits = $digits;
        $this->base = $base;
    }

    public function getDigits(): array
    {
        return $this->digits;
    }

    public function getBase(): int
    {
        return $this->base;
    }

    public static function fromSymbol(string $symbol): self
    {
        list($digitsRaw, $baseRaw) = explode(':', $symbol);
        $digits = array_reverse(array_map(intval, str_split($digitsRaw)));
        return new self($digits, intval($baseRaw));
    }

    public function toBase(int $newBase): self
    {
        return self::fromValue($this->calculateValue(), $newBase);
    }

    public function add(self $other): self
    {
        return self::fromValue(
            $this->calculateValue() + $other->calculateValue(), 
            $other->getBase()
        );
    }

    public function calculateValue(): int
    {
        $value = 0;
        for ($i = count($this->digits) - 1; $i >= 0; $i--) {
            $value *= $this->base;
            $value += $this->digits[$i];
        }
        return $value;
    }

    private static function fromValue(int $value, int $base): self
    {
        $digits = [];
        while ($value > 0) {
            $digits[] = $value % $base;
            $value = intdiv($value, $base);
        }
        return new self($digits, $base);
    }
}

interface NumberFormatter
{
    public function toString(): string;
}
