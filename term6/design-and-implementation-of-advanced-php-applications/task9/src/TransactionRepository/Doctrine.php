<?php

namespace TransactionRepository;

use Doctrine\ORM\EntityManager;
use Ramsey\Uuid\Uuid;
use Transaction;
use TransactionRepository;

class Doctrine implements TransactionRepository
{
    private $entityManager;

    public function __construct(EntityManager $entityManager)
    {
        $this->entityManager = $entityManager;
    }

    public function get(Uuid $transactionId): Transaction
    {
        return $this->entityManager->find(Transaction::class, $transactionId);
    }

    public function save(Transaction $transaction): void
    {
        $this->entityManager->persist($transaction);
        $this->entityManager->flush();
    }
}
