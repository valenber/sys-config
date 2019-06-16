" Neovim configuration file
" this should be linked to ~/.config/nvim


" GENERAL EDITOR CONFIG
"----------------------

" basics
set nocompatible
filetype plugin on
syntax on
syntax enable
set number relativenumber
set encoding=utf8
set wrap
" autoindent
set ai
" tabulation
set tabstop=2 softtabstop=0 expandtab shiftwidth=2 smarttab

" tabcompletion for files
set wildmode=longest,list,full

" disable automatic comments on new line
set formatoptions-=cro

" splits configuration - :sp :vsp
set splitbelow splitright
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" PLUGINS
" -------
"
call plug#begin()

"syntax highlighting
Plug 'haishanh/night-owl.vim'
Plug 'digitaltoad/vim-pug'
Plug 'pangloss/vim-javascript'
Plug 'cakebaker/scss-syntax.vim'
Plug 'posva/vim-vue'
" autocompletion
Plug 'neoclide/coc.nvim', {'tag': '*', 'do': './install.sh'}
Plug 'honza/vim-snippets'
call plug#end()


" VISUALS
" -------

" enable true colors
if (has("termguicolors"))
 set termguicolors
endif

" set colours
colorscheme night-owl

" KEY MAPPINGS
"-------------

" replace all
nnoremap S :%s//g<Left><Left>

" Use <c-space> to trigger completion.
"inoremap <silent><expr> <c-space> coc#refresh()

" Use <Tab> to trigger completion.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? coc#_select_confirm() :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

let g:coc_snippet_next = '<tab>'

" Navigating buffers
nnoremap gb :ls<CR>:buffer<Space>
nnoremap <C-d> :bnext<CR>
nnoremap <C-s> :bprevious<CR>
" don't force me to save buffers when switching between them
set hidden

" escape key alternative
inoremap jk <ESC>

" INPUT HELPERS
" close curly bracket and indent inside
inoremap ,{ {}<Left><CR><CR><Up><Tab>
" arrow function
inoremap ,( = () => {}<Left><CR><CR><Up><Tab>
" async arrow function
inoremap ,a( = async () => {}<Left><CR><CR><Up><Tab>

