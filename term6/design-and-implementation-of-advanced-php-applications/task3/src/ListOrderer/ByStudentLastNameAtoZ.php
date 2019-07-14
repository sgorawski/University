<?php


namespace App\ListOrderer;


use App\ListOrderer;
use App\Model\Application;

class ByStudentLastNameAtoZ implements ListOrderer
{

    public function order(array $applications): array
    {
        usort($applications, function (Application $lhs, Application $rhs): int {
            return strcasecmp($lhs->getStudent()->getLastName(), $rhs->getStudent()->getLastName());
        });
        return $applications;
    }
}
