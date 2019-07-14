<?php

namespace FinancialCommitment\Handler;

class Cancel extends RepositoryHandler
{
    public function __invoke(\FinancialCommitment\Command\Cancel $command)
    {
        $id = $command->getFinancialCommitmentId();
        $commitment = $this->repository->load($id);

        $commitment->cancel();

        $this->repository->save($commitment);
    }
}
