#!/bin/bash

BREW_PACKAGES="gcc python neovim/neovim/neovim ranger npm"
PIP_PACKAGES="neovim"
NPM_PACKAGES="nyaovim"

echo "Packages to install: ${BREW_PACKAGES} ${PIP_PACKAGES} ${NPM_PACKAGES}"

for PACKAGE in $BREW_PACKAGES
do
    brew install "${PACKAGE}"
done

for PACKAGE in $PIP_PACKAGES
do
    pip install "${PACKAGE}"
done

for PACKAGE in $NPM_PACKAGES
do
    npm install -g "${PACKAGE}"
done
