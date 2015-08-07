#!/bin/bash

cd $(dirname $0)

TARGETS=()

function add_target {
    TARGETS[${#TARGETS[@]}]="$1"
    TARGETS[${#TARGETS[@]}]="../$2"
}

add_target "zsh/" ".zsh"
add_target "zsh/zshrc" ".zshrc"

for (( I=0; I<${#TARGETS[@]}; I+=2 ))
do
    SOURCE=${TARGETS[$I]}
    TARGET=${TARGETS[$[I+1]]}
    echo $I: ${SOURCE} '->' ${TARGET}
    ln -s -i -v -T -r ${SOURCE} ${TARGET}
done
