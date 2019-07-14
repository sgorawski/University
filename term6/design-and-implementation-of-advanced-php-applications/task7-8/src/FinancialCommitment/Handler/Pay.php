<?php

namespace FinancialCommitment\Handler;

class Pay extends RepositoryHandler
{
    public function __invoke(\FinancialCommitment\Command\Pay $command)
    {
        $id = $command->getFinancialCommitmentId();
        $commitment = $this->repository->load($id);

        $commitment->registerPayment($command->getAmount());

        $this->repository->save($commitment);
    }
}
