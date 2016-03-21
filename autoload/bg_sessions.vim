if !exists("g:bg_sessions_dir")
    let g:bg_sessions_dir = "~/.vim-sessions"
endif

if !isdirectory(expand(g:bg_sessions_dir, ":p"))
    call mkdir(expand(g:bg_sessions_dir, ":p"))
endif

function! s:GetSessionPath(sessionName)
    return g:bg_sessions_dir . "/" . a:sessionName . ".vim"
endfunction

function! s:GetSessionFiles()
    return split(globpath(g:bg_sessions_dir, '*'), '\n')
endfunction

function! s:GetSessionNames()
    return map(s:GetSessionFiles(), "fnamemodify(v:val, ':t:r')")
endfunction

function! s:GetSessionNameWithTime(sessionName)
    let path = expand(s:GetSessionPath(a:sessionName), ":p")
    let time = getftime(path)
    return a:sessionName . " (" . strftime("%F %r", time) . ")"
endfunction

function! s:GetSessionNamesWithTimes()
    return map(s:GetSessionNames(), "s:GetSessionNameWithTime(v:val)")
endfunction

function! s:SaveSessionImpl(sessionName)
    let sessionoptions = &sessionoptions
    try
        set sessionoptions-=blank sessionoptions-=options sessionoptions+=tabpages
        if strlen(a:sessionName)
            if a:sessionName !~ ".*_latest$"
                let g:bg_sessions_current = a:sessionName
            endif
            execute "mksession! " . s:GetSessionPath(a:sessionName) 
        endif
        execute "mksession! " . s:GetSessionPath("last")
    finally
        let &sessionoptions = sessionoptions
    endtry
endfunction

function! bg_sessions#SaveSession(sessionName)
    call s:SaveSessionImpl(a:sessionName)
endfunction

function! bg_sessions#SaveLastSession()
    if exists("g:bg_sessions_dir")
        call s:SaveSessionImpl("")
    endif
endfunction

function! bg_sessions#SaveCurrentSession()
    if !exists("g:SessionLoad") && exists("g:bg_sessions_current") && strlen("g:bg_sessions_current") > 0
        let latest_session_name = g:bg_sessions_current . "_latest"
        call s:SaveSessionImpl(latest_session_name)
    endif
endfunction

function! bg_sessions#LoadSession(sessionName)
    if strlen(a:sessionName)
        execute "source " . s:GetSessionPath(a:sessionName)
        let g:bg_sessions_current = substitute(a:sessionName, "_latest$", "", "")
    else
        if exists("g:bg_sessions_current")
            unlet g:bg_sessions_current
        endif
        execute "source " . s:GetSessionPath("last")
    endif
endfunction

function! bg_sessions#Sessions()
    echo join(s:GetSessionNamesWithTimes(), "\n")
endfunction

function! bg_sessions#CurrentSession()
    if exists("g:bg_sessions_current")
        echo g:bg_sessions_current
    else
        echo "No current session"
    endif
endfunction

function! bg_sessions#SessionComplete(ArgLead, CmdLine, CursorPos)
    let match_filter = 'v:val =~ ".*' . a:ArgLead . '.*"'
    return filter(s:GetSessionNames(), match_filter)
endfunction

function! bg_sessions#DeleteSession(sessionName)
    let file_path = fnamemodify(s:GetSessionPath(a:sessionName), ":p")
    let rm_cmd = has("win32") || has("win16") ? "!del " : "!rm "

    if has("win32") || has("win16")
        let file_path = fnamemodify(file_path, ":gs?/?\\?")
    endif

    if strlen(a:sessionName)
        execute rm_cmd . file_path
    endif
endfunction

function! bg_sessions#SetupSaveLastSession()
    augroup bg_sessions_init
        autocmd!
    augroup END

    augroup bg_sessions
        autocmd BufEnter,VimLeave * call bg_sessions#SaveLastSession()
    augroup END
endfunction
