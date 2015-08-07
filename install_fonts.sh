#!/bin/bash

cd $(dirname $0)

git submodule update --init fonts/powerline-patched

mkdir -p ~/.fonts
mkdir -p ~/.fonts.conf.d

cp -v fonts/PowerlineSymbols.otf ~/.fonts
cp -v fonts/10-powerline-symbols.conf ~/.fonts.conf.d

bash fonts/powerline-patched/install.sh
