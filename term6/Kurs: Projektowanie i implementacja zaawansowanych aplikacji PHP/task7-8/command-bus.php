<?php

require 'vendor/autoload.php';

use CommandBus\CommandBus;
use CommandBus\Router\DirectRouter;
use PingPong\Command\PingCommand;
use PingPong\Command\PongCommand;
use PingPong\Handler\PingHandler;
use PingPong\Handler\PongHandler;

$commandBus = new CommandBus(new DirectRouter([
    PingCommand::class => new PingHandler(),
    PongCommand::class => new PongHandler(),
]));

$commandBus->dispatch(new PingCommand());
$commandBus->dispatch(new PongCommand());
