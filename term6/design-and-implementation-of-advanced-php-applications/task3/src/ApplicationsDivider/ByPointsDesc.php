<?php


namespace App\ApplicationsDivider;


use App\ApplicationsDivider;
use App\Model\Application;

class ByPointsDesc extends SortingDivider implements ApplicationsDivider
{

    public function divide(array $applications): array
    {
        usort($applications, function (Application $lhs, Application $rhs): int {
            return $rhs->getPoints() <=> $lhs->getPoints();
        });
        return $this->splitSortedApplications($applications);
    }
}
