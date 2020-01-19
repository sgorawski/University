<?php

namespace CommandBus;

class CommandBus
{
    private $router;

    public function __construct(Router $router)
    {
        $this->router = $router;
    }

    /**
     * @throws NoRouteFoundException
     */
    public function dispatch(Command $command)
    {
        return $this->router->handle($command);
    }
}
