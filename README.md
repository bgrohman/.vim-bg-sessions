# vim-bg-sessions
Vim plugin for saving and loading sessions

## Features
1. Save and load sessions by name.
2. Tab autocompletion of session names when saving or loading sessions.
3. Automatically save the "latest" version of a named session while keeping the original session intact.
4. Delete sessions by name.
5. Automatically save the "last" session whenever you quit Vim.

## Installation
Install vim-bg-sessions like you would any other Vim plugin.

For [Pathogen](https://github.com/tpope/vim-pathogen):
```
cd ~/.vim/bundles
git clone https://github.com/bgrohman/vim-bg-sessions.git
```

## Usage

### Commands

#### Sessions
Lists all saved sessions.

#### SaveSession [session_name]
Saves your current sessions. If `session_name` is provided, a session will be saved with that name. Otherwise, the session will be saved with the name of "last".

When saving a named session, the "last" session is also updated.

Use `tab` for session name autocompletion.

__Example:__ _Save a session named "myFirstSession"_
```
:SaveSession myFirstSession
```

#### LoadSession [session_name]
Loads a session. If `session_name` is provided, the session by that name will be loaded. Otherwise, the session named "last" will be loaded. Use `tab` for session name autocompletion.

__Example:__ _Load a session named "myFirstSession"_
```
:LoadSession myFirstSession
```

__Example:__ _Load your last session from the last time you closed Vim_
```
:LoadSession

or

:LoadSession last
```

__Example:__ _Load the "latest" version of a session named "myFirstSession"_

You've saved a session named "myProject" for a particular project, and you want to be able to always return to that session, so you don't re-save it after continuing your work (e.g. opening additional buffers/windows/tabs). But you also want to be able to return to your last state after you loaded that session, including all of the changes since the "myProject" session was loaded. This plugin will automatically save a session named "myProject_latest" any time you enter a new buffer.
```
:LoadSession myFirstSession_latest
```

#### DeleteSession session_name
Deletes the session named `session_name`. Use `tab` for session name autocompletion.

__Example:__ _Delete a session named "myFirstSession"_
```
:DeleteSession myFirstSession
```

### Options

#### Saved Session Directory
Session files are stored in the directory provided by the global variable `g:bg_sessions_dir` which is set to "~/.vim-sessions" by default.
