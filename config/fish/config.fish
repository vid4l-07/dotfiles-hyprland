if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Aliases
alias ll='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias v='nvim'
alias cat='bat'

bind ctrl-k history-token-search-backward
bind ctrl-j history-token-search-forward
bind alt-k up-or-search
bind alt-j down-or-search

#prompt de bienvenida
# set colores (bash $HOME/.config/bin/ver-colores.sh)
# set -g fish_greeting "$colores"
set -g fish_greeting ""

#colores
set -U fish_color_error red

#funciones
function settarget
	echo $argv > $HOME/.config/waybar/scripts/target.txt
end
