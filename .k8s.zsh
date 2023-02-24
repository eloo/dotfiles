alias crossplane-unsynced="k get managed -o=jsonpath='{.items[?(@.status.conditions[1].status==\"False\")]}' | jq --raw-output '[.kind, .metadata.name, .status.conditions[1].message] | @tsv'"

antibody bundle ohmyzsh/ohmyzsh path:plugins/kubectl >>~/.zsh_plugins.zsh

compinit