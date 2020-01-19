<?php

namespace FinancialCommitment\Handler;

class Create extends RepositoryHandler
{
    public function __invoke(\FinancialCommitment\Command\Create $command)
    {
        $commitment = $command->getFinancialCommitment();
        $this->repository->save($commitment);
    }
}
