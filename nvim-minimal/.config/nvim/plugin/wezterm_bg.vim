" ---------------------------------------------------------------------
" wezterm_bg.vim
" Envia a cor de fundo do tema atual do Neovim para o WezTerm.
" Resolve a diferença de cor quando o padding do WezTerm fica visível.
" Usa base64 em Vimscript puro (funciona no Windows sem shell externo).
" ---------------------------------------------------------------------

" Codifica uma string em base64 (sem depender de printf/base64 externos)
function! s:Base64(texto) abort
  let l:chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
  let l:bytes = map(range(len(a:texto)), 'char2nr(a:texto[v:val])')
  let l:out = ''
  let l:i = 0
  while l:i < len(l:bytes)
    let l:b0 = l:bytes[l:i]
    let l:b1 = l:i + 1 < len(l:bytes) ? l:bytes[l:i + 1] : 0
    let l:b2 = l:i + 2 < len(l:bytes) ? l:bytes[l:i + 2] : 0
    let l:out .= l:chars[l:b0 / 4]
    let l:out .= l:chars[(l:b0 % 4) * 16 + l:b1 / 16]
    let l:out .= l:i + 1 < len(l:bytes) ? l:chars[(l:b1 % 16) * 4 + l:b2 / 64] : '='
    let l:out .= l:i + 2 < len(l:bytes) ? l:chars[l:b2 % 64] : '='
    let l:i += 3
  endwhile
  return l:out
endfunction

" Envia o guibg do grupo Normal (fundo do tema) em base64
function! s:EnviarFundo() abort
  let l:fundo = synIDattr(synIDtrans(hlID("Normal")), "bg#")
  if empty(l:fundo)
    return
  endif
  call chansend(v:stderr, "\x1b]1337;SetUserVar=NVIM_BG=" . s:Base64(l:fundo) . "\x07")
endfunction

" Envia string vazia para voltar ao tema padrão
function! s:LimparFundo() abort
  call chansend(v:stderr, "\x1b]1337;SetUserVar=NVIM_BG=\x07")
endfunction

augroup FundoDinamicoWezterm
  autocmd!
  autocmd VimEnter,ColorScheme * call s:EnviarFundo()
  autocmd VimLeave * call s:LimparFundo()
augroup END

