#!/bin/bash

CWD="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
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
  [[ -f ${CWD}/${f} ]] && {
    [[ ${force} == "yes" ]] && rm -v ~/${f} ;
    ln -vsT ${CWD}/${f} ~/${f} ;
  }
done;
