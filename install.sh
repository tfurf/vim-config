#!/bin/bash

cwd=$(dirname $0); 
t=".vimrc"

while getopts f? k; do
  case "${k}" in
    f)
      force="yes"
      ;;
    ?)
      exit 1
      ;;
  esac
done

for f in ${t}; do
  [[ -f ${cwd}/${f} ]] && { 
    [[ ${force} == "yes" ]] && mv -v ~/${f} ~/${f}.bak;
    ln -vT ${cwd}/${f} ~/${f} ;
  }
done;
