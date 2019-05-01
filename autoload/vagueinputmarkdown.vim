scriptencoding utf-8

if exists('g:loaded_vague_input_markdown')
    finish
endif
let g:loaded_vague_input_markdown = 1

let s:save_cpo = &cpo
set cpo&vim

" jump to next / previous header
function! vagueinputmarkdown#Jump(is_forward, is_visual)
    let cnt = v:count1
    let save = @/
    let pattern = '\v^#{1,6}\s'
    if a:is_visual
        normal! gv
    endif
    if a:is_forward
        let motion = '/' . pattern
    else
        let motion = '?' . pattern
    endif
    while cnt > 0
        silent! execute motion
        let cnt = cnt - 1
    endwhile
    call histdel('/', -1)
    let @/ = save
endfunction

" is this line header?
function! s:isHeader()
    return getline('.') =~ '\v^#{1,6}\s'
endfunction

" increase level of header
function! s:incHeader()
    let l = getline('.')
    if l !~ '\v^#{6}\s'
        call setline('.', '#'. l)
    endif
    normal $
endfunction

" decrease level of header
function! s:decHeader()
    let l = getline('.')
    if l =~ '\v^#\s'
        call setline('.', l[2:])
    else
        call setline('.', l[1:])
    endif
    normal $
endfunction

" is this line item of list?
function! s:isItem(is_blank)
    if a:is_blank
        let pattern = '\v^\s*%([-*+]|\d+\.)\s*$'
    else
        let pattern = '\v^\s*%([-*+]|\d+\.)\s*'
    endif
    return getline('.') =~ pattern
endfunction

" increase indent of item
function! s:incItem()
    normal >>
    normal $
endfunction

" decrease indent of item
function! s:decItem()
    let l = getline('.')
    if l =~ '\v^%([-*+]|\d+\.)\s*'
        call setline('.', substitute(l, '\v^%([-*+]|\d+\.)\s*', '', 'e'))
    else
        normal <<
    endif
    normal $
endfunction

"" assign function to CR/TAB/S-TAB for Markdown
function! vagueinputmarkdown#Configure()
    nnoremap <silent> [[
        \ :<C-u>call vagueinputmarkdown#Jump(0, 0)<CR>
    nnoremap <silent> ]]
        \ :<C-u>call vagueinputmarkdown#Jump(1, 0)<CR>
    xnoremap <silent> [[
        \ :<C-u>call vagueinputmarkdown#Jump(0, 1)<CR>
    xnoremap <silent> ]]
        \ :<C-u>call vagueinputmarkdown#Jump(1, 1)<CR>
    inoremap <silent><expr> <CR>
        \ <SID>isItem(1) ?
        \ '<C-O>:<C-u>call <SID>decItem()<CR>' :
        \ "\<CR>"
    inoremap <silent><expr> <TAB>
        \ <SID>isItem(0) ?
        \ '<C-O>:<C-u>call <SID>incItem()<CR>' :
        \ <SID>isHeader() ?
        \ '<C-O>:<C-u>call <SID>incHeader()<CR>' :
        \ "\<TAB>"
    inoremap <silent><expr> <S-TAB>
        \ <SID>isItem(0) ?
        \ '<C-O>:<C-u>call <SID>decItem()<CR>' :
        \ <SID>isHeader() ?
        \ '<C-O>:<C-u>call <SID>decHeader()<CR>' :
        \ "\<C-h>"
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
