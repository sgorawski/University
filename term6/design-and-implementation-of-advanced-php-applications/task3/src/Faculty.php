<?php


namespace App;


class Faculty
{
    private $applicationsDivider;
    private $listOrderers;

    public function __construct(ApplicationsDivider $applicationsDivider, array $listOrderers)
    {
        $this->applicationsDivider = $applicationsDivider;
        $this->listOrderers = $listOrderers;
    }

    public function prepareCandidatesLists(array $applications): array
    {
        $dividedApplications = $this->applicationsDivider->divide($applications);

        $candidatesLists = [];
        foreach ($dividedApplications as $listName => $applications) {
            $orderer = $this->listOrderers[$listName];
            $candidatesLists[$listName] = $orderer->order($applications);
        }

        return $candidatesLists;
    }
}