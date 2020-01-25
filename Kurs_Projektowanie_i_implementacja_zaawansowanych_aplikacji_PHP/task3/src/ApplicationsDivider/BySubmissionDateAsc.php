<?php


namespace App\ApplicationsDivider;


use App\ApplicationsDivider;
use App\Model\Application;

class BySubmissionDateAsc extends SortingDivider implements ApplicationsDivider
{

    public function divide(array $applications): array
    {
        usort($applications, function (Application $lhs, Application $rhs): int {
            return $lhs->getSubmissionDate() <=> $rhs->getSubmissionDate();
        });
        return $this->splitSortedApplications($applications);
    }
}
