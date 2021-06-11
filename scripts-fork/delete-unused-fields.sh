
SCRIPT_DIR=$(dirname "$0")

echo running $0 for $1

bash $SCRIPT_DIR/../scripts/delete-unused-fields.sh $1 