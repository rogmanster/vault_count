#!/bin/bash

COUNTER=0

#Root
echo "NAMESPACE: root"
curl -s -H "X-Vault-Token: $VAULT_TOKEN" $VAULT_ADDR/v1/sys/auth | jq -r '.["data"][]["type"]'
COUNTER=$(curl -s -H "X-Vault-Token: $VAULT_TOKEN" $VAULT_ADDR/v1/sys/auth \
  | jq -r '.["data"][]["type"]' | wc -l)
echo "TOTAL:$COUNTER"

#Namespaces
while read NAMESPACE 
do 
  TOTAL=0
  echo "========================================="
  echo "NAMESPACE: $NAMESPACE"
  curl -s -H "X-Vault-Token: $VAULT_TOKEN" $ "X-Vault-namespace: $NAMESPACE" $VAULT_ADDR/v1/sys/auth \
    | jq -r '.["data"][]["type"]'
  TOTAL=$(curl -s -H "X-Vault-Token: $VAULT_TOKEN" -H "X-Vault-namespace: $NAMESPACE" $VAULT_ADDR/v1/sys/auth \
    | jq -r '.["data"][]["type"]' | wc -l)
  echo "TOTAL:$TOTAL"
  ((COUNTER+=TOTAL))
done < <(source namespace.sh $1) 

echo "========================================="
echo "TOTAL AUTH MOUNTS: $COUNTER"
