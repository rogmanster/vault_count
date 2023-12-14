#!/bin/bash

counter=0

#root
echo namespace: root
vault auth list -format=json | jq -r '.[].type'
counter=$(vault auth list -format=json | jq -r '.[].type' | wc -l)
echo ""
echo "total:$counter"

#namespaces
while read namespace 
do 
  total=0
  echo "========================================="
  echo "namespace: $namespace"
  vault auth list -namespace=$namespace -format=json | jq -r '.[].type'
  total=$(vault auth list -namespace=$namespace -format=json | jq -r '.[].type' | wc -l)
  echo ""
  echo "total:$total"
  ((counter+=total))
done < <(source namespace.sh $1) 

#total counts
echo
echo "========================================="
echo "total auth mounts: $counter"
