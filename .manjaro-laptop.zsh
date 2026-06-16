# Manjaro Zsh Configuration

if [[ ${DEBUG_ZSH} ]]; then
    echo "[$(date +%H:%M:%S.%3N)] Loading Manjaro dotfile configuration..."
fi


alias headphones="pactl -f json list sinks | jq '.[] | select (.name | contains(\"HyperX\")).index' | xargs pacmd set-default-sink"
alias speakers="pactl -f json list sinks | jq '.[] | select (.name | contains(\"Speaker\")).index' | xargs pacmd set-default-sink"