" As an evil-mode user, I don't have a heavily-customized vim setup.
"
" I do, however, want vim to behave roughly like my evil-mode setup.

" Use jk to return to normal mode.
inoremap jk <esc>

" Let's have syntax coloration.
syntax on

" I do not like tabs, personally.
set tabstop=4
set shiftwidth=4
set expandtab

" Strip trailing whitespace on save.
fun! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfun

autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()

" Leader mappings.
let mapleader=" "

noremap <Leader>w :w<CR>
