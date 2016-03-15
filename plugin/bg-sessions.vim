if !exists("g:bg_sessions_dir")
	let g:bg_sessions_dir = "~/.vim-sessions"
endif

fun! GetSessionPath(sessionName)
	return g:bg_sessions_dir . "/" . a:sessionName . ".vim"
endfunction

fun! SaveSession(sessionName)
	if strlen(a:sessionName)
		execute "mksession! " . GetSessionPath(a:sessionName) 
	endif
	execute "mksession! " . GetSessionPath("last")
endfunction

fun! LoadSession(sessionName)
	if strlen(a:sessionName)
		execute "source " . GetSessionPath(a:sessionName)
	else
		execute "source " . GetSessionPath("last")
	endif
endfunction

fun! GetSessionFiles()
	return split(globpath(g:bg_sessions_dir, '*'), '\n')
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
