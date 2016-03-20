if !exists("g:bg_sessions_dir")
    let g:bg_sessions_dir = "~/.vim-sessions"
endif

let g:bg_sessions_loading = 0

function! s:GetSessionPath(sessionName)
    return g:bg_sessions_dir . "/" . a:sessionName . ".vim"
endfunction

function! s:GetSessionFiles()
    return split(globpath(g:bg_sessions_dir, '*'), '\n')
endfunction

function! s:GetSessionNames()
    return map(s:GetSessionFiles(), "fnamemodify(v:val, ':t:r')")
endfunction

function! bg_sessions#SaveSession(sessionName)
    let sessionoptions = &sessionoptions
    try
        set sessionoptions-=blank sessionoptions-=options sessionoptions+=tabpages
        if strlen(a:sessionName)
            execute "mksession! " . s:GetSessionPath(a:sessionName) 
        endif
        execute "mksession! " . s:GetSessionPath("last")
    finally
        let &sessionoptions = sessionoptions
    endtry
endfunction

function! bg_sessions#SaveCurrentSession()
    if g:bg_sessions_loading == 1
        let g:bg_sessions_loading = 0 
    elseif exists("g:bg_sessions_current")
        let latest_session_name = g:bg_sessions_current . "_latest"
        bg_sessions#SaveSession(latest_session_name)
    endif
endfunction

function! bg_sessions#LoadSession(sessionName)
    if strlen(a:sessionName)
        let g:bg_sessions_current = a:sessionName
        let g:bg_sessions_loading = 1
        execute "source " . s:GetSessionPath(a:sessionName)
    else
        unlet g:bg_sessions_current
        let g:bg_sessions_loading = 0
        execute "source " . s:GetSessionPath("last")
    endif
endfunction

function! bg_sessions#Sessions()
    echo join(s:GetSessionNames(), "\n")
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

augroup bg_sessions
    autocmd!
    autocmd BufEnter * call bg_sessions#SaveCurrentSession()
augroup END
