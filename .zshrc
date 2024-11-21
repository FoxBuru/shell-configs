export EDITOR=vim
export VISUAL=vim
export GOPATH=~/.go
export GOROOT=${HOME}/.local/share/golang
export PHPENV_VERSION=7.3.24
export RUSTUP_HOME=${HOME}/.rust/rustup
export CARGO_HOME=${HOME}/.rust/cargo
# export PATH=${PATH}:~/.composer/vendor/bin
export PATH="/opt/homebrew/opt/gnu-getopt/bin:$PATH"
export PATH=${PATH}:~/.go/bin
export PATH=${PATH}:~/.local/bin
export PATH=${PATH}:${HOME}/.rust/cargo/bin
# Set default chrome instance to Edge
export CHROME_EXECUTABLE=/opt/microsoft/msedge-dev/msedge
export KUBECONFIG=$HOME/.kube/config

# Sanity Settings
# export LC_ALL=es_MX.UTF-8
# export LANG=es_MX.UTF-8

# Platform sanity (for readurl annexes)
ANNEX_PLATFORM=darwin
ANNEX_ARCH=arm64

# ZSH Facts
HISTFILE=${HOME}/.zsh_history
HISTSIZE=20000
SAVEHIST=${HISTSIZE}
COMPLETION_WAITING_DOTS=true
setopt extended_history
setopt hist_expire_dups_first
setopt inc_append_history

# Autocomplete stylings
zstyle ':autocomplete:*' min-input 1

# custom fixes
source ${HOME}/.shell-cfg/fixes.sh
# Extra utils (like conda)
source ${HOME}/.shell-cfg/utils.sh

# Python & gcloud
#
# Use python from conda base
export VIRTUALENVWRAPPER_PYTHON=$(conda run command -v python)
export WORKON_HOME=${HOME}/.virtualenvs
export CLOUDSDK_PYTHON=${VIRTUALENVWRAPPER_PYTHON}
export PATH=${PATH}:${HOME}/.local/share/google-cloud-sdk/bin

# Helper functs
function __setup_keys() {
	key[Up]="${terminfo[kcuu1]}"
	key[Down]="${terminfo[kcud1]}"
}

function __bind_autocomplete_keys() {
	bindkey $key[Up] up-line-or-search
	bindkey $key[Down] down-line-or-select
	bindkey $key[Control-Space] list-expand
	bindkey -M menuselect $key[Return] .accept-line
}

# Fact-checking...
[[ ! -f ${HOME}/.shell-cfg/zbin/zinit.zsh ]] && {
	command mkdir -p ${HOME}/.shell-cfg
	command git clone --depth=1 https://github.com/zdharma-continuum/zinit ${HOME}/.shell-cfg/zbin
}

[[ ! -x $(command -v rustup) ]] && {
	curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf | sh
}

# Vim fact-checking
[[ ! -f ${HOME}/.vim/bundle/Vundle.vim/autoload/vundle.vim ]] && {
	command mkdir -p ${HOME}/.vim/bundle
	command git clone --depth=1 https://github.com/VundleVim/Vundle.vim.git ${HOME}/.vim/bundle/Vundle.vim
}

source ~/.shell-cfg/zbin/zinit.zsh
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

eval "$(/opt/homebrew/bin/brew shellenv)"

# Sourcing gpg-agent for WSL
source ${HOME}/.shell-cfg/gpg-detect.sh

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-readurl \
    zdharma-continuum/zinit-annex-bin-gem-node

setopt promptsubst

zinit wait lucid for \
	OMZL::git.zsh \
	OMZL::theme-and-appearance.zsh \
    atload"unalias grv; unalias g" \
	OMZP::git \
	zpm-zsh/colors

# PS1 as simple as possible until plugins load...
PS1="bzsh ready >"

# autocompleters
zinit wait lucid light-mode for \
    atload"zicompinit; zicdreplay" \
	zdharma-continuum/fast-syntax-highlighting \
	marlonrichert/zsh-autocomplete

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

# Fonts installing	
zinit wait lucid for \
    atclone"mv *.ttf ${HOME}/.fonts/.; fc-cache" \
    atpull'%atclone' from"gh-r" bpick"*FantasqueSansMono*" nocompile \
        ryanoasis/nerd-fonts

# Binary helper for zsh-fast-alias-tips from sei40kr
zinit wait lucid for \
    from'gh-r' as'program' \
        sei40kr/fast-alias-tips-bin

# Some goot utils!
zinit wait lucid for \
    as'program' atclone"rm -fr target; cargo build --release" \
    pick'target/release/rg' \
        BurntSushi/ripgrep \
    as'program' atclone"rm -fr target; cargo build --release" \
    pick"target/release/bat" \
        @sharkdp/bat \
    as'program' pick"yank" make \
        mptre/yank \
    from'gh-r' as'program' bpick'*pass*' \
    pick"docker-credential-pass" \
	docker/docker-credential-helpers \
    from'gh-r' as'program' \
    bpick'terraform-docs-*' \
    mv"terraform-docs* -> terraform-docs" \
    	terraform-docs/terraform-docs \
    from'gh-r' as'program' \
    pick"tflint" \
    	terraform-linters/tflint \
    from'gh-r' as'program' \
        thehowl/claws \
    from'gh-r' as'program' bpick'kubens*' bpick'kubectx*' \
    pick"kubens" pick"kubectx" \
    	ahmetb/kubectx \
    from'gh-r' as'program' \
    pick"duf" \
    	muesli/duf \
    as'program' atclone"rm -fr target; cargo build --release" \
    pick'target/release/dutree' ver'v0.2.18' \
	nachoparker/dutree \
    from'gh-r' as'program' \
    mv'hadolint* -> hadolint' \
    	hadolint/hadolint \
    as'program' make pick"make2graph" \
    	lindenb/makefile2graph

