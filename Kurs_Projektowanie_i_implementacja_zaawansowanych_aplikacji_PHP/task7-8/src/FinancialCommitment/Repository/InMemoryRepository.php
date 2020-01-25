<?php

namespace FinancialCommitment\Repository;

use FinancialCommitment\FinancialCommitment;
use FinancialCommitment\FinancialCommitmentRepository;
use Ramsey\Uuid\UuidInterface;

class InMemoryRepository implements FinancialCommitmentRepository
{
    /**
     * @var FinancialCommitment[]
     */
    private $commitments = [];

    public function load(UuidInterface $id): FinancialCommitment
    {
        return $this->commitments[$id->toString()];
    }

    public function save(FinancialCommitment $commitment): void
    {
        $this->commitments[$commitment->getId()->toString()] = $commitment;
    }
}
