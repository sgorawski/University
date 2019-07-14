<?php


namespace App\ApplicationsDivider;


use App\ApplicationsDivider;

abstract class SortingDivider implements ApplicationsDivider
{
    private $listlengths;

    public function __construct(array $listLengths)
    {
        $this->listlengths = $listLengths;
    }

    abstract public function divide(array $applications): array;

    protected function splitSortedApplications(array $applications): array
    {
        $result = [];
        $offset = 0;
        foreach ($this->listlengths as $name => $length) {
            $result[$name] = array_slice($applications, $offset, $length);
            $offset += $length;
        }
        return $result;
    }
}