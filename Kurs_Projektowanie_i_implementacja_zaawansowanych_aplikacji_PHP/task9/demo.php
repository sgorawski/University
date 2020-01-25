<?php

require_once 'bootstrap.php';

use Money\Money;
use Money\Currency;

$repository = new TransactionRepository\Doctrine($entityManager);
$finder = new TransactionFinder\Doctrine($entityManager);

$transaction = new Transaction(
    new Money(100, new Currency('EUR')),
    'my-account',
    'someone-elses-account'
);
$txId = $transaction->getId();

$repository->save($transaction);

$transaction = $repository->get($txId);
$transaction->suspend();
$repository->save($transaction);

$transactions = $finder->findAll();
var_dump($transactions);
