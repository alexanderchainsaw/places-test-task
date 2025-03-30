.PHONY: default venv lint pretty lint-win pretty-win dev-start dev-stop dev-build

default:
	@echo "There is no default target."

venv:
	rm -rf venv
	python -m venv venv
	./venv/bin/pip install -r requirements.txt

lint:
	./venv/bin/black --check -l 79 places
	./venv/bin/flake8 places
	./venv/bin/isort -c --src places --profile black -l 79 places

pretty:
	./venv/bin/black -l 79 places
	./venv/bin/flake8 places
	./venv/bin/isort --src places --profile black -l 79 places

lint-win:
	./venv/Scripts/black --check -l 79 places
	./venv/Scripts/flake8 places
	./venv/Scripts/isort -c --src places --profile black -l 79 places

pretty-win:
	./venv/Scripts/black -l 79 places
	./venv/Scripts/flake8 places
	./venv/Scripts/isort --src places --profile black -l 79 places

dev-start:
	docker-compose -f deployments/docker-compose.dev.yml up -d --force-recreate --remove-orphans

dev-stop:
	docker-compose -f deployments/docker-compose.dev.yml down

dev-build:
	docker-compose -f deployments/docker-compose.dev.yml build --no-cache

run: dev-stop dev-build dev-start