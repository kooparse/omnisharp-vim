if !has('python')
  finish
endif

let s:save_cpo = &cpoptions
set cpoptions&vim

function! s:location_sink(str) abort
  for quickfix in s:quickfixes
    if quickfix.text == a:str
      break
    endif
  endfor
  echo quickfix.filename
  call OmniSharp#JumpToLocation(quickfix.filename, quickfix.lnum, quickfix.col)
endfunction

function! fzf#OmniSharp#findtypes() abort
  if !OmniSharp#ServerIsRunning()
    return
  endif
  let s:quickfixes = pyeval('findTypes()')
  let types = []
  for quickfix in s:quickfixes
    call add(types, quickfix.text)
  endfor
  call fzf#run({
  \ 'source': types,
  \ 'down': '40%',
  \ 'sink': function('s:location_sink')})
endfunction

function! fzf#OmniSharp#findsymbols(filter) abort
  if !OmniSharp#ServerIsRunning()
    return
  endif
  let s:quickfixes = pyeval(printf('findSymbols(%s)', string(a:filter)))
  let symbols = []
  for quickfix in s:quickfixes
    call add(symbols, quickfix.text)
  endfor
  if empty(symbols)
    echo 'No symbols found'
    return
  endif
  call fzf#run({
  \ 'source': symbols,
  \ 'down': '40%',
  \ 'sink': function('s:location_sink')})
endfunction

function! s:action_sink(str) abort
  if s:version ==# 'v1'
    let action = index(s:actions, a:str)
    let command = printf('runCodeAction(%s, %d)', string(s:mode), action)
  else
    let action = filter(copy(s:actions), {i,v -> get(v, 'Name') ==# a:str})[0]
    let command = substitute(get(action, 'Identifier'), '''', '\\''', 'g')
    let command = printf('runCodeAction(''%s'', ''%s'', ''v2'')', s:mode, command)
  endif
  if !pyeval(command)
    echo 'No action taken'
  endif
endfunction

function! fzf#OmniSharp#getcodeactions(mode) abort
  " When using the roslyn server, use /v2/codeactions
  let s:version = g:OmniSharp_server_type ==# 'roslyn' ? 'v2' : 'v1'
  let s:actions = pyeval(printf('getCodeActions(%s, %s)', string(a:mode), string(s:version)))
  let s:mode = a:mode
  if empty(s:actions)
    echo 'No code actions found'
    return
  endif
  if s:version ==# 'v1'
    let acts = s:actions
  else
    let acts = map(copy(s:actions), {i,v -> get(v, 'Name')})
  endif

  call fzf#run({
  \ 'source': acts,
  \ 'down': '10%',
  \ 'sink': function('s:action_sink')})
endfunction

let &cpoptions = s:save_cpo
unlet s:save_cpo

"
" vim:nofen:fdl=0:ts=2:sw=2:sts=2
