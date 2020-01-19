<?php

namespace FinancialCommitment;

use Money\Money;
use Ramsey\Uuid\Uuid;
use Ramsey\Uuid\UuidInterface;

class FinancialCommitment
{
    /**
     * @var UuidInterface
     */
    private $id;

    /**
     * @var Event[]
     */
    private $events = [];

    /**
     * @var Money
     */
    private $balance;

    // ... inne pola

    public function __construct(Money $amount)
    {
        $this->id = Uuid::uuid4();
        $this->balance = $amount;
        $this->events[] = new Event\FinancialCommitmentCreated($amount);
    }

    public function registerPayment(Money $payment): void
    {
        $this->balance = $this->balance->subtract($payment);

        $this->events[] = new Event\FinancialCommitmentPartiallyPaid($payment); // W zależności od stanu obiektu, należy zarejestrować także inne zdarzenia związane z zarejestrowaniem wpłaty

        if ($this->balance->isZero()) {
            $this->events[] = new Event\FinancialCommitmentRepaid();
        } else if ($this->balance->isNegative()) {
            $this->events[] = new Event\FinancialCommitmentOverpaid($this->balance->negative());
        }
    }

    public function cancel(): void
    {
        $this->balance = $this->balance->subtract($this->balance);

        $this->events[] = new Event\FinancialCommitmentCancelled();
    }

    public function getBalance(): Money
    {
        return $this->balance;
    }

    public function getEvents(): array
    {
        return $this->events;
    }

    public function getId(): UuidInterface
    {
        return $this->id;
    }
}
