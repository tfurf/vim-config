#!/bin/bash

cwd=$(dirname $0); 
t=".vimrc"

for f in ${t}; do
  [[ -f ${cwd}/${f} ]] && { 
    ln -vT ${cwd}/${f} ~/${f} ;
    echo ${f};
  }
done;

