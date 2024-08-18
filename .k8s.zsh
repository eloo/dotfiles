
### Crossplane
alias crossplane-unsynced="k get managed -o=jsonpath='{.items[?(@.status.conditions[1].status==\"False\")]}' | jq --raw-output '[.kind, .metadata.name, .status.conditions[1].message] | @tsv'"

### Kubernetes
alias ky="kubectl -o yaml"
alias kgsecd='kubectl get secret -o go-template='"'"'{{range $k,$v := .data}}{{printf "%s: " $k}}{{if not $v}}{{$v}}{{else}}{{$v | base64decode}}{{end}}{{"\n"}}{{end}}'"'"''

alias k8s-not-running="kubectl get pods -A -o wide | grep -v Running"

antidote bundle ohmyzsh/ohmyzsh path:plugins/kubectl >>~/.zsh_plugins.zsh

compinit