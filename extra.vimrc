
"call vundle#begin()
Plugin 'sirver/ultisnips'
"Plugin 'rudes/vim-java'
"https://github.com/Valloric/YouCompleteMe: Beaucoup de choses à installer...
"Plugin 'Valloric/YouCompleteMe'

" https://github.com/Shougo/deoplete.nvim
if has('nvim')
  Plugin 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plugin 'Shougo/deoplete.nvim'
  Plugin 'roxma/nvim-yarp'
  Plugin 'roxma/vim-hug-neovim-rpc'
endif
let g:deoplete#enable_at_startup = 1

" Java-completion
Plugin 'junegunn/vim-javacomplete2'

Plugin 'w0rp-ale'

Plugin 'davidhalter/jedi-vim'

Plugin 'leafgarland/typescript-vim'
Plugin 'akz92/vim-ionic2'
Plugin 'mattn/emmet-vim'

Plugin 'drmikehenry/vim-fontsize'

Plugin 'Shougo/unite.vim'

Plugin 'Shougo/vimfiler.vim'

"Plugin 'ctrlpvim/ctrlp.vim'

Plugin 'mdempsky/gocode', {'rtp': 'vim/'}

Plugin 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plugin 'junegunn/fzf.vim'

Plugin 'francoiscabrol/ranger.vim'

"call vundle#end()
"Pour redémarrer: vim +BundleInstall +qall
