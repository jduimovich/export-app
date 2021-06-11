#!/bin/bash 
OUTPUT_DIR=$1
DBG_DIR=$2
IGNORES=$3
o=$4 
 
SCRIPT_DIR=$(dirname "$0") 
for i in `kubectl get $o --ignore-not-found | egrep -v ${IGNORES} | grep -v NAME | awk '{print $1}'`; do
  bash $SCRIPT_DIR/export-single-resource.sh $OUTPUT_DIR $DBG_DIR  $o $i 
done 
tree $OUTPUT_DIR > tree.txt




