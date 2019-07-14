<?php

use Ramsey\Uuid\Uuid;
use Money\Money;

class Transaction
{
    /**
     * @var Uuid
     *
     * Klasa Uuid pochodzi z biblioteki ramsey/uuid
     */
    private $id;

    /**
     * @var Money
     *
     * Klasa Money pochodzi z biblioteki moneyphp/money
     */
    private $amount;

    /**
     * @var string
     */
    private $fromAccount;

    /**
     * @var string
     */
    private $toAccount;

    /**
     * @var Status
     *
     * Klasa Status rozszerza klasę Enum z biblioteki myclabs/php-enum i reprezentuje jeden ze statusów konta:
     * - ACTIVE
     * - BLOCKED
     * - SUSPENDED
     * - CLOSED
     */
    private $status;

    public function __construct(
        Money $amount, string $fromAccount, string $toAccount, Status $status = null
    )
    {
        $this->id = Uuid::uuid4();
        $this->amount = $amount;
        $this->fromAccount = $fromAccount;
        $this->toAccount = $toAccount;
        $this->status = $status ?? Status::ACTIVE();
    }

    public function getId(): Uuid
    {
        return $this->id;
    }

    public function block()
    {
        $this->status = Status::BLOCKED();
    }

    public function suspend()
    {
        $this->status = Status::SUSPENDED();
    }

    public function close()
    {
        $this->status = Status::CLOSED();
    }
}
