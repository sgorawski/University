<?php


namespace App\Model;


use DateTimeImmutable;

class Application
{
    /**
     * @var Student
     */
    private $student;

    /**
     * @var DateTimeImmutable
     */
    private $submissionDate;

    public function __construct(Student $student, string $submissionDate, int $points)
    {
        $this->student = $student;
        $this->submissionDate = new DateTimeImmutable($submissionDate);
        $this->points = $points;
    }

    /**
     * @var int
     */
    private $points;

    public function getStudent(): Student
    {
        return $this->student;
    }

    public function getSubmissionDate(): DateTimeImmutable
    {
        return $this->submissionDate;
    }

    public function getPoints(): int
    {
        return $this->points;
    }

    public function __toString(): string
    {
        $dateStr = $this->submissionDate->format('Y-m-d H:i:s');
        return $this->student . ' ' . $dateStr . ' ' . $this->points;
    }
}
