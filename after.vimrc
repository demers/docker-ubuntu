"https://github.com/zaiste/vimified
"curl -L https://raw.github.com/zaiste/vimified/master/install.sh | sh
colorscheme default

noremap <Up> <Up>
noremap <Down> <Down>
noremap <Left> <Left>
noremap <Right> <Right>

inoremap <Up> <Up>
inoremap <Down> <Down>
inoremap <Left> <Left>
inoremap <Right> <Right>

set foldmethod=indent
set foldlevel=20
"vsplit

noremap <C-w>e :SyntasticCheck<CR>
noremap <C-w>f :SyntasticToggleMode<CR>
noremap <F8> :SyntasticToggleMode<CR>
let g:syntastic_check_on_wq = 0
let g:syntastic_check_on_open = 0
let g:syntastic_mode_map = {'mode':'passive'}


"vnoremap <expr> // 'y/\V'.escape(@",'\').'<CR>'
vnoremap // y/\V<C-R>"<CR>

" Pour la gestion du ^M dans les fichiers Windows
noremap <C-A-d> :%s/<C-V><C-M>//g<CR>gg
noremap <C-d> :ed++ff=dos<CR>
noremap <C-u> :ed++ff=unix<CR>
noremap <C-u> :ed++ff=unix<CR>

"noremap ,b :EasyBuffer<CR>
nmap <leader>b :EasyBuffer

"noremap ,<M-t> :!ctags -R .<CR>

"set tags=tags;/
"set tags+=mestags.tags;
set tags=~/mytags

let g:ycm_server_keep_logfiles = 1

:let g:vimfiler_as_default_explorer = 1

nmap <S-tab> :VimFilerExplorer<cr>

" Pour Java
" https://averywagar.com/posts/2018/01/configuring-vim-for-java-development/"
autocmd FileType java setlocal omnifunc=javacomplete#Complete
"autocmd FileType java JCEnable

" Shorten error/warning flags
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
" I have some custom icons for errors and warnings but feel free to change them.
let g:ale_sign_error = '✘✘'
let g:ale_sign_warning = '⚠⚠'

" Disable or enable loclist at the bottom of vim
" Comes down to personal preferance.
let g:ale_open_list = 0
let g:ale_loclist = 0


" Setup compilers for languages

let g:ale_linters = {
      \  'cs':['syntax', 'semantic', 'issues'],
      \  'python': ['pylint'],
      \  'java': ['javac']
      \ }


