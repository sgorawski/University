<?php

namespace FinancialCommitment\Event;

use FinancialCommitment\Event;
use Money\Money;

class FinancialCommitmentOverpaid extends Event
{
    private $excess;

    public function __construct(Money $excess)
    {
        parent::__construct();
        $this->excess = $excess;
    }

    public function getExcess(): Money
    {
        return $this->excess;
    }
}
