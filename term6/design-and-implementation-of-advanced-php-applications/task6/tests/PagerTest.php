<?php

use PHPUnit\Framework\TestCase;

class PagerTest extends TestCase
{
    public function testCannotBeInstantiatedWithTooHighCurrentPage()
    {
        $this->expectException(InvalidArgumentException::class);

        new Pager(91, 10, 11);
    }

    public function testGetTotalPagesCount()
    {
        $pager = new Pager(91, 10, 1);

        $actual = $pager->getTotalPagesCount();

        $this->assertSame(10, $actual);
    }

    public function testGetTotalPagesCountNoObjects()
    {
        $pager = new Pager(0, 10, 1);

        $actual = $pager->getTotalPagesCount();

        $this->assertSame(0, $actual);
    }

    public function testIsPreviousPageLinkVisible()
    {
        $pager = new Pager(91, 10, 5);

        $actual = $pager->isPreviousPageLinkVisible();

        $this->assertTrue($actual);
    }

    public function testIsPreviousPageLinkVisibleOnFirstPage()
    {
        $pager = new Pager(91, 10, 1);

        $actual = $pager->isPreviousPageLinkVisible();

        $this->assertFalse($actual);
    }

    public function testIsNextPageLinkVisible()
    {
        $pager = new Pager(91, 10, 5);

        $actual = $pager->isNextPageLinkVisible();

        $this->assertTrue($actual);
    }

    public function testIsNextPageLinkVisibleOnLastPage()
    {
        $pager = new Pager(91, 10, 10);

        $actual = $pager->isNextPageLinkVisible();

        $this->assertFalse($actual);
    }

    /**
     * @dataProvider provideDataForGetLinksToDisplayTest
     */
    public function testGetLinksToDisplay(array $pagerParams, array $expectedLinks)
    {
        $pager = new Pager(...$pagerParams);

        $actual = $pager->getLinksToDisplay();

        $this->assertSame($expectedLinks, $actual);
    }

    public function provideDataForGetLinksToDisplayTest(): array
    {
        return [
            [[91, 10, 5], [1, 4, 5, 6, 10]],
            [[91, 10, 1], [1, 2, 10]],
            [[91, 10, 2], [1, 2, 3, 10]],
            [[91, 10, 10], [1, 9, 10]],
            [[91, 10, 9], [1, 8, 9, 10]],
            // [[50, 10, 3], [1, 2, 3, 4, 5]], // comment out for Infection demo
            [[30, 10, 2], [1, 2, 3]],
            [[20, 10, 2], [1, 2]],
            [[10, 10, 1], [1]],
            [[0, 10, 1], [1]],
        ];
    }
}