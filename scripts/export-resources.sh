#!/bin/bash 
OUTPUT_DIR=$1
DBG_DIR=$2
IGNORES=$3
o=$4 

MAX_FORK=3
COUNTER=0
SCRIPT_DIR=$(dirname "$0") 
for i in `kubectl get $o --ignore-not-found | egrep -v ${IGNORES} | grep -v NAME | awk '{print $1}'`; do
  let counter++
  bash $SCRIPT_DIR/export-single-resource.sh $OUTPUT_DIR $DBG_DIR  $o $i & 
  echo $o $i >> stdout.txt
  echo $counter
  if [[ "$counter" -eq $MAX_FORK ]]; then
       counter=0 
       wait  
  fi
done 
wait
tree $OUTPUT_DIR > tree.txt




