.DEFAULT_GOAL=test
RUBY_VER=$(shell (head -n 1 .ruby-version))
DB_CREDS=$(shell (echo $(DATABASE_URL) | grep -Po '(?<=postgresql://)[^@]*'))
DB_CONN=$(shell (echo $(DATABASE_URL) | grep -Po '^[^\?]+'))
DB_USER=$(shell (echo $(DB_CREDS) | grep -Po '^\w*'))
DB_PASSWORD=$(shell (echo $(DB_CREDS) | grep -Po '(?<=:)[\w]*'))
DB_HOSTPORTNAME=$(shell (echo $(DATABASE_URL) | grep -Po '(?<=@)[^\?]+' ))
DB_HOST=$(shell (echo $(DB_CONN) | grep -Po '(?<=@)[^:]+'))
DB_NAME=$(shell (echo $(DB_HOSTPORTNAME) | grep -Po '(?<=/).+'))
DB_PORT=$(shell (echo $(DB_HOSTPORTNAME) | grep -Po '(?<=:)[^/]+'))

DEV_ENV=SSL_CERT_FILE=/vagrant/ssl/rootCA.pem

CWD=$(shell pwd)

config-test:
ifeq ($(DATABASE_URL),)
	@echo "run 'export \$$$ (xargs -a .env)' to load environmental variables"
	@exit 2
endif

config-print: config-test
	@echo DATABASE_URL=$(DATABASE_URL)
	@echo DB_CREDS=$(DB_CREDS)
	@echo DB_CONN=$(DB_CONN)
	@echo DB_USER=$(DB_USER)
	@echo DB_PASSWORD=$(DB_PASSWORD)
	@echo DB_NAME=$(DB_NAME)
	@echo DB_HOST=$(DB_HOST)
	@echo DB_PORT=$(DB_PORT)

setup: config-print setup-basic
	@echo "Setup Complete"

setup-basic:
	bash -c 'cd ../../.rbenv/plugins/ruby-build && git checkout master && git pull'
	echo "Installing Ruby $(RUBY_VER)..."
	rbenv install $(RUBY_VER) -s
	bundle install

test: specs cukes rubocop
	@echo "\nTesting Complete\n"
rubocop:
	RAILS_ENV=test bundle exec rubocop

specs:
	RAILS_ENV=test bundle exec rspec

cukes:
	RAILS_ENV=test bundle exec cucumber

guard:
	RAILS_ENV=test bundle exec guard --group rails

server-ssl:
	$(DEV_ENV) bundle exec rails s puma -b 'ssl://0.0.0.0:$(PORT)?key=/vagrant/ssl/server.key&cert=/vagrant/ssl/server.crt'

db-migrate:
	bundle exec rake db:migrate

db-reset: db-drop-tables db-migrate
	bundle exec rake db:seed
	echo "Reset Complete"

db-load:
	bundle exec rake db:schema:load

db-setup: db-createuser db-createdb

db-wipe: db-dropdb db-dropuser

db-drop-tables:
	psql -d $(DB_CONN) -c "DROP OWNED BY $(DB_USER);"

db-createdb:
	sudo -u postgres psql -c 'CREATE DATABASE $(DB_NAME) WITH OWNER = $(DB_USER);'

db-dropdb:
	sudo -u postgres dropdb $(DB_NAME)

db-createuser:
	sudo -u postgres psql -c "CREATE USER $(DB_USER) WITH PASSWORD '$(DB_PASSWORD)' SUPERUSER;"

db-dropuser:
	sudo -u postgres dropuser $(DB_USER)

db-travis: db-travis-setup db-migrate

db-travis-setup:
	psql -U postgres -c 'create database $(DB_NAME)'
