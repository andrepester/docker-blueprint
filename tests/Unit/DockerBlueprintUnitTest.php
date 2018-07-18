<?php

namespace DockerBlueprint\Test\Unit;

use DockerBlueprint\DockerBlueprint;
use PHPUnit\Framework\TestCase;

/**
 * @covers \DockerBlueprint\DockerBlueprint
 */
class DockerBlueprintUnitTest extends TestCase
{
    public function testDoSomething()
    {
        $class = new DockerBlueprint();

        $this->assertTrue($class->doSomething());
    }
}
