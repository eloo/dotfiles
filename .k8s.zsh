
### Crossplane
alias crossplane-unsynced="k get managed -o=jsonpath='{.items[?(@.status.conditions[1].status==\"False\")]}' | jq --raw-output '[.kind, .metadata.name, .status.conditions[1].message] | @tsv'"

### Kubernetes
alias ky="kubectl -o yaml"

antibody bundle ohmyzsh/ohmyzsh path:plugins/kubectl >>~/.zsh_plugins.zsh

compinit