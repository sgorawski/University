<?php

namespace CommandBus;

interface Router
{
    public function handle(Command $command);
}
