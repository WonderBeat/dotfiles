colorscheme adrian
set background=dark
syntax on
set nocompatible
set nowrap
filetype on
filetype plugin on

set switchbuf=usetab,newtab
set tabstop=4
set smartindent
set expandtab
set shiftwidth=4
set foldenable  
set foldmethod=indent
" numeration
set nu
set laststatus=2


" 256 цыетов
set t_Co=256

" Сделать строку команд высотой в одну строку
 set ch=1
"
" " Скрывать указатель мыши, когда печатаем
 set mousehide

setlocal spell spelllang=en_us,ru_ru

"NeoBundle Scripts-----------------------------
if has('vim_starting')
  if &compatible
    set nocompatible               " Be iMproved
  endif

  " Required:
  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

" Required:
call neobundle#begin(expand('~/.vim/bundle'))

" Let NeoBundle manage NeoBundle
" Required:
NeoBundleFetch 'Shougo/neobundle.vim'

" Add or remove your Bundles here:
NeoBundle 'Shougo/neosnippet.vim'
NeoBundle 'Shougo/neosnippet-snippets'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'jiangmiao/auto-pairs'
NeoBundle 'ctrlpvim/ctrlp.vim'
NeoBundle 'flazz/vim-colorschemes'
NeoBundle 'bling/vim-airline'
NeoBundle 'nathanaelkane/vim-indent-guides'
NeoBundle 'rust-lang/rust.vim'
NeoBundle 'eagletmt/neco-ghc'
NeoBundle 'racer-rust/vim-racer'
NeoBundle 'scrooloose/nerdtree'
NeoBundle 'Xuyuanp/nerdtree-git-plugin'
NeoBundle 'easymotion/vim-easymotion'
NeoBundle 'ctrlpvim/ctrlp.vim'
NeoBundle 'scrooloose/syntastic'
NeoBundle 'Shougo/vimshell', { 'rev' : '3787e5' }

" Required:
call neobundle#end()

" Required:
filetype plugin indent on

" If there are uninstalled bundles found on startup,
" this will conveniently prompt you to install them.
NeoBundleCheck
"End NeoBundle Scripts-------------------------
let g:haskellmode_completion_ghc = 0
autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc
" NerdTree close
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Enable the list of buffers
let g:airline#extensions#tabline#enabled = 1
" " Show just the filename
let g:airline#extensions#tabline#fnamemod = ':t'

let g:indent_guides_enable_on_vim_startup = 1
let g:necoghc_enable_detailed_browse = 1
let g:EasyMotion_do_mapping = 0
let g:EasyMotion_smartcase = 1

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0


nnoremap <C-t> :NERDTreeToggle<CR>
map <C-f> <Plug>(easymotion-bd-w)
nnoremap <C-o> :CtrlP .<CR>
nnoremap <C-e> :CtrlPMRU<CR>
nnoremap <S-e> :CtrlPBuffer<CR>
nnoremap <C-k> :bprevious<CR>
nnoremap <C-j> :bnext<CR>
nnoremap <S-t> :newbuf<CR>

"noremap <silent><expr> <Space>/ incsearch#go(<SID>config_easyfuzzymotion())

" If the current buffer has never been saved, it will have no name,
" call the file browser to save it, otherwise just save it.
command -nargs=0 -bar Update if &modified 
                           \|    if empty(bufname('%'))
                           \|        browse confirm write
                           \|    else
                           \|        confirm write
                           \|    endif
                           \|endif
nnoremap <silent> <C-S> :<C-u>Update<CR>


