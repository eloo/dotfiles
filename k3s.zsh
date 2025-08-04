
if [[ ${DEBUG_ZSH} ]]; then
    echo "[$(date +%H:%M:%S)] Loading k3s dotfile configuration..."
fi

### K3s
alias k3s-logs="sudo journalctl -xeu k3s"
