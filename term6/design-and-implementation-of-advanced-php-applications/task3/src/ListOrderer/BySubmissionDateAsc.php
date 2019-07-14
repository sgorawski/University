<?php


namespace App\ListOrderer;


use App\ListOrderer;
use App\Model\Application;

class BySubmissionDateAsc implements ListOrderer
{
    public function order(array $applications): array
    {
        usort($applications, function (Application $lhs, Application $rhs): int {
            return $lhs->getSubmissionDate() <=> $rhs->getSubmissionDate();
        });
        return $applications;
    }
}
