#
# ~/.bashrc
#

# Bashrc config loader
source ~/.config/config_bashrc

# Export
 Sample# export PATH=$PATH:$HOME/bin
# export PATH=$PATH:$HOME/sbin

# Add excaping's interpretation by backslash by defautl
shopt -s xpg_echo

# Alias for diferent script
alias sfr='setxkbmap fr'
alias sus='setxkbmap us'

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
