if !exists("g:bg_sessions_dir")
    let g:bg_sessions_dir = "~/.vim-sessions"
endif

fun! bg_sessions#GetSessionPath(sessionName)
    return g:bg_sessions_dir . "/" . a:sessionName . ".vim"
endfunction

fun! bg_sessions#SaveSession(sessionName)
    if strlen(a:sessionName)
        execute "mksession! " . bg_sessions#GetSessionPath(a:sessionName) 
    endif
    execute "mksession! " . bg_sessions#GetSessionPath("last")
endfunction

fun! bg_sessions#LoadSession(sessionName)
    if strlen(a:sessionName)
        execute "source " . bg_sessions#GetSessionPath(a:sessionName)
    else
        execute "source " . bg_sessions#GetSessionPath("last")
    endif
endfunction

fun! bg_sessions#GetSessionFiles()
    return split(globpath(g:bg_sessions_dir, '*'), '\n')
endfunction

fun! bg_sessions#GetSessionNames()
    return map(bg_sessions#GetSessionFiles(), "fnamemodify(v:val, ':t:r')")
endfunction

fun! bg_sessions#Sessions()
    echo join(bg_sessions#GetSessionNames(), "\n")
endfunction

fun! bg_sessions#SessionComplete(ArgLead, CmdLine, CursorPos)
    let match_filter = 'v:val =~ ".*' . a:ArgLead . '.*"'
    return filter(bg_sessions#GetSessionNames(), match_filter)
endfunction

fun! bg_sessions#DeleteSession(sessionName)
    let file_path = fnamemodify(bg_sessions#GetSessionPath(a:sessionName), ":p")
    let rm_cmd = has("win32") || has("win16") ? "!del " : "!rm "

    if has("win32") || has("win16")
        let file_path = fnamemodify(file_path, ":gs?/?\\?")
    endif

    if strlen(a:sessionName)
        execute rm_cmd . file_path
    endif
endfunction

command! -nargs=? -complete=customlist,bg_sessions#SessionComplete SaveSession call bg_sessions#SaveSession(<q-args>)
command! -nargs=? -complete=customlist,bg_sessions#SessionComplete LoadSession call bg_sessions#LoadSession(<q-args>)
command! -nargs=1 -complete=customlist,bg_sessions#SessionComplete DeleteSession call bg_sessions#DeleteSession(<q-args>)
command! Sessions call bg_sessions#Sessions()
autocmd VimLeave * call bg_sessions#SaveSession("last")
