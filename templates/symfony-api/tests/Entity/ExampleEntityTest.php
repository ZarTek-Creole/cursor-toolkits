<?php

namespace App\Tests\Entity;

use App\Entity\ExampleEntity;
use PHPUnit\Framework\TestCase;

class ExampleEntityTest extends TestCase
{
    public function testEntityCreation(): void
    {
        $entity = new ExampleEntity();
        $this->assertInstanceOf(ExampleEntity::class, $entity);
    }

    public function testGetId(): void
    {
        $entity = new ExampleEntity();
        $this->assertNull($entity->getId());
    }

    public function testGetName(): void
    {
        $entity = new ExampleEntity();
        $this->assertNull($entity->getName());
    }

    public function testSetName(): void
    {
        $entity = new ExampleEntity();
        $name = "Test Name";
        $result = $entity->setName($name);
        
        $this->assertSame($entity, $result);
        $this->assertEquals($name, $entity->getName());
    }

    public function testSetNameReturnsSelf(): void
    {
        $entity = new ExampleEntity();
        $result = $entity->setName("Test");
        
        $this->assertInstanceOf(ExampleEntity::class, $result);
        $this->assertSame($entity, $result);
    }

    public function testSetNameWithDifferentValues(): void
    {
        $entity = new ExampleEntity();
        
        $entity->setName("First Name");
        $this->assertEquals("First Name", $entity->getName());
        
        $entity->setName("Second Name");
        $this->assertEquals("Second Name", $entity->getName());
    }
}
