<?php

namespace PingPong\Handler;

use PingPong\Command\PingCommand;

class PingHandler
{
    public function __invoke(PingCommand $command)
    {
        echo 'PONG!' . PHP_EOL;
    }
}
