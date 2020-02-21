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

Plug 'SirVer/ultisnips'
Plug 'nvie/vim-flake8'
Plug 'tpope/vim-rhubarb'
Plug 'mileszs/ack.vim'
Plug 'ervandew/supertab'
Plug 'majutsushi/tagbar'
Plug 'skywind3000/asyncrun.vim'
Plug 'autozimu/LanguageClient-neovim', { 'branch': 'next', 'do': 'bash install.sh' }
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'llvm-mirror/lldb'
Plug 'IN3D/vim-raml'
Plug 'tpope/vim-abolish'
Plug 'francoiscabrol/ranger.vim'
" Required by ranger.vim
Plug 'rbgrouleff/bclose.vim'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } }
if has('nvim')
  Plug 'Shougo/deoplete.nvim' , { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif

call plug#end()
filetype plugin indent on

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" End of Vim-Plug setup.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" neovim setup
if has('nvim')
   " Make normal escape exit terminal mode
   :tnoremap <Esc> <C-\><C-n>
endif

" VV NeoVim GUI setup
if exists('g:vv')
   VVset fontfamily=Menlo,Monaco,monospace
endif

" end neovim setup

" ranger.vim setup
" Don't bind \f to ranger - we use that for FZF
let g:ranger_map_keys = 0
" Use ranger instead of netrw
let g:ranger_replace_netrw = 1
" And :Ex should also open ranger instead of netrw
command! Ex :RangerCurrentFile

" general deoplete config
let g:deoplete#enable_at_startup = 1
:call deoplete#custom#option('auto_complete', v:true)
:call deoplete#custom#option('complete_method', 'omnifunc')

if !has('gui_vimr')
   command! SmallFont :set guifont=Monaco:h10
   command! Bigfont :set guifont=Menlo:h11
endif

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
set shortmess+=A

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
set statusline=%m\ [File:\ %f]\ [Type:\ %Y]\ [ASCII:\ %03.3b]\ [Col:\ %03v]\ [Line:\ %04l\ of\ %L]
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

" Vimdiff highlighting
if ! has("gui_running")
  " Make vimdiff colors not suck
  highlight DiffAdd cterm=none ctermfg=Black ctermbg=Green
  highlight DiffDelete cterm=none ctermfg=Black ctermbg=Red
  highlight DiffChange cterm=none ctermfg=Black ctermbg=Yellow
  highlight DiffText cterm=none ctermfg=Black ctermbg=Magenta
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General commands/keyboard shortcuts for all files

" FZF fuzzy finder
map <leader>f :FZF<cr>
command! -nargs=1 -complete=dir F :FZF <args>

" Quick shortcut to restart LanguageClient (sometimes it gets kinda stuck)
" The sleep is 'cause if you exit and restart really fast the restart fails.
command! Lcr call LanguageClient#exit()|sleep 1|call LanguageClient#startServer()

"commands for easily adding a blank line above or below the current line
map <leader>o o<esc>
map <leader>O O<esc>

" close the quickfix list and/or the preview window
map <leader>c :ccl<cr> <Bar> :pc<cr>

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

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Templates: My personal templating system
"
" It works like this:
"
" Given a new file like /p1/p2/p3/p4/file.h we look in ~/.vim/templates for
" matching templates. We 1st start by walking backward up the list of dirs so
" we look for a ~/.vim/templates/p4 directory. If there is one and it contains
" a template.h file that is used. If not (either not such dir or there is a
" dir but it doesn't contain a .h template) we go up and look for p3, then p2,
" etc. Suppose we find a ~/.vim/templates/p2. We then go forwards again
" looking for a ~/.vim/templates/p2/p3/template.h, then a
" ~/.vim/templates/p2/p3/p4/template.h, etc. The longest matching path is
" used. If we can't find any matching subdirs we just look for a template.h
" file in ~/.vim/templates and use that.
"
" Template matching rules: template files are of the form template_<suffix> so
" template_.h matches files that end in '.h' while template_SConstruct matches
" files that end with 'SConstruct'.
"
" Once a template is found it is loaded and all the <+KEYWORD+> items are
" replaced as per ExpandPlaceholders() below. This is a very flexible
" mechanism that allows you to easily add new keywords and functions for
" their replacement. Keywords also can accept arguments.
"
" Finally, if the string ~~CURSOR~~ is found the cursor is moved to that
" position and the user is left in insert mode.

" Given directory dir returns the name of a template that matches fname or the
" empty string if not such template could be found.
function! FindTemplateMatch(dir, fname)
   let l:dir = a:dir
   if match(a:dir, '.*/$') == -1
      let l:dir = a:dir . '/'
   endif
   let l:templates = split(glob(l:dir . 'template_*'))
   for l:template_fname in l:templates
      let l:suf_idx = strridx(l:template_fname, 'template_')
      let l:suffix = strpart(l:template_fname, l:suf_idx + 9)
      let l:suf_idx = strridx(a:fname, l:suffix)
      if l:suf_idx >= 0
         if strpart(a:fname, l:suf_idx) == l:suffix
            return l:template_fname
         endif
      endif
   endfor
   return ''
endfunction

" Given a file whose full path is fname see if there is an appropriate
" template for it. If so return the name of that template.
function! FindTemplate(fname)
   let l:templates_dir = fnamemodify('~/.vim/templates', ':p')
   " First see if there's a template that matches any of the directories in
   " the path. If so we use this. If not we just check file extension.

   " Expand to a full path and strip off the file name so we have just the
   " directory name
   let l:fname_abs_dir = fnamemodify(a:fname, ':p:h')
   " Cur path starts out as the full path. Then we remove the ending dir one
   " dir at a time to see if we can find a matching template. For example, if
   " it starts with '/home/odain/this/long/path' we first look for a directory
   " named 'path' in the templates directory. If there isn't one we then
   " update l:cur_path to be '/home/odain/this/long' and look for a dir named
   " 'long', etc.
   let l:cur_path = l:fname_abs_dir
   let l:cur_match_template = ''
   while strlen(l:cur_path) > 1
      let l:cdir = fnamemodify(l:cur_path, ':t')
      let l:match_dir = finddir(l:cdir, l:templates_dir)
      " We found a matching dir but we're not done. We also need to see if
      " there's a matching template. There also might be a more specific
      " matching template (e.g. in a subdirectory) that we should use instead.
      if !empty(l:match_dir)
         let l:cur_match_dir = l:templates_dir . l:cdir
         let l:potential_template = FindTemplateMatch(l:cur_match_dir, a:fname)
         if !empty(l:potential_template) && filereadable(l:potential_template)
            let l:cur_match_template = l:potential_template
         endif
         " Now see if there's a more specific match. To do that we go through
         " the path from the matching dir forward looking for subdirs that
         " also match.
         let l:dir_suffix = strpart(l:fname_abs_dir, strlen(l:cur_path))
         let l:subdirs = split(l:dir_suffix, '/')
         let l:cur_subdir = l:cur_match_dir
         for l:subdir in l:subdirs
            if !empty(finddir(l:subdir, l:cur_subdir))
               let l:cur_subdir = l:cur_subdir . '/' . l:subdir
               let l:potential_template = FindTemplateMatch(l:cur_subdir, a:fname)
               if !empty(l:potential_template) && filereadable(l:potential_template)
                  let l:cur_match_template = l:potential_template
               endif
            else
               break
            endif
         endfor
         " If we've got a template now we're done
         if !empty(l:cur_match_template)
            return l:cur_match_template
         endif
      endif  
      let l:cur_path = fnamemodify(l:cur_path, ':h')
   endwhile
 
   " If we got here we didn't find a template in any of the subdirs so we just
   " look by file extension for a match.
   let l:cur_match_template = FindTemplateMatch(l:templates_dir, a:fname)
   if !empty(l:cur_match_template) && filereadable(l:cur_match_template)
      return l:cur_match_template
   else
      return ''
   endif
endfunction

" Function used to expand <+FOO+> place holders in the current buffer. Some
" place holders have a ,ARG suffix like <+FOO,ARG+> in which case ARG is used
" to help us expand FOO. Generally this is called after a macro file is read
" in.
function! ExpandPlaceholders()
   " Map from placeholders to functions that expand them
   let l:placeholders = {'VIM_FILE': function('ExpandVimFile'),
            \            'INCLUDE_GUARD': function('ExpandIncludeGuard'),
            \            'DATE': function('ExpandDate')}
   let l:place_pattern = '<+\([^+,]\+\),\?\([^+]*\)+>'
   let l:line = search(l:place_pattern)
   while l:line > 0
      let l:line_text = getline(l:line)
      let l:place_holder = matchlist(l:line_text, l:place_pattern)
      if !has_key(l:placeholders, l:place_holder[1])
         echoerr "Unknown placeholder '" l:place_holder[1] "'"
         return
      endif
      " Find the replacement function in the dictionary
      let l:Fun = l:placeholders[l:place_holder[1]]
      " Call the function passing anyting after the "," as additional
      " arguments
      if (len(l:place_holder) > 2 && !empty(l:place_holder[2])) 
         let l:replacement = l:Fun(l:place_holder[2])
      else
         let l:replacement = l:Fun()
      endif
      " Unset l:Fun or we get errors when we call :let again. Not sure why as
      " you can usually overwrite a variable but function pointers seem to be
      " special.
      unlet l:Fun
      let l:m_start = match(l:line_text, l:place_holder[0])
      let l:m_end = matchend(l:line_text, l:place_holder[0])
      let l:line_text = strpart(l:line_text, 0, l:m_start) . l:replacement .  strpart(l:line_text, l:m_end)
      :call setline(l:line, l:line_text) 
      let l:line = search(l:place_pattern)
   endwhile
endfunction

" Do fnamemodify on the current file name with the supplied arguments. For
" example, passing ':p' results in the full path, etc.
function! ExpandVimFile(fargs)
   return fnamemodify(expand('%'), a:fargs)
endfunction

" To be used like #ifndef <+INCLUDE_GUARD,spar+> via ExpandPlaceholders. This
" expands the INCLUDE_GUARD to be PATH_TO_FILE_H_ where the path is relative
" to the argument (in the example above it's relative to the directory spar).
function! ExpandIncludeGuard(eargs)
   let l:fname = fnamemodify(expand('%'), ':p')
   let l:end_path_pos = matchend(l:fname, '/' . a:eargs . '/')
   let l:end_path = strpart(l:fname, l:end_path_pos)
   let l:end_path = substitute(l:end_path, '/', '_', 'g')
   let l:end_path = substitute(l:end_path, '-', '_', 'g')
   let l:end_path = substitute(l:end_path, ' ', '_', 'g')
   let l:end_path = substitute(l:end_path, '\.', '_', 'g')
   return toupper(l:end_path) . '_'
endfunction

" Returns a string representing today's date. The argument is a string
" specifying how the date should be formatted in standard strftime notation.
function! ExpandDate(dargs)
  return strftime(a:dargs, localtime()) 
endfunction

function! MoveToCursor()
   " The \V makes the pattern "very non-magic" so its pretty much a literal
   " string match.
   let l:line = search('\V~~CURSOR~~')
   if l:line != 0
      " The string '~~CURSOR~~' is 10 characters long and search leaves us at the
      " beginning of the match so delete the next 10 characters and put us in
      " insert mode.
      normal 10dl
      startinsert
   endif
endfunction

function! OnNewFile()
   let l:template = FindTemplate(expand('%'))
   if !empty(l:template)
      " move the cursor to be beginning of the file
      normal gg
      " Read in the template
      execute ':r ' . l:template
      " The read command puts the file contents on the line *after*
      " the cursor position so we have a blank line at the top of the
      " file. Delete that.
      normal ggdd
      :call ExpandPlaceholders()
      " If there's a ~~CURSOR~~ marker in the file move to it and start insert
      " mode
      :call MoveToCursor()
   endif
endfunction

au! BufNewFile * :call OnNewFile()
map <leader>n :call OnNewFile()<cr>


"""""""""""""""""""""""""""" end templates



""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Language specific configs
" Note some of this is also done via ~/.vim/indent, ~/.vim/ftplugin, etc.

" Set up Language Server Protocol plugin for all langs
let g:LanguageClient_serverCommands = {
    \ 'c': ['ccls', '--log-file=/tmp/cc.log', '--init={"index": {"initialBlacklist": ["third_party", "bazel-.*", "python"]}}'],
    \ 'cpp': ['ccls', '--log-file=/tmp/cc.log', '--init={"index": {"initialBlacklist": ["third_party", "bazel-.*", "python"]}}']
    \ }
" And hook it up to deoplete
call deoplete#custom#option('sources', {
    \ 'cpp': ['LanguageClient'],
    \ 'c': ['LanguageClient'],
\})

" Overridden because it's currently hopelessly broken with UltiSnips. See
" https://github.com/autozimu/LanguageClient-neovim/issues/379
let g:LanguageClient_hasSnippetSupport = 0
" Override or it overwrites things like compile errors with in-file
" diagnostics that happen while you're in the middle of fixing the compile
" errors
let g:LanguageClient_diagnosticsList = 'Location'
" So it doesn't put error messages inline next to the error - gets super
" distracting otherwise 'cause you delete a ;, for example, and then there's
" a big red error message on every line.
let g:LanguageClient_useVirtualText = 0



" Per LanguageClient docs: https://github.com/cquery-project/cquery/wiki/Vim
augroup LanguageClient_config
  au!
  au BufEnter * let b:Plugin_LanguageClient_started = 0
  au User LanguageClientStarted setl signcolumn=yes
  au User LanguageClientStarted let b:Plugin_LanguageClient_started = 1
  au User LanguageClientStopped setl signcolumn=auto
  au User LanguageClientStopped let b:Plugin_LanguageClient_stopped = 0
augroup END

" And set up LanguageClient keymaps for those filetypes where we have a server
function! LC_maps()
if has_key(g:LanguageClient_serverCommands, &filetype)
  " Hit "K" in normal mode to get a pop-up window with the definition and
  " comments for the method under the cursor
  nnoremap <buffer> <silent> K :call LanguageClient#textDocument_hover()<cr>
  " Go to the definition of the symbol
  nnoremap <buffer> <silent> <C-]> :call LanguageClient#textDocument_definition()<CR>
  " rename the symbol under the cursor
  command! Rename :call LanguageClient#textDocument_rename()<CR>
  " Try to fix issues that have been identified
  command! Fix :call LanguageClient#textDocument_codeAction()<CR>
endif
endfunction

autocmd FileType * call LC_maps()

"""
" Markdown

autocmd FileType markdown setlocal tw=120 spell
autocmd FileType markdown map <leader>p :!macdown %:p<CR>
let g:vim_markdown_folding_level = 6

""""
" Python
autocmd FileType python setlocal foldmethod=indent
" set foldlevel really high so that, initially, all folds are open
autocmd FileType python setlocal foldlevel=1000
autocmd FileType python setlocal et ts=4 sw=4 tw=120
autocmd FileType python map <leader>l :call Flake8()<CR>
autocmd FileType python setlocal completeopt=menu,longest,preview
autocmd FileType python nmap <buffer> <C-]> :call g:jedi#goto()<CR>
let g:jedi#popup_on_dot = 0


""""
" C++
" Searches up from the current directory to the directory with a build.gradle
" (e.g. the sub-project root) and then from there down for a file with the
" given name.

" tagbar setup
nmap <leader>t :TagbarToggle<CR>

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

autocmd FileType c,cpp setlocal et ts=2 sw=2 tw=120 
" spell check is smart enough to only check spelling in comments and strings,
" so turn that on for C++ code.
autocmd FileType c,cpp setlocal spell

" We have templates *and* UltiSnips for our copyright line and our standard
" header junk. Unfortunately neither of those work in vscode with the Intellij
" plugin so we also have commands for them here.
command! Sheader :normal iheader<C-j>
command! Scright :normal icright<C-j>


function! CallGradle(...)
 let l:gradle_path = findfile('gradlew', '.;')
 " a:0 == # of args to the command
 if a:0 == 0
    let l:cmd = l:gradle_path . " build"
 else
    let l:cmd = l:gradle_path . " " . join(a:000)
 endif
 execute ":AsyncRun " . l:cmd
endfunction

command! -narg=* G :call CallGradle(<f-args>)
command! Gt :G buildTestOSXDebug

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
autocmd FileType text setlocal textwidth=120

""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin configuration


""""
" CtrlP

" open new files (ctrl-y) in the current window instead of the default of a
" new vertical split.
let g:ctrlp_open_new_file = 'r'

nmap ,e :FZF %:p:h<CR>
" ,p opens a filesystem explorer from the current working director (p is short
" for pwd)
nmap ,p :FZF<CR>
nmap ,b :Buffers<CR>

" There is apparently a bug in some versions of gvim that cause the cursor to
" be invisible. This strange hack fixes it!
if !has('gui_vimr')
   let &guifont=&guifont
endif

" Color scheme and underline spelling errors instead of highlighting them
colo koehler
hi clear SpellBad
hi SpellBad cterm=underline gui=underline
