export EDITOR=vim
export VIRTUALENVWRAPPER_PYTHON=$(which python3)
export WORKON_HOME=${HOME}/.virtualenvs
export GOPATH=~/.go
# export PATH=${PATH}:~/.composer/vendor/bin
# export PATH=${PATH}:~/.go/bin
export PATH=${PATH}:~/.local/bin
# export PATH=${PATH}:~/Library/Python/3.7/bin

# Sanity Settings
export LC_ALL=es_MX.UTF-8
export LANG=es_MX.UTF-8

# Fact-checking...
[[ ! -f ${HOME}/.shell-cfg/zbin/zinit.zsh ]] && {
	command mkdir -p ${HOME}/.shell-cfg
	command git clone --depth=1 https://github.com/zdharma/zinit ${HOME}/.shell-cfg/zbin
}

source ~/.shell-cfg/zbin/zinit.zsh
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

function __bind_history_keys() {
  bindkey "$terminfo[kcuu1]" history-substring-search-up
  bindkey "$terminfo[kcud1]" history-substring-search-down
}

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zinit-zsh/z-a-patch-dl \
    zinit-zsh/z-a-as-monitor \
    zinit-zsh/z-a-bin-gem-node

setopt promptsubst

zinit wait lucid for \
	OMZL::git.zsh \
	OMZL::theme-and-appearance.zsh \
    atload"unalias grv" \
	OMZP::git

# PS1 as simple as possible until plugins load...
PS1="bzsh ready >"

# Loading theme here...
zinit wait'!' lucid for \
	OMZL::prompt_info_functions.zsh

zinit wait'!' lucid for \
    atload'source ~/.shell-cfg/.p10k.zsh; _p9k_precmd' \
	romkatv/powerlevel10k

# Color loading
zinit wait lucid for \
    atclone"dircolors -b LS_COLORS > clrs.zsh" \
    atpull'%atclone' pick"clrs.zsh" nocompile'!' \
    atload'zstyle ":completion:*" list-colors "${(s.:.)LS_COLORS}"' \
	trapd00r/LS_COLORS

# Loading plugins!
zinit wait lucid for \
	OMZP::command-not-found \
	OMZP::gpg-agent \
	djui/alias-tips \
	OMZP::virtualenvwrapper \
	OMZP::golang \
	OMZP::ubuntu \
    atinit"zicompinit; zicdreplay" \
	zdharma/fast-syntax-highlighting \
	OMZP::colored-man-pages \
	marlonrichert/zsh-autocomplete \
    atload'__bind_history_keys' \
	zsh-users/zsh-history-substring-search \
    atload"_zsh_autosuggest_start" \
	zsh-users/zsh-autosuggestions
