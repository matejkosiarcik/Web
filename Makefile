# This Makefile does not contain any build steps
# It only groups scripts to use in project

MAKEFLAGS += --warn-undefined-variables
SHELL := /bin/sh  # for compatibility (mainly with redhat distros)
.SHELLFLAGS := -ec
MAKEFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
PROJECT_DIR := $(realpath $(dir $(abspath $(MAKEFILE_LIST))))
BUNDLE_ENV := BUNDLE_DISABLE_SHARED_GEMS=true BUNDLE_PATH__SYSTEM=false BUNDLE_PATH="$(PROJECT_DIR)/jekyll/.bundle" BUNDLE_GEMFILE=$(PROJECT_DIR)/jekyll/Gemfile

.POSIX:

.DEFAULT: all
.PHONY: all
all: bootstrap lint build

.PHONY: bootstrap
bootstrap:
	@$(MAKE) -C$(PROJECT_DIR)/web bootstrap
	npm install --prefix analytics

.PHONY: lint
lint:
	@$(MAKE) -C$(PROJECT_DIR)/web lint
	npm run --prefix analytics lint

.PHONY: build
build:
	@$(MAKE) -C$(PROJECT_DIR)/web build
	npm run --prefix analytics build