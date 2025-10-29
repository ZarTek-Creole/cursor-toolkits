<?php

declare(strict_types=1);

namespace App\Repository;

use App\Entity\ExampleEntity;
use Doctrine\Bundle\DoctrineBundle\Repository\ServiceEntityRepository;
use Doctrine\Persistence\ManagerRegistry;

class ExampleRepository extends ServiceEntityRepository
{
    public function __construct(ManagerRegistry $registry)
    {
        parent::__construct($registry, ExampleEntity::class);
    }

    public function findCustom(): array
    {
        return $this->createQueryBuilder('e')
            ->select('e')
            ->getQuery()
            ->getResult();
    }
}

