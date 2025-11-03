<?php

namespace App\Tests\Controller;

use Symfony\Bundle\FrameworkBundle\Test\WebTestCase;
use Symfony\Component\HttpFoundation\Response;

class ApiControllerTest extends WebTestCase
{
    public function testHealthEndpoint(): void
    {
        $client = static::createClient();
        $client->request('GET', '/api/health');

        $this->assertResponseIsSuccessful();
        $this->assertResponseStatusCodeSame(Response::HTTP_OK);
        $this->assertJson($client->getResponse()->getContent());
        
        $data = json_decode($client->getResponse()->getContent(), true);
        $this->assertArrayHasKey('status', $data);
        $this->assertEquals('healthy', $data['status']);
    }

    public function testHealthEndpointMethod(): void
    {
        $client = static::createClient();
        $client->request('GET', '/api/health');
        
        $this->assertResponseHeaderSame('Content-Type', 'application/json');
    }

    public function testListItemsEndpoint(): void
    {
        $client = static::createClient();
        $client->request('GET', '/api/items');

        $this->assertResponseIsSuccessful();
        $this->assertResponseStatusCodeSame(Response::HTTP_OK);
        $this->assertJson($client->getResponse()->getContent());
        
        $data = json_decode($client->getResponse()->getContent(), true);
        $this->assertArrayHasKey('items', $data);
        $this->assertIsArray($data['items']);
    }

    public function testListItemsEndpointMethod(): void
    {
        $client = static::createClient();
        $client->request('GET', '/api/items');
        
        $this->assertResponseHeaderSame('Content-Type', 'application/json');
    }

    public function testInvalidEndpoint(): void
    {
        $client = static::createClient();
        $client->request('GET', '/api/invalid');
        
        $this->assertResponseStatusCodeSame(Response::HTTP_NOT_FOUND);
    }

    public function testApiPrefix(): void
    {
        $client = static::createClient();
        $client->request('GET', '/api/health');
        
        $this->assertResponseIsSuccessful();
    }
}
