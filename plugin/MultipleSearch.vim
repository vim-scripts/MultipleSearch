" File:		MultipleSearch.vim (global plugin)
" Last Changed: 2002 Nov 11
" Maintainer:	Dan Sharp <dwsharp at hotmail dot com>
" Version:	1.0

" MultipleSearch allows you to have the results of multiple searches displayed
" on the screen at the same time.  Each search highlights its results in a
" different color, and up to eight different searches can be displayed at once.
" After the maximum number of colors is used, the script starts over with the
" first color.
" 
" The command syntax is: 
" :Search <pattern1> 
" which will highlight all occurrences of <pattern1> in the current buffer.  A
" subsequent :Search <pattern2> will highlight all occurrences of <pattern2>
" in the current buffer, retaining the highlighting of <pattern1> as well.
" 
" To clear the highlighting, issue the command
" :SearchReset
" 
" You can specify the maximum number of different colors to use by setting the
" g:MultipleSearchMaxColors variable in your .vimrc.  The default setting is
" three, but the script can handle up to eight.

" If the user has not specified a maximum number of colors to use, 
" default to three.
if !exists('g:SearchMaxColors')
    let g:MultipleSearchMaxColors = 3
endif

" Start off with the first color
let s:colorToUse = 0

" Define the eight colors to use
hi Search0 ctermbg=red guibg=red ctermfg=white guifg=white
hi Search1 ctermbg=yellow guibg=yellow ctermfg=black guifg=black
hi Search2 ctermbg=blue guibg=blue ctermfg=white guifg=white
hi Search3 ctermbg=green guibg=green ctermfg=black guifg=black
hi Search4 ctermbg=magenta guibg=magenta ctermfg=white guifg=white
hi Search5 ctermbg=cyan guibg=cyan ctermfg=black guifg=black
hi Search6 ctermbg=gray guibg=gray ctermfg=black guifg=black
hi Search7 ctermbg=brown guibg=brown ctermfg=white guifg=white

" -----
" Determine the next Search color to use.
" -----
function! s:GetNextSequenceNumber()
    " Use mod 8 to make sure we work okay on 8-color terminals.
    let sequenceNumber = s:colorToUse % 8

    let s:colorToUse = s:colorToUse + 1
    if s:colorToUse >= g:MultipleSearchMaxColors
        let s:colorToUse = 0
    endif

    return sequenceNumber
endfunction

" -----
" Highlight the given pattern in the next available color.
" -----
function! MultipleSearch(forwhat)
    " Determine which search color to use.
    let s:useSearch = "Search" . s:GetNextSequenceNumber()
    
    " Clear the previous highlighting for this color
    execute 'silent syn clear ' . s:useSearch

    " Highlight the new search
    execute 'syn match ' . s:useSearch . ' "' . a:forwhat . '" containedin=ALL'
endfunction

" -----
" Clear all the current search colors.
" -----
function! s:MultipleSearchReset()
    let s:colorToUse = 0
    let seq = 0
    while seq < g:MultipleSearchMaxColors
        execute 'silent syn clear Search' . seq
        let seq = seq + 1
    endwhile
endfunction

command! -n=0 SearchReset :call <SID>MultipleSearchReset() 

if exists('g:autoload') | finish | endif " used by the autoload generator

command! -n=1 Search :call MultipleSearch(<q-args>)
