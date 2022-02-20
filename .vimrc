set background=dark
syntax on
set nocompatible
set nowrap
filetype plugin on

set switchbuf=usetab,newtab
set tabstop=4
set smartindent
set expandtab
set shiftwidth=4
set foldenable  
set foldmethod=indent
set nu
set laststatus=2

set t_Co=256

setlocal spell spelllang=en_us,ru_ru
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'

Plugin 'preservim/nerdtree'
Plugin 'itchyny/lightline.vim'
Plugin 'junegunn/fzf.vim'
Plugin 'vim-syntastic/syntastic'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-surround'
Plugin 'airblade/vim-gitgutter'
Plugin 'scrooloose/nerdcommenter'
Plugin 'majutsushi/tagbar'
Plugin 'w0rp/ale'
Plugin 'pangloss/vim-javascript'
Plugin 'mxw/vim-jsx'
Plugin 'leafgarland/typescript-vim'
Plugin 'elzr/vim-json'
Plugin 'nvie/vim-flake8'
Plugin 'rust-lang/rust.vim'
Plugin 'ryanoasis/vim-devicons'
Plugin 'frazrepo/vim-rainbow'
Bundle 'sonph/onehalf', {'rtp': 'vim/'}
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
call vundle#end()

filetype plugin indent on

colorscheme onehalfdark
let g:airline_theme='onehalfdark'
let g:airline_powerline_fonts = 1
let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#tabline#formatter = 'default'

let g:airline#extensions#tabline#enabled = 1
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


