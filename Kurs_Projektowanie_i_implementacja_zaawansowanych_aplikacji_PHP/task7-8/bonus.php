<?php

require 'vendor/autoload.php';

use CommandBus\CommandBus;
use CommandBus\Router\DirectRouter;
use Money\Currency;
use Money\Money;

$repository = new FinancialCommitment\Repository\InMemoryRepository();

$commandBus = new CommandBus(new DirectRouter([
    FinancialCommitment\Command\Create::class => new FinancialCommitment\Handler\Create($repository),
    FinancialCommitment\Command\Pay::class => new FinancialCommitment\Handler\Pay($repository),
    FinancialCommitment\Command\Cancel::class => new FinancialCommitment\Handler\Cancel($repository),
]));

$EUR = new Currency('EUR');

$financialCommitment = new FinancialCommitment\FinancialCommitment(
    new Money(100, $EUR)
);
$id = $financialCommitment->getId();

$commandBus->dispatch(new FinancialCommitment\Command\Create($financialCommitment));
echo commitmentToString($repository->load($id));

$commandBus->dispatch(new FinancialCommitment\Command\Pay($id, new Money(50, $EUR)));
echo commitmentToString($repository->load($id));

$commandBus->dispatch(new FinancialCommitment\Command\Cancel($id));
echo commitmentToString($repository->load($id));


function commitmentToString(FinancialCommitment\FinancialCommitment $commitment)
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

