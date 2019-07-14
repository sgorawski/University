<?php

namespace TransactionFinder;

use Doctrine\ORM\EntityManager;
use Transaction;
use TransactionFinder;

class Doctrine implements TransactionFinder
{
    private $entityManager;

    public function __construct(EntityManager $entityManager)
    {
        $this->entityManager = $entityManager;
    }

    /**
     * @return Transaction[]
     */
    public function findAll(int $limit = 10, int $offset = 0)
    {
        $repository = $this->entityManager->getRepository(Transaction::class);
        return $repository->findBy([], [], $limit, $offset);
    }
}
