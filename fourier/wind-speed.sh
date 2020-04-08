#!/bin/bash

device="$1"
fileName="$2"

if [ $1 = "wxt500" ]
then
  while read -r line; do echo "$line" | cut -d, -f4 | sed s/[^0-9.]//g; done < $2
else
  if [[ $1 = "wmt700" ]]
  then
    while read -r line; do echo $line | cut -d\$ -f2 | cut -d, -f1 | sed s/[^0-9.]//g | bc; done < $2
  fi
fi
