set encoding=utf-8

set list
set listchars=eol:⏎,tab:>-
set et
set ts=4
set sw=4
set number
set scrolloff=8
set virtualedit=all
set foldmethod=syntax
set cursorline
set ignorecase
set smartcase
set nowrap

if has('nvim')
  set diffopt=internal,filler,vertical,indent-heuristic,algorithm:histogram
endif

if exists('&inccommand')
  set inccommand=split
endif

set termguicolors

set undofile
inoremap <C-O> <C-X><C-O>

" Terminal
command! -nargs=+ -complete=file T vsplit | terminal <args>

" Ripgrep
if executable('rg')
  set grepprg=rg\ --vimgrep\ --sort-files
  set grepformat=%f:%l:%c:%m
endif

let g:ale_fix_on_save = 1
let g:ale_linters = {}
let g:ale_fixers = {}
let g:ale_linters_ignore = {
      \ 'typescript': ['tslint'],
      \ }

" Go
if $GOPATH != ''
  let g:ale_linters['go'] = ['go build', 'golangci-lint']
  let g:ale_fixers['go'] = ['goimports']
  "let g:go_fmt_command = "goimports"
  let g:go_code_completion_enabled = 0
  let g:go_fmt_autosave = 0
  let g:go_def_mapping_enabled = 0
  let g:go_doc_keywordprg_enabled = 0
  let g:go_highlight_extra_types = 1
  let g:go_highlight_functions = 1
  let g:go_highlight_function_calls = 1
  let g:go_highlight_types = 1
  let g:go_highlight_variable_declarations = 1
endif

" TypeScript
let g:ale_fixers['typescript'] = ['eslint', 'prettier']

nmap <Space>: <Plug>(quickhl-manual-this-whole-word)

" FZF
let $FZF_DEFAULT_OPTS = $FZF_DEFAULT_OPTS . " --no-sort"
nmap <expr> <Space>r ':<C-u>Rg ' . expand('<cword>')
nmap <Space>s :<C-u>Lines<CR>
nmap <Space>b :<C-u>Buffers<CR>
nmap <Space>f :<C-u>History<CR>

if has('nvim')
  let s:plugdirs = glob(expand("~/.local/share/nvim/site/pack/*"), '\n')
else
  let s:plugdirs = glob(expand("~/.vim/pack/*"), '\n')
endif

for d in split(s:plugdirs)
  for p in split(globpath(d, "start/*"), '\n')
    let s:docdir = p . "/doc"
    if isdirectory(s:docdir)
      execute "helptags" s:docdir
    endif
  endfor
  for p in split(globpath(d, "opt/*"), '\n')
    let s:docdir = p . "/doc"
    if isdirectory(s:docdir)
      execute "helptags" s:docdir
    endif
  endfor
endfor

" neosnippet
let g:neosnippet#disable_runtime_snippets = {
      \ '_' : 1
      \ }
let g:neosnippet#snippets_directory = [
      \ expand('~/.config/nvim/snippets')
      \ ]
imap <expr><Tab>
      \ neosnippet#expandable_or_jumpable() ?
      \ "\<Plug>(neosnippet_expand_or_jump)" : "\<Tab>"
smap <Tab> <Plug>(neosnippet_expand_or_jump)

" AsyncRun
let g:asyncrun_open=8
nnoremap <f5> :<C-u>AsyncRun make

augroup AsyncRunGo
  autocmd!
  au BufRead *.go :nnoremap <f8> :<C-u>AsyncRun go test ./... -v
augroup END

" Dispatch
let g:dispatch_no_maps = 1

" Rust
let g:rustfmt_autosave = 1

" Haskell
if executable ('hlint')
  let g:ale_linters['haskell'] = ['hlint']
endif
if executable ('brittany')
  let g:ale_fixers['haskell'] = ['brittany']
endif

" LSP
augroup my-lsp
  autocmd! *
  if executable('rls')
    au User lsp_setup call lsp#register_server({
          \
          \ 'name': 'rls',
          \ 'cmd': {server_info->['rustup', 'run', 'stable', 'rls']},
          \ 'root_uri':{server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'Cargo.toml'))},
          \ 'whitelist': ['rust'],
          \ })
    au FileType rust setlocal omnifunc=lsp#complete
    au FileType rust call s:configure_lsp()
  endif

  if executable('typescript-language-server')
    au User lsp_setup call lsp#register_server({
          \ 'name': 'typescript-language-server',
          \ 'cmd': {server_info->[&shell, &shellcmdflag, 'typescript-language-server --stdio']},
          \ 'root_uri':{server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'tsconfig.json'))},
          \ 'whitelist': ['typescript'],
          \ })
    au FileType typescript setlocal omnifunc=lsp#complete
    au FileType typescript call s:configure_lsp()
  endif
augroup END

function! s:configure_lsp() abort
  nnoremap <buffer> gd :<C-u>LspDefinition<CR>
  nnoremap <buffer> gD :<C-u>LspReferences<CR>
  nnoremap <buffer> K :<C-u>LspHover<CR>
endfunction

" coc.nvim
augroup coc-nvim
  autocmd!
  au FileType go call s:configure_coc()
  au FileType cs call s:configure_coc()
  au FileType haskell call s:configure_coc()
  au FileType python call s:configure_coc()
  au FileType json call s:configure_coc()
  au FileType typescript call s:configure_coc()
augroup END

function! s:configure_coc() abort
  nmap <buffer> gd <Plug>(coc-definition)
  nmap <buffer> gD <Plug>(coc-references)
  nnoremap <buffer> K :call CocAction('doHover')<CR>
  inoremap <buffer><expr> <c-o> coc#refresh()
endfunction

" easymotion
nmap <Space>/ <Plug>(easymotion-sn)
" easy-align
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

" Gina
let g:gina#command#blame#formatter#timestamp_months=0
let g:gina#command#blame#formatter#timestamp_format1="%m-%dT%R"
call gina#custom#command#alias('log', 'l')
call gina#custom#command#alias('log', 'lstat')
call gina#custom#command#alias('branch', 'b')
call gina#custom#command#option('/\v^%(l|lstat)$', '--tags')
call gina#custom#command#option('/\v^%(l|lstat)$', '--branches')
call gina#custom#command#option('/\v^%(l|lstat)$', '--remotes')
call gina#custom#command#option('/\v^%(l|lstat)$', '--graph')
call gina#custom#command#option('lstat', '--stat', '200')
call gina#custom#mapping#nmap(
            \ '/\v%(blame|log|reflog)',
            \ 'p',
            \ ':<C-u>call gina#action#call(''preview'')<CR>',
            \ {'noremap': 1, 'silent': 1}
            \)

colorscheme jellybeans
