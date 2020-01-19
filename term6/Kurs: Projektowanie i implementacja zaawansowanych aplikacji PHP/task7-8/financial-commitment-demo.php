<?php

require 'vendor/autoload.php';

use FinancialCommitment\FinancialCommitment;
use Money\Currency;
use Money\Money;

$EUR = new Currency('EUR');

$commitment = new FinancialCommitment(new Money(100, $EUR));
echo commitmentToString($commitment);

$commitment->registerPayment(new Money(50, $EUR));
echo commitmentToString($commitment);

$commitment->registerPayment(new Money(50, $EUR));
echo commitmentToString($commitment);

$commitment->registerPayment(new Money(1, $EUR));
echo commitmentToString($commitment);

function commitmentToString(FinancialCommitment $commitment)
{
    return
        moneyToString($commitment->getBalance())
        . eventsToString($commitment->getEvents())
        . PHP_EOL
        . '==='
        . PHP_EOL;
}

function moneyToString(Money $amount)
{
    return $amount->getAmount() . ' ' . $amount->getCurrency()->getCode();
}

function eventsToString(array $events)
{
    return array_reduce(
        array_map(function ($e) { return get_class($e); }, $events),
        function ($l, $r) { return $l . PHP_EOL . $r; }, ''
    );
}
