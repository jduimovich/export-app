#!/bin/bash 
OUTPUT_DIR=$1
DBG_DIR=$2 
o=$3
i=$4

SCRIPT_DIR=$(dirname "$0") 
echo "Resource: " $o $i
mkdir -p $OUTPUT_DIR/$o   
mkdir -p $DBG_DIR/$o   
kubectl get -o=json $o $i >$DBG_DIR/$o/$i.raw.json
bash $SCRIPT_DIR/delete-unused-fields.sh $DBG_DIR/$o/$i.raw.json > $DBG_DIR/$o/$i.json
cat $DBG_DIR/$o/$i.json | yq eval -P >  $OUTPUT_DIR/$o/$i.yaml 
