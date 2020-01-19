<?php

namespace CommandBus;

abstract class Command
{
    /**
     * @var \DateTime
     */
    private $created;

    public function __construct()
    {
        $this->created = new \DateTimeImmutable();
    }
}
