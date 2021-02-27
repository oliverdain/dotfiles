"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General configuration

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" Temporary workaround to suppress warning a about vim calling
" deprecated Python features. See https://github.com/vim/vim/issues/3117
if has('python3')
  silent! python3 1
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vim-Plug Setup
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
filetype off
call plug#begin('~/.vim/plugged')

Plug 'whiteinge/diffconflicts'
Plug 'kien/ctrlp.vim'
Plug 'SirVer/ultisnips'
Plug 'nvie/vim-flake8'
Plug 'mileszs/ack.vim'
Plug 'skywind3000/asyncrun.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'francoiscabrol/ranger.vim'
" Required by ranger.vim
Plug 'rbgrouleff/bclose.vim'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } }
" A collection of color schemes
Plug 'flazz/vim-colorschemes'
" papercolor color scheme
Plug 'NLKNguyen/papercolor-theme'

Plug 'neoclide/coc.nvim', { 'branch': 'release' }

call plug#end()
filetype plugin indent on

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" End of Vim-Plug setup.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" This installs my standard set of COC plugs.
function! InstallCocPlugins()
   :CocInstall -sync coc-pyright coc-json coc-yaml coc-markdownlint coc-explorer
endfunction

command! InstallP :call InstallCocPlugins()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" HOPEFULLY temporary bug workarounds and things
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" there's a bug with Konsole (KDE terminal) and nvim and this fixes it. See
" https://github.com/neovim/neovim/issues/6403. Or, if I can settle on a GUI
" I can maybe only do this if no GUI is detected. There isn't any _reliable_
" way to detect if the console is Konsole
if !exists('g:fvim_loaded')
   set guicursor=
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" END HOPEFULLY temporary bug workarounds and things
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Autoreload files if they were changed externally
set autoread
" And check for changed files if the cursor hasn't moved in 4 seconds
au CursorHold * checktime 

" Color scheme and underline spelling errors instead of highlighting them
" Other colorscheme's I've liked: apprentice and jellybean
set background=dark
colo PaperColor
" The spelling color schedume for PaperColor is awful so change it.
" Experimentally I needed a autocmd 'cause I think when you load a file that
" has syntax highlighting the colorscheme changes which would otherwise wipe
" out these rules.
autocmd ColorScheme *
         \ hi clear SpellBad | hi SpellBad cterm=underline gui=underline

" Work with the sytem clipboard
set clipboard=unnamedplus

" neovim setup
if has('nvim')
   " Make normal escape exit terminal mode
   :tnoremap <Esc> <C-\><C-n>
endif

" end neovim setup

" Font size changes via C-+ and C--
let s:fontsize = 12

function! SetFontSize(size)
   let s:fontsize=a:size
  :execute "GuiFont! DejaVu\ Sans\ Mono:h" . s:fontsize
endfunction

function! AdjustFontSize(amount)
  :call SetFontSize(s:fontsize+a:amount)
endfunction

nmap <C-+> :call AdjustFontSize(1)<cr>
nmap <C--> :call AdjustFontSize(-1)<cr>
nmap <C-0> :call SetFontSize(12)<cr>
"
" Use clipboard as default register
if system('uname -s') == "Darwin\n"
  set clipboard=unnamed "OSX
else
  set clipboard=unnamedplus "Linux
endif

" ranger.vim setup
" Don't bind \f to ranger - we use that for FZF
let g:ranger_map_keys = 0
" Use ranger instead of netrw
let g:ranger_replace_netrw = 1
" And :Ex should also open ranger instead of netrw
command! Ex :RangerCurrentFile

" When you use :AsyncRun open the quickfix window and show 8 lines
:let g:asyncrun_open = 8

" To use ag/Silver Searcher (https://github.com/ggreer/the_silver_searcher)
" with the Ack plugin
if executable('ag')
  let g:ackprg = 'ag --nogroup --nocolor --column'
endif

" Make backspace back up a tabstop. Especailly handy for editing Python
set smarttab

