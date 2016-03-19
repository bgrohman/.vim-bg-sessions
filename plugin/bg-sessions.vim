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
    let match_filter = 'v:val =~ ".*' . a:ArgLead . '.*"'
    return filter(GetSessionNames(), match_filter)
endfunction

fun! DeleteSession(sessionName)
    let file_path = fnamemodify(GetSessionPath(a:sessionName), ":p")
    let rm_cmd = has("win32") || has("win16") ? "!del " : "!rm "

    if has("win32") || has("win16")
        let file_path = fnamemodify(file_path, ":gs?/?\\?")
    endif

    if strlen(a:sessionName)
        execute rm_cmd . file_path
    endif
endfunction

command! -nargs=? SaveSession call SaveSession(<q-args>)
command! -nargs=? -complete=customlist,SessionComplete LoadSession call LoadSession(<q-args>)
command! -nargs=1 -complete=customlist,SessionComplete DeleteSession call DeleteSession(<q-args>)
command! Sessions call Sessions()
autocmd VimLeave * call SaveSession("last")
