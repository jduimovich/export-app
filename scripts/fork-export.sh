#!/bin/bash  
SCRIPT_DIR=$(dirname "$0")
export MAX_FORK=20
$SCRIPT_DIR/export-current-ns.sh 
    