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
        // TODO: Implement actual logic
        return new JsonResponse(['items' => []]);
    }
}

