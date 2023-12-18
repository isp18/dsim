#!/bin/bash

if [ $1 -gt 5 ]; then
  apps="0 1 2 3 4 5"
else
  apps=$1
fi

if [ -z "$4" ]; then
  echo "Default grid_w=64"
  let grid_w=64
else
  let grid_w=$4
  echo "grid_w=$grid_w"
fi
if [ -z "$5" ]; then
  echo "All datasets by default"
  datasets="Kron22 wikipedia"
else
  echo "Dataset $5"
  datasets="$5"
fi

declare -A options
declare -A strings

th=8
verbose=2
assert=0
exp="HEAT"

let noc_conf=1
let dcache=0
let ruche=0
let torus=0

let chiplet_w=$grid_w
let board_w=$grid_w #Specify board so that the package has the same size as the board

local_run=0

sufix="-v $verbose -r $assert -t $th -u $noc_conf -m $grid_w -c $chiplet_w -k $board_w -l $ruche -y $dcache -s $local_run"
i=0
let proxy_w=$grid_w
strings[$i]="${exp}0"
options[$i]="-n ${strings[$i]} -e $proxy_w -o 0 -b 1 $sufix"
let i=$i+1

strings[$i]="${exp}1"
options[$i]="-n ${strings[$i]} -e $proxy_w -o 1 -b 1 $sufix"
let i=$i+1

strings[$i]="${exp}2"
options[$i]="-n ${strings[$i]} -e 8 -o 1 -j 0 -b 1 $sufix"
let i=$i+1

###############

for c in $(seq $2 $3) #inclusive
do
  echo ${strings[$c]}
  echo "${options[$c]}"
  echo
  exp/run.sh ${options[$c]} -d "$datasets" -a "$apps"
done
