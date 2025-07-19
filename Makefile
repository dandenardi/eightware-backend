.PHONY: setup install server test clean docker-build docker-up docker-down


setup:
	bundle install
	cp .env.example .env
	rails db:create
	rails db:migrate


install:
	bundle install


server:
	rails server


test:
	bundle exec rspec


clean:
	rm -rf log/*.log
	rm -rf tmp/*


docker-build:
	docker-compose build

docker-up:
	docker-compose up

docker-down:
	docker-compose down

docker-reset:
	docker-compose down -v
	docker-compose up --build


db-reset:
	rails db:reset

db-migrate:
	rails db:migrate

db-rollback:
	rails db:rollback


test-models:
	bundle exec rspec spec/models/

test-requests:
	bundle exec rspec spec/requests/

test-coverage:
	COVERAGE=true bundle exec rspec