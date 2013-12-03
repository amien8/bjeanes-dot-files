augroup bundles
  autocmd!

  if has('vim_starting')
    set nocompatible
    set runtimepath+=~/.vim/bundle/neobundle.vim/
  endif

  call neobundle#rc(expand('~/.vim/bundle/'))

  " Let NeoNeoBundle manage NeoBundle
  NeoBundleFetch 'Shougo/neobundle.vim'

  NeoBundle 'Shougo/vimproc', {
  \ 'build' : {
  \     'mac' : 'make -f make_mac.mak',
  \     'unix' : 'make -f make_unix.mak',
  \    },
  \ }

  NeoBundleLazy 'tpope/vim-endwise' " Auto-add 'end' etc appropriately in various languages

  " Languages/Syntaxes/Frameworks {{{
    " Ruby {{{
      NeoBundleLazy 'vim-ruby/vim-ruby'
      NeoBundleLazy 'tpope/vim-rails'
      NeoBundleLazy 'tpope/vim-rake'
      NeoBundleLazy 'tpope/vim-bundler'
      NeoBundleLazy 'thisivan/vim-ruby-matchit'
      NeoBundleLazy 'nelstrom/vim-textobj-rubyblock', { 'depends' : ['kana/vim-textobj-user', 'thisivan/vim-matchit'] }
      autocmd FileType ruby NeoBundleSource
      \ vim-ruby
      \ vim-rails  " <- how to maket his only load in rails projects?
      \ vim-bundler
      \ vim-rake
      \ vim-haml
      \ vim-ruby-matchit
      \ vim-textobj-rubyblock
    " }}}

    " Clojure {{{
      NeoBundleLazy 'paredit.vim'
      autocmd FileType clojure,clojurescript NeoBundleSource paredit.vim
      autocmd FileType clojure,clojurescript set lispwords-='->'
      autocmd FileType clojure,clojurescript set lispwords-='->>'


      NeoBundleLazy 'tpope/vim-classpath', { 'autoload' : { 'filetypes' : ['clojure', 'java'] } }

    " Markdown/Textile/etc {{{
      NeoBundleLazy 'tpope/vim-markdown'
      NeoBundleLazy 'matthias-guenther/hammer.vim'
      autocmd FileType markdown NeoBundleSource vim-markdown hammer.vim
    " }}}

    " HTML/CSS/Javascript {{{
      NeoBundleLazy 'tpope/vim-haml',           { 'autoload' : { 'filetypes' : 'haml' } }
      NeoBundleLazy 'kchmck/vim-coffee-script', { 'autoload' : { 'filetypes' : 'coffee' } }
      NeoBundleLazy 'pangloss/vim-javascript',  { 'autoload' : { 'filetypes' : 'javascript' } }
      NeoBundleLazy 'css3',                     { 'autoload' : { 'filetypes' : 'css' } }
      NeoBundleLazy 'othree/html5-syntax.vim',  { 'autoload' : { 'filetypes' : 'html' } }
      NeoBundleLazy 'slim-template/vim-slim',   { 'autoload' : { 'filetypes' : 'slim' } }
    " }}}

  " }}}

  " Git {{{
    NeoBundle 'tpope/vim-fugitive', { 'augroup': 'fugitive' }
    NeoBundle 'tpope/vim-git'
    NeoBundle 'tjennings/git-grep-vim'
  " }}}

  " Text objects {{{
    NeoBundle 'michaeljsmith/vim-indent-object'
    NeoBundle 'argtextobj.vim'
  " }}}

  " Utility {{{

    NeoBundle 'tpope/vim-surround', { 'depends' : 'tpope/vim-repeat' }

    NeoBundleLazy 'AutoComplPop', { 'autoload' : { 'insert' : 1 } }
    let g:acp_enableAtStartup        = 0
    let g:acp_completeoptPreview     = 1
    let g:acp_behaviorKeywordLength  = 3
    let g:acp_behaviorKeywordIgnores = [
      \ 'the', 'def', 'end',
      \ 'else', 'elsif', 'elif', 'endif', 'then',
      \ 'case', 'done', 'do'
      \ ]

    NeoBundle 'Lokaltog/vim-easymotion'
    let g:EasyMotion_keys = "arstdhneio" " Colemak home row

    NeoBundle 'Gundo'
    nnoremap <Leader>u :GundoToggle<CR>

    NeoBundle 'kien/rainbow_parentheses.vim'
    autocmd VimEnter *.{rb,coffee} RainbowParenthesesToggle
    autocmd Syntax   *.{rb,coffee} RainbowParenthesesLoadRound
    autocmd Syntax   *.{rb,coffee} RainbowParenthesesLoadSquare
    autocmd Syntax   *.{rb,coffee} RainbowParenthesesLoadBraces

    NeoBundle 'Tabular'
    autocmd VimEnter * AddTabularPattern! first_eq     /\%(=.*\)\@<!=[>=]\@!/l1c1l0
    autocmd VimEnter * AddTabularPattern! first_rocket /\%(=>.*\)\@<!=>/l1c1l0
    autocmd VimEnter * AddTabularPattern! first_key    /\v%(%(\h\w*|"[^"]+"):.*)@<!%(\h\w*|"[^"]+")\zs:/l0l1

    " mark, select indent level, tabularize, go to mark
    nmap <silent> <Leader>a= mT:Tabularize first_eq<CR>`T
    nmap <silent> <Leader>a> mT:Tabularize first_rocket<CR>`T
    nmap <silent> <Leader>a: mT:Tabularize first_key<CR>`T

    vmap <silent> <Leader>a= :Tabularize first_eq<CR>gv
    vmap <silent> <Leader>a> :Tabularize first_rocket<CR>gv
    vmap <silent> <Leader>a: :Tabularize first_key<CR>gv

    " Auto-align
    "" Cucumber
    inoremap <silent> <Bar> <Bar><Esc>:call <SID>align()<CR>a
    function! s:align()
      let p = '^\s*|\s.*\s|\s*$'
      if exists(':Tabularize') && getline('.') =~# '^\s*|' && (getline(line('.')-1) =~# p || getline(line('.')+1) =~# p)
        let column = strlen(substitute(getline('.')[0:col('.')],'[^|]','','g'))
        let position = strlen(matchstr(getline('.')[0:col('.')],'.*|\s*\zs.*'))
        Tabularize/|/l1
        normal! 0
        call search(repeat('[^|]*|',column).'\s\{-\}'.repeat('.',position),'ce',line('.'))
      endif
    endfunction

    NeoBundle 'tpope/vim-commentary'
    autocmd FileType clojure,clojurescript set commentstring=;\ %s
    nmap // <Plug>CommentaryLine
    vmap // <Plug>Commentary

    NeoBundle 'ZoomWin'
    map <Leader>z :ZoomWin<CR>
    imap <Leader>z <Esc>:ZoomWin<CR>a

    NeoBundle 'Indent-Guides'
    let g:indent_guides_auto_colors = 0
    let g:indent_guides_enable_on_vim_startup = 1
    autocmd VimEnter * IndentGuidesEnable
    autocmd FileType clojure,lisp IndentGuidesDisable
    NeoBundle 'kien/ctrlp.vim'
    NeoBundle 'Shougo/unite.vim'

    NeoBundle 'Syntastic'
    let g:syntastic_enable_signs       = 1
    let g:syntastic_auto_loc_list      = 0
    let g:syntastic_disabled_filetypes = ['cucumber']
  " }}}

  filetype plugin indent on

  NeoBundleCheck
augroup END
