if file_readable('/usr/local/bin/python')
  " This most likely means we're on OSX and brew installed Python
  let g:python2_host_prog = '/usr/local/bin/python'
  let g:python3_host_prog = '/usr/local/bin/python3'
else
  let g:python2_host_prog = '/usr/bin/python'
  let g:python3_host_prog = '/usr/bin/python3'
endif

set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc
