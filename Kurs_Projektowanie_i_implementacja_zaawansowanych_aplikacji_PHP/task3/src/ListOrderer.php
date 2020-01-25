<?php


namespace App;


interface ListOrderer
{
    public function order(array $applications): array;
}
