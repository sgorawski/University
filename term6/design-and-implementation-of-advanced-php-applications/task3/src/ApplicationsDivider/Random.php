<?php


namespace App\ApplicationsDivider;


use App\ApplicationsDivider;

class Random extends SortingDivider implements ApplicationsDivider
{

    public function divide(array $applications): array
    {
        shuffle($applications);
        return $this->splitSortedApplications($applications);
    }
}