# Pt. 2
zinit wait lucid for \
    from'gh-r' as'program' \
    pick"hugo" \
    	gohugoio/hugo \
    from'gh-r' as'program' \
    mv'gojq* -> gojq' \
    pick"gojq/gojq" \
        itchyny/gojq \
    from'gh-r' as'program' \
    mv'yq* -> yq' \
    	mikefarah/yq \
    from'gh-r' as'program' \
    pick"kubeval" \
        instrumenta/kubeval \
    from'gh-r' as'program' \
    pick"gocloc" \
    	hhatto/gocloc \
    from'gh-r' as'program' \
    pick"scc" \
        boyter/scc \
    from'gh-r' as'program' \
    pick"dgraph" pick"badger" \
    	dgraph-io/dgraph \
    from'gh-r' as'program' \
    pick"scorecard" \
    	ossf/scorecard \
    from'github' as'command' \
    pick"bin/g" \
    	stefanmaric/g

# Pt. 3
zinit wait lucid for \
    from'gh-r' as'program' \
    atload'eval "$(direnv hook zsh)"' \
    	direnv/direnv \
    from'gh-r' as'program' \
    pick"pulumi/pulumi" \
	pulumi/pulumi \
    from'github' as'command' \
    pick'bin/*' \
	tfutils/tfenv \
    from'gh-r' as'program' \
	@protocolbuffers/protobuf \
    from'gh-r' as'program' \
    bpick'buf-*' \
    bpick'protoc-gen-buf-breaking-*' \
    bpick'protoc-gen-buf-lint-*' \
    atclone"mv buf-* buf; mv protoc-gen-buf-breaking-* protoc-gen-buf-breaking; mv protoc-gen-buf-lint-* protoc-gen-buf-lint" \
	bufbuild/buf \
    from'gh-r' as'program' \
    pick"viceroy" \
	fastly/Viceroy \
    from'gh-r' as'program' \
	buildpacks/pack \
    from'gh-r' as'program' \
    mv'earthly* -> earthly' \
        earthly/earthly \
    from'gh-r' as'program' \
	fullstorydev/grpcurl \
    from'gh-r' as'program' \
        ddosify/ddosify

# Pt. 4
zinit wait lucid for \
    from'gh-r' as'program' \
    mv'rover* -> rover' \
	@im2nguyen/rover \
    from'gh-r' as'program' \
    mv'pluralith* -> pluralith' \
	@Pluralith/pluralith-cli \
    from'gh-r' as'program' \
    ver"jq-1.7" \
    mv'jq* -> jq' \
	jqlang/jq \
    from'gh-r' as'program' \
    mv'shfmt* -> shfmt' \
        @mvdan/sh

# Zinit external utils
# to be used with readurl annex
# zinit id-as=terraform as="readurl|command" extract \
#     dlink0='/terraform/%VERSION%/~%.*(alpha).*%' \
#     dlink="/terraform/%VERSION%/terraform_%VERSION%_${ANNEX_PLATFORM}_${ANNEX_ARCH}.zip" \
#     	for https://releases.hashicorp.com/terraform/

zinit id-as'vault' as'readurl|command' extract \
    dlink0'/vault/%VERSION%/~%.*(alpha|beta|\+ent).*%' \
    dlink".*/vault/%VERSION%/vault_%VERSION%_${ANNEX_PLATFORM}_${ANNEX_ARCH}.zip" \
    	for https://releases.hashicorp.com/vault/

zinit id-as'ngrok' as'readurl|command' extract \
    dlink"https://bin.equinox.io/.*/.*/ngrok-%VERSION%-${ANNEX_PLATFORM}-${ANNEX_ARCH}.tar.gz" \
    	for https://dl.equinox.io/ngrok/ngrok/stable/archive

# Pantheon utils!
zinit wait lucid for \
    as"program" atclone"rm -fv pants; go build -o pants" \
    atpull"%atclone" pick"pants" \
        pantheon-systems/pants \
    as'program' atclone"rm -fv pvault; go build -o pvault" \
    atpull"%atclone" pick"pvault" \
    	pantheon-systems/pvault \
    from'gh-r' as'program' \
    mv"vault-token-helper* -> vault-token-helper" \
    	joemiller/vault-token-helper

# AppImages
zinit wait lucid for \
    from'gh-r' as'program' \
    bpick"*AppImage" \
    mv"superProductivity* -> super-productivity" \
    ver"v7.3.3" \
    pick"super-productivity" \
    	johannesjo/super-productivity

# Aliasing
# alias helm3='microk8s.helm3'
# Docker alias won't work for makefiles/taskfiles
# which do command -v detection
# alias docker='nerdctl.lima'

# Loading plugins!
zinit wait lucid for \
	OMZP::command-not-found \
	sei40kr/zsh-fast-alias-tips \
	OMZP::rbenv \
	lukechilds/zsh-nvm \
	sptndc/phpenv.plugin.zsh \
	zpm-zsh/autoenv \
	OMZP::colored-man-pages \
    atload"!_zsh_autosuggest_start" \
	zsh-users/zsh-autosuggestions \
    as"completion" \
	OMZP::golang \
	OMZP::ubuntu \
	OMZP::gcloud \
	OMZP::kubectl \
	OMZP::docker-compose

