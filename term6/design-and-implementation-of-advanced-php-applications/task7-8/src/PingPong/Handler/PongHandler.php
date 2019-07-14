<?php

namespace PingPong\Handler;

use PingPong\Command\PongCommand;

class PongHandler
{
    public function __invoke(PongCommand $command)
    {
        echo 'PING!' . PHP_EOL;
    }
}
