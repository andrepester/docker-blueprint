<?php declare(strict_types=1);

namespace DockerBlueprint\Test\System;

use PHPUnit\Framework\TestCase;

class SystemTest extends TestCase
{
    public function testSystem()
    {
        $this->assertEquals('www-data', exec('whoami'));
    }
}