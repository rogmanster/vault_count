#!/bin/bash

echo namespace: root
vault auth list -format=json | jq -r '.[].type'
echo total: "$(vault auth list -format=json | jq -r '.[].type' | wc -l)"

source namespace.sh $1 | 

while read NAMESPACE; do 
  echo =========================================
  echo namespace: "$NAMESPACE"
  vault auth list -namespace=$NAMESPACE -format=json | jq -r '.[].type'
  echo total: "$(vault auth list -namespace=$NAMESPACE -format=json | jq -r '.[].type' | wc -l)"
done
