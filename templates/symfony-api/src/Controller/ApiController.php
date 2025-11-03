<?php

declare(strict_types=1);

namespace App\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\Routing\Attribute\Route;

#[Route('/api')]
class ApiController extends AbstractController
{
    #[Route('/health', methods: ['GET'])]
    public function health(): JsonResponse
    {
        return new JsonResponse(['status' => 'healthy']);
    }

    #[Route('/items', methods: ['GET'])]
    public function listItems(): JsonResponse
    {
        // Example implementation: In a real application, inject EntityManagerInterface
        // and query the database using Doctrine ORM
        // $items = $this->entityManager->getRepository(Item::class)->findAll();
        
        // For now, return empty array as template placeholder
        // Replace this with actual database query when implementing your domain logic
        return new JsonResponse([
            'items' => [],
            'message' => 'Items endpoint - implement database query in production'
        ]);
    }
}

