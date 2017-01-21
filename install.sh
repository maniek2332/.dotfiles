#!/bin/bash

cd `dirname $0`
DOTFILES_DIR=`pwd`
TARGET_DIR="$DOTFILES_DIR/.."

TARGETS=()

function add_target {
    TARGETS[${#TARGETS[@]}]="$DOTFILES_DIR/$1"
    TARGETS[${#TARGETS[@]}]="$TARGET_DIR/$2"
}

add_target "zsh/"                       ".zsh"
add_target "zsh/zshrc"                  ".zshrc"
add_target "git/gitignore"              ".gitignore"
add_target "git/gitconfig"              ".gitconfig"
add_target "xbindkeys/xbindkeysrc"      ".xbindkeysrc"
add_target "nyaovim/"                   ".config/nyaovim"
add_target "../.vim/"                   ".config/nvim"

for (( I=0; I<${#TARGETS[@]}; I+=2 ))
do
    SOURCE=${TARGETS[$I]}
    TARGET=${TARGETS[$[I+1]]}
    echo $I: ${SOURCE} '->' ${TARGET}
    ln -s -i -v -T ${SOURCE} ${TARGET}
done
