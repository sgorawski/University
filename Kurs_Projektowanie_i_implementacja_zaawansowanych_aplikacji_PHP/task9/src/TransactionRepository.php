<?php

use Ramsey\Uuid\Uuid;

interface TransactionRepository
{
    public function get(Uuid $transactionId): Transaction;

    public function save(Transaction $transaction): void;
}
