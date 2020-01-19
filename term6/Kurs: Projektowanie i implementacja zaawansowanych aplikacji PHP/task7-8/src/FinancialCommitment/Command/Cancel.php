<?php

namespace FinancialCommitment\Command;

use CommandBus\Command;
use Ramsey\Uuid\Uuid;

class Cancel extends Command
{
    private $financialCommitmentId;

    public function __construct(Uuid $financialCommitmentId)
    {
        parent::__construct();
        $this->financialCommitmentId = $financialCommitmentId;
    }

    public function getFinancialCommitmentId(): Uuid
    {
        return $this->financialCommitmentId;
    }
}