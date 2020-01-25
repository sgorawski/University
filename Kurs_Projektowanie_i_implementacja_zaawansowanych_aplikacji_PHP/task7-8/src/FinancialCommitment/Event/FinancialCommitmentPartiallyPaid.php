<?php

namespace FinancialCommitment\Event;

use FinancialCommitment\Event;
use Money\Money;

class FinancialCommitmentPartiallyPaid extends Event
{
    private $amount;

    public function __construct(Money $amount)
    {
        parent::__construct();
        $this->amount = $amount;
    }

    public function getAmount(): Money
    {
        return $this->amount;
    }
}
