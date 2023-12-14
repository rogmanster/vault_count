#!/bin/bash

counter=0

#root
echo "namespace: root"
curl -s -H "X-Vault-Token: $VAULT_TOKEN" $VAULT_ADDR/v1/sys/auth | jq -r '.["data"][]["type"]'
counter=$(curl -s -H "X-Vault-Token: $VAULT_TOKEN" $VAULT_ADDR/v1/sys/auth \
  | jq -r '.["data"][]["type"]' | wc -l)
echo "total:$counter"

#namespaces
while read namespace 
do 
  total=0
  echo "========================================="
  echo "namespace: $namespace"
  curl -s -H "X-Vault-Token: $VAULT_TOKEN" $ "X-Vault-namespace: $namespace" $VAULT_ADDR/v1/sys/auth \
    | jq -r '.["data"][]["type"]'
  total=$(curl -s -H "X-Vault-Token: $VAULT_TOKEN" -H "X-Vault-namespace: $namespace" $VAULT_ADDR/v1/sys/auth \
    | jq -r '.["data"][]["type"]' | wc -l)
  echo "total:$total"
  ((counter+=total))
done < <(source namespace.sh $1) 

#totals
echo "========================================="
echo "total auth mounts: $counter"
