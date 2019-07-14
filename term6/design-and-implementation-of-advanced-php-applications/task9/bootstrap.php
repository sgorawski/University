<?php

require_once 'vendor/autoload.php';

use Doctrine\DBAL\Types\Type;
use Doctrine\ORM\EntityManager;
use Doctrine\ORM\Tools\Setup;
use Ramsey\Uuid\Doctrine\UuidType;

Type::addType('uuid', UuidType::class);

$config = Setup::createXMLMetadataConfiguration(['config/doctrine'], true);
$conn = ['url' => 'postgresql://postgres:postgres@localhost:5432/php'];
$entityManager = EntityManager::create($conn, $config);
