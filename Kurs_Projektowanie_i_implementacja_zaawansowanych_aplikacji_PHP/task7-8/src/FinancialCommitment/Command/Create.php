<?php

namespace FinancialCommitment\Command;

use CommandBus\Command;
use FinancialCommitment\FinancialCommitment;

class Create extends Command
{
    private $financialCommitment;

    public function __construct(FinancialCommitment $financialCommitment)
    {
        parent::__construct();
        $this->financialCommitment = $financialCommitment;
    }

    public function getFinancialCommitment(): FinancialCommitment
    {
        return $this->financialCommitment;
    }
}
