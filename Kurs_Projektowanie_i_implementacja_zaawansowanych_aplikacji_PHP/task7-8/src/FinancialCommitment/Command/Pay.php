<?php

namespace FinancialCommitment\Command;

use CommandBus\Command;
use Money\Money;
use Ramsey\Uuid\Uuid;

class Pay extends Command
{
    private $financialCommitmentId;
    private $amount;

    public function __construct(Uuid $financialCommitmentId, Money $amount)
    {
        parent::__construct();
        $this->financialCommitmentId = $financialCommitmentId;
        $this->amount = $amount;
    }

    public function getFinancialCommitmentId(): Uuid
    {
        return $this->financialCommitmentId;
    }

    public function getAmount(): Money
    {
        return $this->amount;
    }
}
