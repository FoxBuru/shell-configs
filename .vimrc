source $HOME/.vim/settings/init-vundle.vimrc

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

source $HOME/.vim/settings/plugins.vimrc
source $HOME/.vim/settings/colorschemes.vimrc
source $HOME/.vim/settings/pre-vundle.vimrc

" At this line, no more plugins
call vundle#end()            " required
filetype plugin indent on    " required

source $HOME/.vim/settings/post-vundle.vimrc
