<?php

namespace FinancialCommitment;

use Ramsey\Uuid\UuidInterface;

interface FinancialCommitmentRepository
{
    public function load(UuidInterface $id): FinancialCommitment;

    public function save(FinancialCommitment $commitment): void;
}
