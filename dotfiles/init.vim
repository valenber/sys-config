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


" KEY MAPPINGS
"-------------

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

