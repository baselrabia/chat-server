# Variables
DOCKER_COMPOSE=docker-compose
SERVICE=api

# Targets
.PHONY: up down migrate create_index import_data restart build setup

up:
	$(DOCKER_COMPOSE) up -d

down:
	$(DOCKER_COMPOSE) down

migrate:
	$(DOCKER_COMPOSE) run $(SERVICE) bundle exec rails db:migrate

esc_index:
	$(DOCKER_COMPOSE) run $(SERVICE) bundle exec rake elasticsearch:create_index

esc_import:
	$(DOCKER_COMPOSE) run $(SERVICE) bundle exec rake elasticsearch:import

restart:
	$(DOCKER_COMPOSE) down
	$(DOCKER_COMPOSE) up -d

build:
	$(DOCKER_COMPOSE) up -d --build

# Helper target to run all necessary steps for a full setup
setup: down build up migrate create_index import_data
