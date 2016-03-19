if !exists("g:bg_sessions_dir")
    let g:bg_sessions_dir = "~/.vim-sessions"
endif

fun! s:GetSessionPath(sessionName)
    return g:bg_sessions_dir . "/" . a:sessionName . ".vim"
endfunction

fun! bg_sessions#SaveSession(sessionName)
    if strlen(a:sessionName)
        execute "mksession! " . s:GetSessionPath(a:sessionName) 
    endif
    execute "mksession! " . s:GetSessionPath("last")
endfunction

fun! bg_sessions#LoadSession(sessionName)
    if strlen(a:sessionName)
        execute "source " . s:GetSessionPath(a:sessionName)
    else
        execute "source " . s:GetSessionPath("last")
    endif
endfunction

fun! s:GetSessionFiles()
    return split(globpath(g:bg_sessions_dir, '*'), '\n')
endfunction

fun! s:GetSessionNames()
    return map(s:GetSessionFiles(), "fnamemodify(v:val, ':t:r')")
endfunction

fun! bg_sessions#Sessions()
    echo join(s:GetSessionNames(), "\n")
endfunction

fun! s:SessionComplete(ArgLead, CmdLine, CursorPos)
    let match_filter = 'v:val =~ ".*' . a:ArgLead . '.*"'
    return filter(s:GetSessionNames(), match_filter)
endfunction

fun! bg_sessions#DeleteSession(sessionName)
    let file_path = fnamemodify(s:GetSessionPath(a:sessionName), ":p")
    let rm_cmd = has("win32") || has("win16") ? "!del " : "!rm "

    if has("win32") || has("win16")
        let file_path = fnamemodify(file_path, ":gs?/?\\?")
    endif

    if strlen(a:sessionName)
        execute rm_cmd . file_path
    endif
endfunction

command! -nargs=? -complete=customlist,s:SessionComplete SaveSession call bg_sessions#SaveSession(<q-args>)
command! -nargs=? -complete=customlist,s:SessionComplete LoadSession call bg_sessions#LoadSession(<q-args>)
command! -nargs=1 -complete=customlist,s:SessionComplete DeleteSession call bg_sessions#DeleteSession(<q-args>)
command! Sessions call bg_sessions#Sessions()
autocmd VimLeave * call bg_sessions#SaveSession("last")
