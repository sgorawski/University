<?php

interface TransactionFinder
{
    /**
     * @return Transaction[]
     */
    public function findAll(int $limit = 10, int $offset = 0);
}
