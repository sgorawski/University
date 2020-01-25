<?php
namespace Numbers;

require_once 'number.php';
require_once 'formatter.php';

$total = new Number([], 10);

for ($i = 1; $i < $argc; $i++) {
    $next = Number::fromSymbol($argv[$i]);
    $total = $total->add($next);
}

$fmtr = new RomanFormatter($total);
echo $fmtr->toString();
