<?php

namespace FinancialCommitment;

use Ramsey\Uuid\Uuid;
use Ramsey\Uuid\UuidInterface;

abstract class Event
{
    /**
     * @var UuidInterface
     */
    private $id;

    /**
     * @var \DateTimeImmutable
     */
    private $created;

    public function __construct()
    {
        $this->id = Uuid::uuid4();
        $this->created = new \DateTimeImmutable();
    }
}
