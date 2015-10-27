" Make it beautiful - colors and fonts

if has("gui_running")
  "tell the term has 256 colors
  set t_Co=256

  " Show tab number (useful for Cmd-1, Cmd-2.. mapping)
  " For some reason this doesn't work as a regular set command,
  " (the numbers don't show up) so I made it a VimEnter event
  autocmd VimEnter * set guitablabel=%N:\ %t\ %M

  set lines=60
  set columns=150

  if has("gui_gtk2")
    set guifont=Ubuntu\ Mono:h14
    "set guifont=Inconsolata\ XL\ 11,Inconsolata\ 11,Monaco\ 11
  else
    set guifont=Ubuntu\ Mono:h14
    "set guifont=Inconsolata\ XL:h11,Inconsolata:h11,Monaco:h11
  end
else
  let g:CSApprox_loaded = 1

  " For people using a terminal that is not Solarized
  if exists("g:yadr_using_unsolarized_terminal")
    let g:solarized_termcolors=256
    let g:solarized_termtrans=1
  end
endif

colorscheme peter
" colorscheme solarized
set background=dark
