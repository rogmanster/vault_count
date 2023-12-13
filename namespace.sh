#!/bin/sh
#
# First passing argument is the depth of searching and the second argument is the
# starting namespace.
# If the first argument is not an integer then this argument is considered the
# starting namespace and depth is set to level=1

export all_namespaces=""
export cosmetic_namespace=""
export level=1

function getnamespaces() {
# Recursive function for collecting all the namespaces in a variable
# First argument is the depth of recursivity
# Second argument is the starting namespace
# If the first argument is not a number than we bail out
case $1 in
'' | *[!0-9]*) return 1 ;;
*) : ;;
esac

# If we reach to the last level then we end the recursive loop
(($1 < 1)) && return 0

for i in $(vault namespace list -ns=$2 2>>/dev/null | sed -e '1,2d'); do
{
export all_namespaces=$(echo $all_namespaces "$2$i")
if [ "X$2" == "X" ]; then
(($1 > 1)) && getnamespaces $(($1 - 1)) "$i"
else
(($1 > 1)) && getnamespaces $(($1 - 1)) "$2$i"
fi
}
done
return 0
}

# Getting all arguments from OS as ARGS. By default we use the level depth 1.
# If the first argument is NOT an integer we consider the string as namespace
# starting and level depth 1.

case $1 in
'' | *[!0-9]*)
(($# >= 1)) && export namespace=$(echo $1)
export level=1
;;
*)
(($# >= 1)) && export level=$(echo $1)
export level=${level:=1}
# Sanitize input level - removes left zeroes to avoid OCTAL conversion
([[ ! -z "${level}" ]] && [[ "${level}" =~ ^[0-9]+$ ]]) &&
export level=${level#${level%%[1-9]*}}
export level=${level:=1}
#
(($# >= 2)) && export namespace=$(echo $2)
;;
esac

export namespace=${namespace:=root}

# If the namespace is default then we empty the namespace starting point.
# Otherwise we only ensure that the last character is '/' .
if [[ "X${namespace}" == "Xroot" ]]; then
export namespace=""
else
[[ $(echo ${namespace: -1}) == '/' ]] || export namespace="${namespace}/"
fi
export cosmetic_namespace=${namespace}
export cosmetic_namespace=${cosmetic_namespace:=root/}

#echo "### Searching namespaces starting with ${cosmetic_namespace} and depth ${level} ."
getnamespaces ${level} ${namespace}
echo "$all_namespaces" | sed 's/ /\n/g'
# Cleanup the variables for multiple executions
unset all_namespaces namespace level cosmetic_namespace
