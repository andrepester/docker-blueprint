.SILENT:

COLOR_RESET   = \033[0m
COLOR_INFO    = \033[32m
COLOR_COMMENT = \033[33m

RUN_IN_CONTAINER = docker-compose -f .docker/php-cli/docker-compose.yml run --rm php-cli

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

## will setup docker containers, network and installing composer packages
install: build network

## will setup docker containers
build:
	docker-compose -f .docker/php-cli/docker-compose.yml build
	docker-compose -f .docker/php-cli/docker-compose.yml down;

## will setup docker network
network:
	 docker network ls | grep docker-blueprint || docker network create docker-blueprint

## will enter a bash within php-cli docker container
bash:
	$(RUN_IN_CONTAINER)