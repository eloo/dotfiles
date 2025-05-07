
### Crossplane
alias crossplane-unsynced="k get managed -o=jsonpath='{.items[?(@.status.conditions[1].status==\"False\")]}' | jq --raw-output '[.kind, .metadata.name, .status.conditions[1].message] | @tsv'"

### Kubernetes
alias ky="kubectl -o yaml"
alias kgsecd='kubectl get secret -o go-template='"'"'{{range $k,$v := .data}}{{printf "%s: " $k}}{{if not $v}}{{$v}}{{else}}{{$v | base64decode}}{{end}}{{"\n"}}{{end}}'"'"''


# Alias for codium
if command -v codium &> /dev/null
then
    export KUBE_EDITOR="codium --wait"
fi

compinit