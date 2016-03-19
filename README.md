# .vim-bg-sessions
Vim plugin for saving and loading sessions

## Commands

### Sessions
Lists all saved sessions.

### SaveSession [session_name]
Saves your current sessions. If `session_name` is provided, a session will be saved with that name. Otherwise, the session will be saved with the name of "last".

When saving a named session, the "last" session is also updated.

### LoadSession [session_name]
Loads a session. If `session_name` is provided, the session by that name will be loaded. Otherwise, the session named "last" will be loaded.

### DeleteSession session_name
Deletes the session named `session_name`.

## Options

### Saved Session Directory
Session files are stored in the directory provided by the global variable `g:bg_sessions_dir` which is set to "~/.vim-sessions" by default.

## Other
This plugin creates an autocommand on `VimLeave` to save the current session to the "last" session (e.g. "~/.vim-sessions/last.vim") when exiting Vim.
