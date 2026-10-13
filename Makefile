CORE     := bash fish git vim tmux screen ack bc gdb irb pylint bin
OPTIONAL := hive mysql psql
PACKAGES ?= $(CORE)

# Directories that must be real directories, not symlinks into this repo, so
# that stow links individual files and apps can write their own files next to
# them.
DIRS := $(HOME)/.vim $(HOME)/.config/bash $(HOME)/.config/fish/conf.d \
        $(HOME)/.config/fish/functions

.PHONY: install uninstall restow submodules bootstrap

install: submodules
	mkdir -p $(DIRS)
	mkdir -p -m 700 $(HOME)/.bin
	stow --target=$(HOME) $(PACKAGES)

uninstall:
	stow --target=$(HOME) -D $(CORE) $(OPTIONAL)

restow: submodules
	stow --target=$(HOME) -R $(PACKAGES)

submodules:
	git submodule update --init --recursive

# Things stow can't do: Firefox profile links and VS Code settings copies.
bootstrap:
	./bootstrap.sh
