let s:asciiart = [
      \"        :::      ::::::::",
      \"      :+:      :+:    :+:",
      \"    +:+ +:+         +:+  ",
      \"  +#+  +:+       +#+     ",
      \"+#+#+#+#+#+   +#+        ",
      \"     #+#    #+#          ",
      \"    ###   ########.fr    "
      \]

let s:start  = '/*'
let s:end    = '*/'
let s:fill   = '*'
let s:length = 80
let s:margin = 5

function! s:ascii(n)
  return s:asciiart[a:n - 3]
endfunction

function! s:textline(left, right)
  let l:left = strpart(a:left, 0, s:length - s:margin * 2 - strlen(a:right))

  let l:spaces = s:length - s:margin * 2 - strlen(l:left) - strlen(a:right)
  if l:spaces < 0
    let l:spaces = 0
  endif

  return s:start
        \ . repeat(' ', s:margin - strlen(s:start))
        \ . l:left
        \ . repeat(' ', l:spaces)
        \ . a:right
        \ . repeat(' ', s:margin - strlen(s:end))
        \ . s:end
endfunction

function! s:line(n)
  if a:n == 1 || a:n == 11 " top and bottom line
    return s:start . ' ' . repeat(s:fill, s:length - strlen(s:start) - strlen(s:end) - 2) . ' ' . s:end
  elseif a:n == 2 || a:n == 10 " blank line
    return s:textline('', '')
  elseif a:n == 3 || a:n == 5 || a:n == 7 " empty with ascii
    return s:textline('', s:ascii(a:n))
  elseif a:n == 4 " filename
    return s:textline(s:filename(), s:ascii(a:n))
  elseif a:n == 6 " author
    return s:textline("By: " . s:user() . " <" . s:mail() . ">", s:ascii(a:n))
  elseif a:n == 8 " created
    return s:textline("Created: " . s:date() . " by " . s:user(), s:ascii(a:n))
  elseif a:n == 9 " updated
    return s:textline("Updated: " . s:date() . " by " . s:user(), s:ascii(a:n))
  endif
endfunction

function! s:user()
  if exists('g:user42')
    return g:user42
  endif
  let l:user = $USER
  if strlen(l:user) == 0
    let l:user = "marvin"
  endif
  return l:user
endfunction

function! s:mail()
  if exists('g:mail42')
    return g:mail42
  endif
  let l:mail = $MAIL
  if strlen(l:mail) == 0
    let l:mail = "marvin@42.fr"
  endif
  return l:mail
endfunction

function! s:filename()
  let l:filename = expand("%:t")
  if strlen(l:filename) == 0
    let l:filename = "< new >"
  endif
  return l:filename
endfunction

function! s:date()
  return strftime("%Y/%m/%d %H:%M:%S")
endfunction

function! s:insert()
  let l:line = 11

  " empty line after header
  call append(0, "")

  " loop over lines
  while l:line > 0
    call append(0, s:line(l:line))
    let l:line = l:line - 1
  endwhile
endfunction

function! s:update()
  if getline(9) =~ s:start . repeat(' ', s:margin - strlen(s:start)) . "Updated: "
    if &mod
      if s:not_rebasing()
        call setline(9, s:line(9))
      endif
    endif
    if s:not_rebasing()
      call setline(4, s:line(4))
    endif
    return 0
  endif
  return 1
endfunction

function! s:stdheader()
  if s:update()
    call s:insert()
  endif
endfunction

function! s:fix_merge_conflict()
  " If lastplace has a real position to restore, don't touch the buffer on read.
  " This avoids breaking cursor restore.
  if line("'\"") > 1
    return
  endif

  " Preserve cursor/scroll/folds even if we edit header lines.
  let l:view = winsaveview()

  let l:checkline = s:start . repeat(' ', s:margin - strlen(s:start)) . "Updated: "

  " fix conflict on 'Updated:' line
  if getline(9) =~ "<<<<<<<" && getline(11) =~ "=======" && getline(13) =~ ">>>>>>>" && getline(10) =~ l:checkline
    let l:line = 9
    while l:line < 12
      call setline(l:line, s:line(l:line))
      let l:line = l:line + 1
    endwhile
    echo "42header conflicts automatically resolved!"
    exe ":12,15d"

  " fix conflict on both 'Created:' and 'Updated:' (unlikely, but useful in case)
  elseif getline(8) =~ "<<<<<<<" && getline(11) =~ "=======" && getline(14) =~ ">>>>>>>" && getline(10) =~ l:checkline
    let l:line = 8
    while l:line < 12
      call setline(l:line, s:line(l:line))
      let l:line = l:line + 1
    endwhile
    echo "42header conflicts automatically resolved!"
    exe ":12,16d"
  endif

  call winrestview(l:view)
endfunction

function! s:not_rebasing()
  if system("ls `git rev-parse --git-dir 2>/dev/null` | grep rebase | wc -l")
    return 0
  endif
  return 1
endfunction

" Bind command and shortcut (C only)
command! Stdheader call s:stdheader()
autocmd FileType c nnoremap <buffer> <F1> :Stdheader<CR>

augroup stdheader
  autocmd!
  autocmd BufWritePre *.c,*.h call s:update()
  autocmd BufReadPost *.c,*.h call s:fix_merge_conflict()
augroup END

function! s:force_lastplace() abort
  " ignore buffers spéciaux
  if &buftype !=# '' | return | endif
  if &filetype ==# '' | return | endif

  " si un mark valide existe
  if line("'\"") <= 1 || line("'\"") > line('$')
    return
  endif

  " exécuter après le reste (plugins, ftplugin, folds, etc.)
  call timer_start(80, {-> execute('silent! normal! g`"zz')})
endfunction

augroup force_lastplace
  autocmd!
  autocmd BufWinEnter *.c,*.h call s:force_lastplace()
augroup END