"""
" netrw setup

" make long listing the default
let g:netrw_liststyle = 1
" Hide the leading . and .. lines
let g:netrw_list_hide = '^\./,^\.\./'


" Ultisnips defaults to <tab> but that conflicts with YouCompleteMe
let g:UltiSnipsExpandTrigger = '<C-j>'

" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
autocmd BufReadPost *
 \ if line("'\"") > 0 && line("'\"") <= line("$") |
 \   exe "normal g`\"" |
 \ endif

" When we open a git commit message jump to the top and enter insert mode.
au BufNewFile,BufRead *.git/COMMIT_EDITMSG :1 | :start

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" don't show warning messages if a .swp file already exists
set shortmess+=c

set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set noshowcmd		" display incomplete commands
set incsearch		" do incremental searching
set ignorecase          " case insensitive searching
set hidden		" allow hidden buffers
"in normal mode wrap lines and break at work boundries
set wrap
set linebreak

" Sets tab stops and indenting. Note that in some cases this is done in
" ~/.vim/indent files and some is overridden below in the language specific
" sections.
set ts=3 sw=3 et        "tab stops and shift width == 3 and expand tabs to spaces

set showmatch           "show matching brackets
"
"Make <Tab> complete work like bash command line completion
set wildmode=longest,list

" Turn on a fancy status line
set statusline=%m\ [File:\ %f]\ [Type:\ %Y]\ [Col:\ %03v]\ [Line:\ %04l\ of\ %L]
set laststatus=2 " always show the status line

" Turn off swap files. Gets rid of annoying warnings that the file is open in
" two windows and keeps dirs from getting cluttered with .swp files but at the
" cost of greater risk of losing work.
set updatecount=0

" this combination of options causes a backup file to be written before a write
" begins but that file is deleted as soon as the write succeeds so we don't get
" a bunch of files ending with "~" cluttering things up.
set writebackup
set nobackup

" Enable file type detection.
" Also load indent files, to automatically do language-dependent indenting.
filetype plugin indent on
filetype plugin on

" Vimdiff highlighting - commented out for now as I'm hoping color schemes
" will handle this better.
" if ! has("gui_running")
"   " Make vimdiff colors not suck
"   highlight DiffAdd cterm=none ctermfg=Black ctermbg=Green
"   highlight DiffDelete cterm=none ctermfg=Black ctermbg=Red
"   highlight DiffChange cterm=none ctermfg=Black ctermbg=Yellow
"   highlight DiffText cterm=none ctermfg=Black ctermbg=Magenta
" endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General commands/keyboard shortcuts for all files

" FZF fuzzy finder
map <leader>f :FZF<cr>
command! -nargs=1 -complete=dir F :FZF <args>

"commands for easily adding a blank line above or below the current line
map <leader>o o<esc>
map <leader>O O<esc>

" close the quickfix list, location list, and/or the preview window
map <leader>c :ccl<cr> <Bar> :pc<cr> <Bar> :lclose<cr>
" quick navigatin for quickfix
map <F7> :cprevious<CR>
map <F8> :cnext<CR>

" emacs like key bindings in insert mode
imap <C-e> <esc>$a
imap <C-a> <esc>0i
imap <C-u> <esc>ld0i
imap <C-k> <esc>ld$a

" C-s to save in insert and normal mode
imap <C-s> <esc>:w<cr>a
nmap <C-s> :w<cr>

"map killws to a command to remove trailing whitespace
command! Killws :% s/\s\+$//g

" Close the current buffer but leave the window open
" on the previous buffer (if you just close the current buffer it also
" closes the window. b# goes to previous buffer, and then bd# deletes the
" one you were just on)
command! Bc :b#|:bd#

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
endif

" Sorts #include blocks files (or any other block of things with blank lines
" above and below)
map <leader>s {jV}k :!sort<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Language specific configs
" Note some of this is also done via ~/.vim/indent, ~/.vim/ftplugin, etc.

" coc setup for languages

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=yes

" Use tabs for completions
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" GoTo code navigation.
nmap <silent> <leader>gd <Plug>(coc-definition)
nmap <silent> <leader>gy <Plug>(coc-type-definition)
nmap <silent> <leader>gi <Plug>(coc-implementation)
nmap <silent> <leader>gr <Plug>(coc-references)

nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Show errors/issues
nmap <leader>e :CocList diagnostics<CR>
nmap <leader>d :CocDiagnostics<CR>

" File explorer
:nnoremap <space>e :execute ":CocCommand explorer " . expand('%:p:h')<CR>
:nnoremap <space>p :CocCommand explorer<CR>
:nnoremap <space>b :CocCommand explorer --sources buffer+<CR>


"""
" Markdown

autocmd FileType markdown setlocal tw=120 spell
autocmd FileType markdown map <leader>p :!macdown %:p<CR>
let g:vim_markdown_folding_level = 6

