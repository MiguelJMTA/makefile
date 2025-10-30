# Makefile Global para Git y Docker (con abreviaciones)
# Autor: MiguelJMTA https://github.com/MiguelJMTA
# Uso: export MAKEFILES=~/.makefile.global en tu .bashrc/.zshrc

.PHONY: help

# Variables de entorno con valores por defecto
DOCKER_REGISTRY ?= docker.io
DOCKER_USERNAME ?= $(USER)
IMAGE_NAME ?= $(shell basename $(CURDIR))
IMAGE_TAG ?= latest
CONTAINER_NAME ?= $(IMAGE_NAME)-container
DOCKER_COMPOSE_FILES ?= docker-compose.yml

GIT_BRANCH ?= $(shell git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "main")
GIT_COMMIT ?= $(shell git rev-parse --short HEAD 2>/dev/null || echo "unknown")
GIT_REMOTE ?= origin

# Colores para output
COLOR_RESET = \033[0m
COLOR_INFO = \033[36m
COLOR_SUCCESS = \033[32m

## Comandos de ayuda
help: ## Muestra esta ayuda
	@echo "$(COLOR_INFO)Comandos disponibles:$(COLOR_RESET)"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  $(COLOR_INFO)%-20s$(COLOR_RESET) %s\n", $$1, $$2}'

h: help ## Alias de help

## Comandos Git (abreviados)
gs: git-status ## Git status
git-status:
	@git status

gp: git-pull ## Git pull
git-pull:
	@echo "$(COLOR_INFO)Pulling from $(GIT_REMOTE)/$(GIT_BRANCH)$(COLOR_RESET)"
	@git pull $(GIT_REMOTE) $(GIT_BRANCH)

gP: git-push ## Git push
git-push:
	@echo "$(COLOR_INFO)Pushing to $(GIT_REMOTE)/$(GIT_BRANCH)$(COLOR_RESET)"
	@git push $(GIT_REMOTE) $(GIT_BRANCH)

gc: git-commit ## Git commit (uso: make gc msg="mensaje")
git-commit:
	@git add .
	@git commit -m "$(msg)"
	@echo "$(COLOR_SUCCESS)Commit realizado$(COLOR_RESET)"

gsy: git-sync ## Git sync: pull + commit + push (uso: make gsy msg="mensaje")
git-sync:
	@$(MAKE) git-pull
	@git add .
	@git commit -m "$(msg)" || true
	@$(MAKE) git-push
	@echo "$(COLOR_SUCCESS)Sincronización completa$(COLOR_RESET)"

gl: git-log ## Git log (últimos 10 commits)
git-log:
	@git log --oneline --graph --decorate -10

gb: git-branches ## Git branches
git-branches:
	@git branch -a

gclean: git-clean ## Git clean
git-clean:
	@git clean -fd

## Comandos Docker (abreviados)
db: docker-build ## Docker build
docker-build:
	@echo "$(COLOR_INFO)Building $(DOCKER_REGISTRY)/$(DOCKER_USERNAME)/$(IMAGE_NAME):$(IMAGE_TAG)$(COLOR_RESET)"
	@docker build -t $(DOCKER_REGISTRY)/$(DOCKER_USERNAME)/$(IMAGE_NAME):$(IMAGE_TAG) .
	@docker tag $(DOCKER_REGISTRY)/$(DOCKER_USERNAME)/$(IMAGE_NAME):$(IMAGE_TAG) $(IMAGE_NAME):latest
	@echo "$(COLOR_SUCCESS)Build completado$(COLOR_RESET)"

dbnc: docker-build-nc ## Docker build sin cache
docker-build-nc:
	@echo "$(COLOR_INFO)Building without cache$(COLOR_RESET)"
	@docker build --no-cache -t $(DOCKER_REGISTRY)/$(DOCKER_USERNAME)/$(IMAGE_NAME):$(IMAGE_TAG) .

dr: docker-run ## Docker run
docker-run:
	@docker run -d --name $(CONTAINER_NAME) $(DOCKER_REGISTRY)/$(DOCKER_USERNAME)/$(IMAGE_NAME):$(IMAGE_TAG)
	@echo "$(COLOR_SUCCESS)Container $(CONTAINER_NAME) iniciado$(COLOR_RESET)"

ds: docker-stop ## Docker stop
docker-stop:
	@docker stop $(CONTAINER_NAME) || true
	@echo "$(COLOR_SUCCESS)Container detenido$(COLOR_RESET)"

drm: docker-rm ## Docker remove container
docker-rm:
	@docker rm -f $(CONTAINER_NAME) || true
	@echo "$(COLOR_SUCCESS)Container eliminado$(COLOR_RESET)"

dl: docker-logs ## Docker logs
docker-logs:
	@docker logs -f $(CONTAINER_NAME)

dsh: docker-shell ## Docker shell
docker-shell:
	@docker exec -it $(CONTAINER_NAME) /bin/bash || docker exec -it $(CONTAINER_NAME) /bin/sh

dps: docker-ps ## Docker ps
docker-ps:
	@docker ps

di: docker-images ## Docker images
docker-images:
	@docker images

dpu: docker-push ## Docker push
docker-push:
	@echo "$(COLOR_INFO)Pushing to $(DOCKER_REGISTRY)$(COLOR_RESET)"
	@docker push $(DOCKER_REGISTRY)/$(DOCKER_USERNAME)/$(IMAGE_NAME):$(IMAGE_TAG)
	@echo "$(COLOR_SUCCESS)Push completado$(COLOR_RESET)"

dpl: docker-pull ## Docker pull
docker-pull:
	@docker pull $(DOCKER_REGISTRY)/$(DOCKER_USERNAME)/$(IMAGE_NAME):$(IMAGE_TAG)

dclean: docker-clean ## Docker clean
docker-clean:
	@docker system prune -f
	@echo "$(COLOR_SUCCESS)Limpieza completada$(COLOR_RESET)"

dcleanall: docker-clean-all ## Docker clean all
docker-clean-all:
	@docker system prune -af --volumes
	@echo "$(COLOR_SUCCESS)Limpieza total completada$(COLOR_RESET)"

## Comandos Docker Compose (abreviados)
cu: compose-up ## Compose up
compose-up:
	@docker compose -f $(DOCKER_COMPOSE_FILES) up -d
	@echo "$(COLOR_SUCCESS)Servicios levantados$(COLOR_RESET)"

cd: compose-down ## Compose down
compose-down:
	@docker compose -f $(DOCKER_COMPOSE_FILES) down
	@echo "$(COLOR_SUCCESS)Servicios detenidos$(COLOR_RESET)"

cl: compose-logs ## Compose logs
compose-logs:
	@docker compose -f $(DOCKER_COMPOSE_FILES) logs -f

cps: compose-ps ## Compose ps
compose-ps:
	@docker compose -f $(DOCKER_COMPOSE_FILES) ps

cr: compose-restart ## Compose restart
compose-restart:
	@docker compose -f $(DOCKER_COMPOSE_FILES) restart

cb: compose-build ## Compose build
compose-build:
	@docker compose -f $(DOCKER_COMPOSE_FILES) build

## Comandos combinados (abreviados)
rb: rebuild ## Rebuild: stop + rm + build + run
rebuild: docker-stop docker-rm docker-build docker-run

dep: deploy ## Deploy: pull + build + push
deploy: git-pull docker-build docker-push

v: version ## Version info
version:
	@echo "Git Commit: $(GIT_COMMIT)"
	@echo "Git Branch: $(GIT_BRANCH)"
	@echo "Image: $(DOCKER_REGISTRY)/$(DOCKER_USERNAME)/$(IMAGE_NAME):$(IMAGE_TAG)"
