<?php

require 'vendor/autoload.php';

$loader = new Twig\Loader\FilesystemLoader('templates/');
$twig = new Twig\Environment($loader);

$data = file_get_contents('accounts.json');
$accounts = json_decode($data, true);

echo $twig->render('index.html', ['accounts' => $accounts]);
