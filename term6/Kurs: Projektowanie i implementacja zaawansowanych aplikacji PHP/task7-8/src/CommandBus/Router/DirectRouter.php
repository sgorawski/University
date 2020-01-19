<?php

namespace CommandBus\Router;

use CommandBus\NoRouteFoundException;
use CommandBus\Router;
use CommandBus\Command;

class DirectRouter implements Router
{
    private $routeTable;

    public function __construct(array $routeTable)
    {
        $this->routeTable = $routeTable;
    }

    public function handle(Command $command)
    {
        $handler = $this->routeTable[get_class($command)];
        if ($handler === null) {
            throw new NoRouteFoundException();
        }

        return $handler($command);
    }
}
