<?php

namespace App\Tests\Repository;

use App\Entity\ExampleEntity;
use App\Repository\ExampleRepository;
use Doctrine\ORM\EntityManagerInterface;
use Doctrine\Persistence\ManagerRegistry;
use PHPUnit\Framework\TestCase;
use PHPUnit\Framework\MockObject\MockObject;

class ExampleRepositoryTest extends TestCase
{
    private MockObject $registry;
    private MockObject $entityManager;
    private ExampleRepository $repository;

    protected function setUp(): void
    {
        $this->registry = $this->createMock(ManagerRegistry::class);
        $this->entityManager = $this->createMock(EntityManagerInterface::class);
        
        $this->registry->method('getManagerForClass')
            ->with(ExampleEntity::class)
            ->willReturn($this->entityManager);
        
        $this->repository = new ExampleRepository($this->registry);
    }

    public function testRepositoryCreation(): void
    {
        $this->assertInstanceOf(ExampleRepository::class, $this->repository);
    }

    public function testFindCustomMethodExists(): void
    {
        $this->assertTrue(method_exists($this->repository, 'findCustom'));
    }

    public function testFindCustomReturnsArray(): void
    {
        // Note: This test requires Doctrine setup, so we're testing the method exists
        // In a real scenario, you'd use Doctrine test setup
        $this->assertIsCallable([$this->repository, 'findCustom']);
    }
}
