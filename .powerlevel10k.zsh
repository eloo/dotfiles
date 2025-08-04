
if [[ ${DEBUG_ZSH} ]]; then
    echo "[$(date +%H:%M:%S.%3N)] Loading powerlevel10k dotfile configuration..."
fi

# Additional powerlevel10k configuration
typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(status os_icon context dir dir_writable vcs)
typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(command_execution_time time)
typeset -g POWERLEVEL9K_SHORTEN_DIR_LENGTH=2
typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=2
typeset -g POWERLEVEL9K_DIR_MAX_LENGTH=20
typeset -g POWERLEVEL9K_TRANSIENT_PROMPT=false
typeset -g POWERLEVEL9K_MODE='awesome-patched'
typeset -g POWERLEVEL9K_STATUS_OK=false
typeset -g POWERLEVEL9K_STATUS_VERBOSE=false
typeset -g POWERLEVEL9K_STATUS_ERROR_FOREGROUND='red'
typeset -g POWERLEVEL9K_OS_ICON_BACKGROUND="white"
typeset -g POWERLEVEL9K_OS_ICON_FOREGROUND="black"

# typeset -g POWERLEVEL9K_MODE='nerdfont-complete'

# typeset -g POWERLEVEL9K_VCS_BRANCH_ICON='\uF126 '

# typeset -g POWERLEVEL9K_SHORTEN_STRATEGY="truncate_left"

# typeset -g POWERLEVEL9K_VCS_STAGED_ICON='\u00b1'
# typeset -g POWERLEVEL9K_VCS_UNTRACKED_ICON='\u25CF'
# typeset -g POWERLEVEL9K_VCS_UNSTAGED_ICON='\u00b1'
# typeset -g POWERLEVEL9K_VCS_INCOMING_CHANGES_ICON='\u2193'
# typeset -g POWERLEVEL9K_VCS_OUTGOING_CHANGES_ICON='\u2191'
# typeset -g POWERLEVEL9K_VCS_MODIFIED_BACKGROUND='yellow'
# typeset -g POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND='cyan'

# typeset -g POWERLEVEL9K_TIME_FORMAT="%D{%H:%M}"