<?php


namespace App\ListOrderer;


use App\ListOrderer;
use App\Model\Application;

class ByPointsDesc implements ListOrderer
{
    public function order(array $applications): array
    {
        usort($applications, function (Application $lhs, Application $rhs): int {
            return $rhs->getPoints() <=> $lhs->getPoints();
        });
        return $applications;
    }
}