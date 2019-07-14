<?php


namespace App;


class Model
{
    private $maxId;
    private $accountsById;

    public function __construct()
    {
        $this->maxId = 0;
        $this->accountsById = [];
    }

    public function getAll(): array
    {
        return $this->accountsById;
    }

    public function get(int $id): Account
    {
        return $this->accountsById[$id];
    }

    public function add(array $fields): Account
    {
        $id = $this->maxId + 1;

        $new = new Account;
        $new->id = $id;
        $new->email = $fields['email'];
        $new->description = $fields['description'];
        $new->points = $fields['points'];
        $new->status = $fields['status'];

        $this->maxId++;
        $this->accountsById[$id] = $new;
        return $new;
    }

    public function update(int $id, array $fields): Account
    {
        $account =& $this->accountsById[$id];
        foreach ($fields as $name => $value) {
            $account->$name = $value;
        }
        return $account;
    }

    public function addPoints(int $id, int $points): Account
    {
        $account =& $this->accountsById[$id];
        $account->points += $points;
        return $account;
    }
}