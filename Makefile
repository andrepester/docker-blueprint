#.SILENT:

COLOR_RESET   = \033[0m
COLOR_INFO    = \033[32m
COLOR_COMMENT = \033[33m

RUN_IN_CONTAINER = docker-compose -f .docker/php-cli/docker-compose.yml run --rm php-cli
EXEC_IN_CONTAINER = $(RUN_IN_CONTAINER) -c
QUOTE = "
PHPUNIT = vendor/bin/phpunit

## shows this manual
help:
	printf "${COLOR_COMMENT}Usage:${COLOR_RESET}\n"
	printf " make [target]\n\n"
	printf "${COLOR_COMMENT}Available targets:${COLOR_RESET}\n"
	awk '/^[a-zA-Z\-\_0-9\.@]+:/ { \
		helpMessage = match(lastLine, /^## (.*)/); \
		if (helpMessage) { \
			helpCommand = substr($$1, 0, index($$1, ":")); \
			helpMessage = substr(lastLine, RSTART + 3, RLENGTH); \
			printf " ${COLOR_INFO}%-16s${COLOR_RESET} %s\n", helpCommand, helpMessage; \
		} \
	} \
	{ lastLine = $$0 }' $(MAKEFILE_LIST)

## setups docker containers, network and installing composer packages
install: build network composer-install

## setups docker containers
build:
	mkdir .docker/php-cli/logs
	touch .docker/php-cli/logs/.bash_history
	docker-compose -f .docker/php-cli/docker-compose.yml build
	docker-compose -f .docker/php-cli/docker-compose.yml down;

## setups docker network
network:
	 docker network ls | grep docker-blueprint || docker network create docker-blueprint

## enters a bash within php-cli docker container
bash:
	$(RUN_IN_CONTAINER)

## runs install command of composer
composer-install:
	$(EXEC_IN_CONTAINER) $(QUOTE)composer install -o$(QUOTE)

## dumps autloading file
composer-autoload:
	$(EXEC_IN_CONTAINER) $(QUOTE)composer du -o$(QUOTE)

## runs all tests
test: test-unit test-int test-sys

## runs unit tests
test-unit: test-cleanup composer-autoload
	$(EXEC_IN_CONTAINER) $(QUOTE)$(PHPUNIT) -c tests/phpunit_unit.xml$(QUOTE)

## runs integration tests
test-int:
	$(EXEC_IN_CONTAINER) $(QUOTE)$(PHPUNIT) -c tests/phpunit_integration.xml --no-coverage$(QUOTE)

## runs system tests
test-sys:
	$(EXEC_IN_CONTAINER) $(QUOTE)$(PHPUNIT) -c tests/phpunit_system.xml --no-coverage$(QUOTE)

## clears reports directory
test-cleanup:
	rm -rf tests/reports/*