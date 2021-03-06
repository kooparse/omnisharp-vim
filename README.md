![OmniSharp](logo.png)

# OmniSharp

OmniSharp-vim is a plugin for Vim to provide IDE like abilities for C#.

OmniSharp works on Windows, and on Linux and OS X with Mono.

The plugin relies on the [OmniSharp-Roslyn](https://github.com/OmniSharp/omnisharp-roslyn) server, a .NET development platform used by several editors including Visual Studio Code, Emacs, Atom and others.

## Features

* Contextual code completion
  * Code documentation is displayed in the preview window when available (Xml Documentation for Windows, MonoDoc documentation for Mono)
  * CamelCase completions are supported, e.g Console.WL(TAB) will complete to Console.WriteLine
  * "Subsequence" completions are also supported. e.g. Console.Wline would also complete to Console.WriteLine
  * Completions are ranked in the following order
    * Exact start match (case sensitive)
    * Exact start match (case insensitive)
    * CamelCase completions
    * Subsequence match completions
  * Completion snippets are supported. e.g. Console.WriteLine(TAB) (ENTER) will complete to Console.WriteLine(string value) and expand a dynamic snippet, this will place you in SELECT mode and the first method argument will be selected. 
    * Requires [UltiSnips](https://github.com/SirVer/ultisnips) and supports standard C-x C-o completion, [Supertab](https://github.com/ervandew/supertab) and [Neocomplete](https://github.com/Shougo/neocomplete.vim).
    * Requires `set completeopt-=preview` when using [Neocomplete](https://github.com/Shougo/neocomplete.vim) because of a compatibility issue with [UltiSnips](https://github.com/SirVer/ultisnips). 
    * This functionality requires a recent version of Vim, you can check if your version is supported by running `:echo has("patch-7.3-598")`, it should output 1.

* Jump to the definition of a type/variable/method
* Find types/symbols interactively (requires plugin: [fzf.vim](https://github.com/junegunn/fzf.vim), [CtrlP](https://github.com/ctrlpvim/ctrlp.vim) or [unite.vim](https://github.com/Shougo/unite.vim))
* Find implementations/derived types
* Find usages
* Contextual code actions (sort usings, use var....etc.) (requires plugin: [fzf.vim](https://github.com/junegunn/fzf.vim), [CtrlP](https://github.com/ctrlpvim/ctrlp.vim) or [unite.vim](https://github.com/Shougo/unite.vim))
  * Extract method
* Find and fix code issues (unused usings, use base type where possible....etc.) (requires plugin: [Syntastic](https://github.com/vim-syntastic/syntastic))
* Fix using statements for the current buffer (sort, remove and add any missing using statements where possible)
* Rename refactoring
* Semantic type highlighting
* Lookup type information of an type/variable/method
  * Can be printed to the status line or in the preview window
  * Displays documentation for an entity when using preview window
* Syntax error highlighting
* On the fly semantic error highlighting (nearly as good as a full compilation!)
* Integrated xbuild/msbuild (can run asynchronously if supported)
* Code formatter
* Add currently edited file to the nearest project (currently will only add .cs files to a .csproj file)

```vim
:OmniSharpAddToProject
```

* Add reference. Supports project and file reference. GAC referencing todo.

```vim
:OmniSharpAddReference path_to_reference
```

* [Test runner](https://github.com/OmniSharp/omnisharp-vim/wiki/Test-Runner)

## Screenshots
#### Auto Complete
![OmniSharp screenshot](https://f.cloud.github.com/assets/667194/514371/dc03e2bc-be56-11e2-9745-c3202335e5ab.png)

#### Find (and fix) Code Issues
![Code issues screenshot](https://raw.github.com/OmniSharp/omnisharp-vim/gh-pages/codeissues.png)

#### Find Types / Symbols
![Find Types screenshot](https://raw.github.com/OmniSharp/omnisharp-vim/gh-pages/FindTypes.png)

#### Find Usages
![Find Usages screenshot](https://raw.github.com/OmniSharp/omnisharp-vim/gh-pages/FindUsages.png)

#### Code Actions
![Code Actions screenshot](https://raw.github.com/OmniSharp/omnisharp-vim/gh-pages/CodeActions.png)

## Installation
### Plugin
Install the vim plugin using your preferred plugin manager:

| Plugin Manager                                       | Command                                                                              |
|------------------------------------------------------|--------------------------------------------------------------------------------------|
| [Vim-plug](https://github.com/junegunn/vim-plug)     | `Plug 'OmniSharp/omnisharp-vim'`                                                     |
| [Vundle](https://github.com/gmarik/vundle)           | `Bundle 'OmniSharp/omnisharp-vim'`                                                   |
| [NeoBundle](https://github.com/Shougo/neobundle.vim) | `NeoBundle 'OmniSharp/omnisharp-vim'`                                                |
| [Pathogen](https://github.com/tpope/vim-pathogen)    | `git clone git://github.com/OmniSharp/omnisharp-vim.git ~/.vim/bundle/omnisharp-vim` |

### Server
OmniSharp-vim depends on the [OmniSharp-Roslyn](https://github.com/OmniSharp/omnisharp-roslyn) server. Download the latest release for your platform from the [releases](https://github.com/OmniSharp/omnisharp-roslyn/releases) page. OmniSharp-vim uses http to communicate with the server, so select the http variant for your architecture. This means that for a 64-bit Windows system, the `omnisharp.http-win-x64.zip` package should be downloaded, whereas Mac users should select `omnisharp.http-osx.tar.gz`.

Extract the binaries and configure your vimrc with the path to the `OmniSharp.exe` file, e.g.:

```vim
let g:OmniSharp_server_path = 'C:\OmniSharp\omnisharp.http-win-x64\OmniSharp.exe'
```
```vim
let g:OmniSharp_server_path = '/home/me/omnisharp/omnisharp.http-linux-x64/omnisharp/OmniSharp.exe'
```

#### Cygwin and WSL
Windows users who wish to use OmniSharp-vim in a Cygwin or Windows Subsystem for Linux terminal vim, download the *Windows* OmniSharp-Rosyn release. Configure your vimrc to point to the `OmniSharp.exe` file, and let OmniSharp-vim know that you are operating in Cygwin/WSL mode (indicating that file paths need to be translated by OmniSharp-vim from Unix-Windows and back:

```vim
let g:OmniSharp_server_path = '/mnt/c/OmniSharp/omnisharp.http-win-x64/OmniSharp.exe'
let g:OmniSharp_translate_cygwin_wsl = 1
```

### Mono
OmniSharp-Roslyn requires Mono on Linux and OSX. The roslyn server [releases](https://github.com/OmniSharp/omnisharp-roslyn/releases) usually come with an embedded Mono, but this can be overridden to use the installed Mono by setting `g:OmniSharp_server_use_mono` in your vimrc. See [The Mono Project](https://www.mono-project.com/download/stable/) for installation details.

```vim
    let g:OmniSharp_server_use_mono = 1
```

### Install Python
Install last version of 2.7 series ([Python 2.7.14](https://www.python.org/downloads/release/python-2714/) at the time of this writing). Make sure that you pick correct version of Python to match the architecture of Vim.
For example, if you installed Vim using the default Windows installer, you will need to install the x86 (32 bit!) version of Python.

Verify that Python is working inside Vim with

```vim
:echo has('python')
```

### Asynchronous command execution
OmniSharp-vim can start the server and run asynchronous builds only if any of the following criteria is met:

* Vim with job control API is used (8.0+)
* [neovim](https://neovim.io) with job control API is used
* [vim-dispatch](https://github.com/tpope/vim-dispatch) is installed
* [vimproc.vim](https://github.com/Shougo/vimproc.vim) is installed

### (optional) Install syntastic
The vim plugin [syntastic](https://github.com/vim-syntastic/syntastic) is needed for displaying code issues and syntax errors.

### (optional) Install ctrlp.vim, unite.vim or fzf.vim
If you want to use the Code Actions, Find Type and Find Symbol features, you will need to install one of the following plugins:

- [fzf.vim](https://github.com/junegunn/fzf.vim)
- [CtrlP](https://github.com/ctrlpvim/ctrlp.vim)
- [unite.vim](https://github.com/Shougo/unite.vim)

If you have installed more than one, you can choose one by `g:OmniSharp_selector_ui` variable.

```vim
let g:OmniSharp_selector_ui = 'unite'  " Use unite.vim
let g:OmniSharp_selector_ui = 'ctrlp'  " Use ctrlp.vim
let g:OmniSharp_selector_ui = 'fzf'    " Use fzf.vim
```

## How to use
By default, the server is started automatically if you have vim-dispatch installed when you open a .cs file.
It tries to detect your solution file (.sln) and starts the OmniSharp server passing the path to the solution file.

If you are using tmux, the server will start in a new tmux session. In iterm2, a new tab is opened. Windows starts the server with a minimised cmd shell. For any other configuration, the server will start invisibly in the background.

This behaviour can be disabled by setting `let g:Omnisharp_start_server = 0` in your vimrc. You can then start the server manually from within vim with `:OmniSharpStartServer`. Alternatively, the server can be manually started from outside vim:

```sh
[mono] OmniSharp.exe -p (portnumber) -s (path/to/sln)
```

Add `-v Verbose` to get extra information from the server.


When vim is closed and the OmniSharp server is running, vim will ask you if you want to stop the OmniSharp server.
This behaviour can be altered with the `g:Omnisharp_stop_server` variable in your vimrc:

```vim
let g:Omnisharp_stop_server = 0  " Do not stop the server on exit
let g:Omnisharp_stop_server = 1  " Ask whether to stop the server
let g:Omnisharp_stop_server = 2  " Automatically stop the server
```

OmniSharp listens to requests from Vim on port 2000 by default, so make sure that your firewall is configured to accept requests from localhost on this port.

To get completions, open a C# file from your solution within Vim and press `<C-x><C-o>` (that is ctrl x followed by ctrl o) in Insert mode, or use an autocompletion plugin.

To use the other features, you'll want to create key bindings for them. See the example vimrc below for more info.

### Using with the legacy server

Using the OmniSharp-Roslyn server is recommended, as this server is actively maintained and developed. However, if you wish to use the original [OmniSharp server](https://github.com/OmniSharp/omnisharp-server), follow the installation instructions in the server's git repo, then specify the server type in your vimrc:

```vim
let g:OmniSharp_server_type = 'v1'

" The legacy server uses different syntastic checkers to roslyn
let g:syntastic_cs_checkers = ['syntax', 'semantic', 'issues']
```

### Other useful tools

- [grunt-init-csharpsolution](https://github.com/nosami/grunt-init-csharpsolution) Useful for quickly creating a C# solution with a couple of projects. Easily adaptable.
![screenshot](https://raw.githubusercontent.com/nosami/nosami.github.io/master/grunt-init-csharpsolution.gif)
- [WarmUp](https://github.com/chucknorris/warmup/issues) Same as above, but it didn't work for me on OSX when I tried.
- [OpenIDE](https://github.com/continuoustests/OpenIDE) Lots of uses. I use it for creating new project files and generating classes with the namespace and class pre-populated. It's very extensible.
- [OrangeT/vim-csharp](https://github.com/OrangeT/vim-csharp) Advanced syntax highlighting including razor support. Contains snippets for Razor, Xunit and Moq.
- [devtools-terminal](http://blog.dfilimonov.com/2013/09/12/devtools-terminal.html) Embed OmniSharp inside Chrome
![dev-tools screenshot](https://raw.githubusercontent.com/nosami/nosami.github.io/master/aspvnext.gif)

## Configuration

### Example vimrc

```vim
" OmniSharp won't work without this setting
filetype plugin on

" Choose the OmniSharp-Roslyn server - this is the default
let g:OmniSharp_server_type = 'roslyn'

" Set the path to the roslyn server
let g:OmniSharp_server_path = '/home/me/omnisharp/omnisharp.http-linux-x64/omnisharp/OmniSharp.exe'

" This is the default value, setting it isn't actually necessary
let g:OmniSharp_host = "http://localhost:2000"

" Set the type lookup function to use the preview window instead of echoing it
"let g:OmniSharp_typeLookupInPreview = 1

" Timeout in seconds to wait for a response from the server
let g:OmniSharp_timeout = 1

" Don't autoselect first omnicomplete option, show options even if there is only
" one (so the preview documentation is accessible). Remove 'preview' if you
" don't want to see any documentation whatsoever.
set completeopt=longest,menuone,preview
" Fetch full documentation during omnicomplete requests.
" There is a performance penalty with this (especially on Mono).
" By default, only Type/Method signatures are fetched. Full documentation can
" still be fetched when you need it with the :OmniSharpDocumentation command.
"let g:omnicomplete_fetch_full_documentation = 1

" Set desired preview window height for viewing documentation.
" You might also want to look at the echodoc plugin.
set previewheight=5

" Get code issues and syntax errors
let g:syntastic_cs_checkers = ['code_checker']

augroup omnisharp_commands
    autocmd!

    " Synchronous build (blocks Vim)
    "autocmd FileType cs nnoremap <buffer> <F5> :wa!<CR>:OmniSharpBuild<CR>
    " Builds can also run asynchronously with vim-dispatch installed
    autocmd FileType cs nnoremap <buffer> <Leader>b :wa!<CR>:OmniSharpBuildAsync<CR>
    " Automatic syntax check on events (TextChanged requires Vim 7.4)
    autocmd BufEnter,TextChanged,InsertLeave *.cs SyntasticCheck

    " Automatically add new cs files to the nearest project on save
    autocmd BufWritePost *.cs call OmniSharp#AddToProject()

    " Show type information automatically when the cursor stops moving
    autocmd CursorHold *.cs call OmniSharp#TypeLookupWithoutDocumentation()

    " The following commands are contextual, based on the cursor position.
    autocmd FileType cs nnoremap <buffer> gd :OmniSharpGotoDefinition<CR>
    autocmd FileType cs nnoremap <buffer> <Leader>fi :OmniSharpFindImplementations<CR>
    autocmd FileType cs nnoremap <buffer> <Leader>ft :OmniSharpFindType<CR>
    autocmd FileType cs nnoremap <buffer> <Leader>fs :OmniSharpFindSymbol<CR>
    autocmd FileType cs nnoremap <buffer> <Leader>fu :OmniSharpFindUsages<CR>

    " Finds members in the current buffer
    autocmd FileType cs nnoremap <buffer> <Leader>fm :OmniSharpFindMembers<CR>

    " Cursor can be anywhere on the line containing an issue
    autocmd FileType cs nnoremap <buffer> <Leader>x  :OmniSharpFixIssue<CR>
    autocmd FileType cs nnoremap <buffer> <Leader>fx :OmniSharpFixUsings<CR>
    autocmd FileType cs nnoremap <buffer> <Leader>tt :OmniSharpTypeLookup<CR>
    autocmd FileType cs nnoremap <buffer> <Leader>dc :OmniSharpDocumentation<CR>

    " Navigate up and down by method/property/field
    autocmd FileType cs nnoremap <buffer> <C-k> :OmniSharpNavigateUp<CR>
    autocmd FileType cs nnoremap <buffer> <C-j> :OmniSharpNavigateDown<CR>
augroup END

" Contextual code actions (requires fzf, CtrlP or unite.vim)
nnoremap <Leader><Space> :OmniSharpGetCodeActions<CR>
" Run code actions with text selected in visual mode to extract method
xnoremap <Leader><Space> :call OmniSharp#GetCodeActions('visual')<CR>

" Rename with dialog
nnoremap <Leader>nm :OmniSharpRename<CR>
nnoremap <F2> :OmniSharpRename<CR>
" Rename without dialog - with cursor on the symbol to rename: `:Rename newname`
command! -nargs=1 Rename :call OmniSharp#RenameTo("<args>")

" Force OmniSharp to reload the solution. Useful when switching branches etc.
nnoremap <Leader>rl :OmniSharpReloadSolution<CR>
nnoremap <Leader>cf :OmniSharpCodeFormat<CR>
" Load the current .cs file to the nearest project
nnoremap <Leader>tp :OmniSharpAddToProject<CR>

" Start the omnisharp server for the current solution
nnoremap <Leader>ss :OmniSharpStartServer<CR>
nnoremap <Leader>sp :OmniSharpStopServer<CR>

" Add syntax highlighting for types and interfaces
nnoremap <Leader>th :OmniSharpHighlightTypes<CR>

" Enable snippet completion, requires completeopt-=preview
let g:OmniSharp_want_snippet=1
```

Pull requests welcome!
