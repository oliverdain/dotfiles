if !file_readable('/usr/local/bin/python3')
  " This most likely means we're on Linux. On OSX we use a combination of and
  " brew installed Python and system installed but we don't have to do
  " anything
  let g:python2_host_prog = '/usr/bin/python'
  let g:python3_host_prog = '/usr/bin/python3'
endif

set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc
