### Requirements
* Vault Binary (ENT)
* jq

### Instructions 
export VAULT_ADDR
export VAULT_TOKEN

$./script <number>

Note: <number> is how many nested namespaces you'd like to recursively cycle through

### Example output:
```
$ ./script.sh 6

namespace: root
approle
aws
token
userpass

total:       4
=========================================
namespace: ns1/
approle
aws
ns_token
userpass

total:       4
=========================================
namespace: ns1/a/
approle
ns_token

total:       2
=========================================
namespace: ns1/a/aa/
ns_token

total:       1
=========================================
namespace: ns1/b/
approle
ns_token

total:       2
=========================================
namespace: ns1/b/bb/
ns_token

total:       1
=========================================
namespace: ns1/c/
approle
ns_token

total:       2
=========================================
namespace: ns1/c/cc/
approle
aws
ns_token
userpass

total:       4
=========================================
namespace: ns2/
ns_token

total:       1
=========================================
namespace: ns3/
ns_token

total:       1
=========================================
namespace: ns3/a/
ns_token

total:       1
=========================================
namespace: ns3/a/b/
ns_token

total:       1
=========================================
namespace: ns3/a/b/c/
ns_token

total:       1
=========================================
namespace: ns3/a/b/c/d/
ns_token

total:       1
=========================================
namespace: ns3/a/b/c/d/e/
approle
aws
ns_token
userpass

total:       4
=========================================
total auth mounts: 30
```
