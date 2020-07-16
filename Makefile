# This Makefile does not contain any build steps
# It only groups scripts to use in project

MAKEFLAGS += --warn-undefined-variables
SHELL := /bin/sh  # for compatibility (mainly with redhat distros)
.SHELLFLAGS := -ec
MAKEFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))

.POSIX:

.DEFAULT: all
.PHONY: all
all: bootstrap lint build

.PHONY: bootstrap
bootstrap:
	# if command -v rbenv >/dev/null 2>&1; then rbenv install --skip-existing || true; fi
	gem install bundler
	bundle install --gemfile $(CURDIR)/web/jekyll/Gemfile
	npm install --prefix $(CURDIR)/web

.PHONY: lint
lint:
	npm run --prefix $(CURDIR)/web lint

.PHONY: clean
clean:
	rm -f web/assets/favicon/favicon.png web/assets/favicon/favicon.ico
	BUNDLE_GEMFILE=$(CURDIR)/web/jekyll/Gemfile bundle exec rake -f $(CURDIR)/web/jekyll/Rakefile clean
	npm run --prefix $(CURDIR)/web clean

.PHONY: build
build:
	BUNDLE_GEMFILE=$(CURDIR)/web/jekyll/Gemfile bundle exec rake -f $(CURDIR)/web/jekyll/Rakefile build
	npm run --prefix $(CURDIR)/web build

.PHONY: run
run:
	BUNDLE_GEMFILE=$(CURDIR)/web/jekyll/Gemfile bundle exec rake -f $(CURDIR)/web/jekyll/Rakefile prestart
	@$(MAKE) -j2 -C$(CURDIR) -f$(MAKEFILE_PATH) _run

.PHONY: _run # this target should be invoked with -j2 option to run dependant targets in paralle
_run: run_npm run_rake

.PHONY: run_npm
run_npm:
	npm start --prefix $(CURDIR)/web

.PHONY: run_rake
run_rake:
	BUNDLE_GEMFILE=$(CURDIR)/web/jekyll/Gemfile bundle exec rake -f $(CURDIR)/web/jekyll/Rakefile start
