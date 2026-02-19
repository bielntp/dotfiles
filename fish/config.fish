set -g fish_greeting ""

set SPACEFISH_PROMPT_ADD_NEWLINE false
set -Ux XDG_CONFIG_HOME $HOME/.config
set -Ux MATUGEN_OUTPUT_DIR $HOME/.config/matugen

starship init fish | source

alias cat='bat --theme=(if test (defaults read -globalDomain AppleInterfaceStyle ^/dev/null); echo default; else; echo GitHub; end)'
alias l="ls -la"
alias ls="eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions"
alias cd="z"

fzf --fish | source
zoxide init fish | source

export FZF_CTRL_T_OPTS="
--style full
--walker-skip .git,node_modules,target
--preview 'bat -n --color=always {}'
--bind 'ctrl-/:change-preview-window(down|hidden)'
"
