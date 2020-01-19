<?php

class Pager
{
    private $totalObjectsCount;
    private $objectsOnPageCount;
    private $currentPage;

    public function __construct(int $totalObjectsCount, int $objectsOnPageCount, int $currentPage)
    {
        if ($totalObjectsCount < $objectsOnPageCount * ($currentPage - 1))
            throw new InvalidArgumentException("Page too high");

        $this->totalObjectsCount = $totalObjectsCount;
        $this->objectsOnPageCount = $objectsOnPageCount;
        $this->currentPage = $currentPage;
    }

    public function getTotalPagesCount(): int
    {
        return ceil($this->totalObjectsCount / $this->objectsOnPageCount);
    }

    public function isPreviousPageLinkVisible(): bool
    {
        return $this->currentPage > 1;
    }

    public function isNextPageLinkVisible(): bool
    {
        return $this->currentPage < $this->getTotalPagesCount();
    }

    public function getLinksToDisplay(): array
    {
        $links = [];

        if ($this->currentPage > 2)
            $links[] = 1;

        if ($this->isPreviousPageLinkVisible())
            $links[] = $this->currentPage - 1;

        $links[] = $this->currentPage;

        if ($this->isNextPageLinkVisible())
            $links[] = $this->currentPage + 1;

        if ($this->currentPage < $this->getTotalPagesCount() - 1)
            $links[] = $this->getTotalPagesCount();

        return $links;
    }
}
