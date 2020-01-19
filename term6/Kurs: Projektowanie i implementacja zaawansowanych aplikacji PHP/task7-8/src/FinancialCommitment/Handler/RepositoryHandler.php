<?php

namespace FinancialCommitment\Handler;

use FinancialCommitment\FinancialCommitmentRepository;

abstract class RepositoryHandler
{
    protected $repository;

    public function __construct(FinancialCommitmentRepository $repository)
    {
        $this->repository = $repository;
    }
}