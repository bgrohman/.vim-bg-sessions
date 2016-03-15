fun! SaveSession(sessionName)
	if argc() == 0
		execute "mksession! ~/.vim-sessions/" . a:sessionName . ".vim"
	endif
	execute "mksession! ~/.vim-sessions/last.vim"
endfunction

fun! LoadSession(sessionName)
	if argc() == 0
		execute "source ~/.vim-sessions/last.vim"
	else
		execute "source ~/.vim-sessions/" . a:sessionName
	endif
endfunction

fun! GetSessionFiles()
	return split(globpath('~/.vim-sessions/', '*'), '\n')
endfunction

fun! GetSessionNames()
	return map(GetSessionFiles(), "fnamemodify(v:val, ':t:r')")
endfunction

fun! Sessions()
	echo join(GetSessionNames(), "\n")
endfunction

fun! SessionComplete(ArgLead, CmdLine, CursorPos)
	return GetSessionNames()
endfunction

autocmd VimLeave * call SaveSession()
command! -nargs=? SaveSession call SaveSession(<q-args>)
command! -nargs=? -complete=customlist,SessionComplete LoadSession call LoadSession(<q-args>)
command! Sessions call Sessions()
