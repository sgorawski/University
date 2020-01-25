<?php

use MyCLabs\Enum\Enum;

class Status extends Enum
{
    private const ACTIVE = 'ACTIVE';
    private const BLOCKED = 'BLOCKED';
    private const SUSPENDED = 'SUSPENDED';
    private const CLOSED = 'CLOSED';
}