""""
" Python

" Let coc-pyright define the root by the presence of a pyrightconfig.json file
" rather than backing up all the way to the .git directory.
autocmd FileType python let b:coc_root_patterns = ['pyrightconfig.json', '.git']

" spell check is smart enough to only check spelling in comments and strings,
" so turn that on for Pyhton code. Note that coc-spell-checker does _not_ seem
" to be smart enough to ignore code and check only comments so we don't use
" it.
autocmd FileType python setlocal spell

" Find the project root by looking for a .mypy.ini file
function! FindMypyRoot()
   let l:thisdir = expand('%:p:h')
   let l:mypyfile = findfile('.mypy.ini', l:thisdir . ';')
   return fnamemodify(l:mypyfile, ':p:h')
endfunction

" Call mypy with one or more arguments. It's up to the caller of this function
" to ensure that any file paths passed are relative to FindMypyRoot. Note that
" we actually call "dmypy run" to use the mypy daemon.
"
" ACTUALLY: we don't currently use the daemon due to
" https://github.com/python/mypy/issues/9366 - on our code it dies with
" "KeyError: unittest".
function! CallMypy(...)
   let l:mypyroot = FindMypyRoot()
   if a:0 == 0
      " let l:cmd = "dmypy run"
      let l:cmd = "mypy"
   else
      " let l:cmd = "dmypy run -- " . join(a:000)
      let l:cmd = "mypy " . join(a:000)
   endif

   " Echo "entering..." so that quickfix understands the paths to files are
   " from the mypyroot
    execute ":AsyncRun echo Entering " . l:mypyroot . " && " . l:cmd
endfunction

function! CallMypyOnCurrentFile()
   let l:curfile = substitute(expand("%:p"), FindMypyRoot() . '/', '', '')
   :call CallMypy(l:curfile)
endfunction

function! CallMypyOnCurrentDir()
   let l:curfile = substitute(expand("%:p:h"), FindMypyRoot() . '/', '', '')
   :call CallMypy(l:curfile)
endfunction

command! Mf :call CallMypyOnCurrentFile()
command! Md :call CallMypyOnCurrentDir()

""""
" C++
" Searches up from the current directory to the directory with a build.gradle
" (e.g. the sub-project root) and then from there down for a file with the
" given name.

" spell check is smart enough to only check spelling in comments and strings,
" so turn that on for C++ code.
autocmd FileType c,cpp setlocal spell

function! FindRelToSubProject(fname)
   let l:thisdir = expand('%:p:h')
   let l:buildfile = findfile('WORKSPACE', l:thisdir . ';')
   let l:builddir = fnamemodify(l:buildfile, ':p:h') . '/cpp'
   return findfile(a:fname, l:builddir . '/**')
endfunction

" Find a file with the same name as the current buffer but with a different
" file extension. Specifically find a file with the same name as current file
" but with the extension swapped as per the argument using
" FindRelToSubProject. Then open that file for editing.
function! EditExtension(ext)
   let l:basefile = expand('%:t:r')
   let l:newfile = FindRelToSubProject(l:basefile . a:ext)
   :execute "e" l:newfile
endfunction

" Find the test for a file and opens it.
function! OpenTest()
   let l:basefile = expand('%:t:r')
   let l:newfile_name = 'test_' . l:basefile . '.cpp'
   let l:newfile = FindRelToSubProject(l:newfile_name)
   :execute "e" l:newfile
endfunction

" Add ability to switch from .h to .cc quickly
command! Toh :call EditExtension('.h')
command! Toc :call EditExtension('.cpp')
command! Tot :call OpenTest()

function! CallBazel(...)
   let l:workspace_path = findfile('WORKSPACE', ';')
   let l:workspace_dir = fnamemodify(l:workspace_path, ':p:h')
   if a:0 == 0
      let l:cmd = "bazel build ..."
   else
      let l:cmd = "bazel " . join(a:000)
   endif

    " Each Bazel error starts with a line about the build rule which links to
    " the BUILD.bazel which isn't helpful so we ignore that.
    set errorformat=%-G%.%#C\+\+\ compilation\ of\ rule\ %.%#
    set errorformat+=%DEntering\ %f
    set errorformat+=ERROR:\ %f:%l:%c:%m
    set errorformat+=%f:%l:%c:%m

    " We currently have things set to show progress messages but if you want
    " to hide them uncomment the following:
    " set errorformat+=%+GINFO:\ %.%#
    " set errorformat+=%+GLoading:\ %.%#
    " set errorformat+=%+G[%.%#

    " In order to get the quickfix list to work we have to tell vim that files
    " in errors are relative to the repo root (but we don't want to run from
    " there as we'd like to be able to build from pwd to build just that
    " project). So we set up an errorformat above with a %D rule and then we
    " echo "Entering ..." so that quickfix picks that up correctly.
    execute ":AsyncRun echo Entering " . l:workspace_dir . " && " . l:cmd
endfunction
   
command! -narg=* -complete=file B :call CallBazel(<f-args>)
""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Fileype specific configs for non-programming languages.

" If editing a git commmit file automatically go to the top of the file
" and enter insert mode
au BufNewFile,BufRead *.git/COMMIT_EDITMSG :1
" text files are limited to 120 character lines
autocmd FileType text setlocal textwidth=120 spell

""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin configuration


""""
" CtrlP/FZF

" open new files (ctrl-y) in the current window instead of the default of a
" new vertical split.
let g:ctrlp_open_new_file = 'r'

if executable('ag')
  " Use ag in CtrlP for listing files.
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
endif

nmap ,e :CtrlP %:p:h<CR>
" ,p opens a filesystem explorer from the current working director (p is short
" for pwd)
nmap ,m :e %:h/
nmap ,p :CtrlP getcwd()<CR>
nmap ,b :CtrlPBuffer<CR>

" There is apparently a bug in some versions of gvim that cause the cursor to
" be invisible. This strange hack fixes it!
if !has('gui_vimr')
   let &guifont=&guifont
endif
