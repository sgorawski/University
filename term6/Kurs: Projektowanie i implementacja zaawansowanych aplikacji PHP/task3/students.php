<?php

use App\Faculty;
use App\Model\Application;
use App\Model\Student;

require 'vendor/autoload.php';

$faculties = [
    'Faculty A' => new Faculty(
        new App\ApplicationsDivider\BySubmissionDateAsc(
            ['accepted' => 100, 'reserve' => 10, 'rejected' => null]
        ), [
            'accepted' => new App\ListOrderer\BySubmissionDateAsc(),
            'reserve' => new App\ListOrderer\BySubmissionDateAsc(),
            'rejected' => new App\ListOrderer\BySubmissionDateAsc(),
        ]
    ), 'Faculty B' => new Faculty(
        new App\ApplicationsDivider\ByPointsDesc(
            ['accepted' => 75, 'rejected' => null]
        ), [
            'accepted' => new App\ListOrderer\ByPointsDesc(),
            'rejected' => new App\ListOrderer\ByStudentLastNameAtoZ(),
        ]
    ), 'Faculty C' => new Faculty(
        new App\ApplicationsDivider\Random(
            ['accepted' => 50, 'reserve' => 5, 'rejected' => null]
        ), [
            'accepted' => new App\ListOrderer\ByStudentLastNameAtoZ(),
            'reserve' => new App\ListOrderer\ByStudentLastNameAtoZ(),
            'rejected' => new App\ListOrderer\ByStudentLastNameAtoZ(),
        ]
    ),
];

$applications = loadTestData('applications.csv');

foreach ($faculties as $facultyName => $faculty) {
    echo PHP_EOL . PHP_EOL . '# ' . $facultyName . PHP_EOL;
    $candidateLists = $faculty->prepareCandidatesLists($applications);

    foreach ($candidateLists as $listName => $candidates) {
        echo PHP_EOL . '## ' . $listName . PHP_EOL;

        foreach ($candidates as $candidate) {
            echo $candidate . PHP_EOL;
        }
    }
}

function loadTestData(string $filename): array
{
    $f = fopen($filename, 'r');

    $applications = [];
    while (($record = fgetcsv($f)) !== false) {
        list($firstName, $lastName, $submissionDate, $points) = $record;
        $student = new Student($firstName, $lastName);
        $applications[] = new Application($student, $submissionDate, $points);
    }

    fclose($f);
    return $applications;
}
