<?php

use Slim\Http\Request;
use Slim\Http\Response;

require 'vendor/autoload.php';

$app = new Slim\App;

$model = new App\Model;

$app->get('/accounts', function (Request $request, Response $response, array $args) use ($model) {
    return $response->withJson($model->getAll());
});

$app->get('/accounts/{id}', function (Request $request, Response $response, array $args) use ($model) {
    $id = $args['id'];
    return $response->withJson($model->get($id));
});

$app->post('/accounts', function(Request $request, Response $response, array $args) use ($model) {
    $fields = $request->getParsedBody();
    $account = $model->add($fields);
    return $response->withJson($account);
});

$app->post('/accounts/{id}/updateStatus', function(Request $request, Response $response, array $args) use ($model) {
    $id = $args['id'];
    $status = $request->getParsedBody()['status'];
    return $response->withJson($model->update($id, ['status' => $status]));
});

$app->post('/accounts/{id}/addPoints', function(Request $request, Response $response, array $args) use ($model) {
    $id = $args['id'];
    $points = $request->getParsedBody()['points'];
    return $response->withJson($model->addPoints($id, $points));
});

$app->run();
