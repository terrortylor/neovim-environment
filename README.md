# Table of contents

1. [Installation](#installation)
   1. [Checking out the repository](#checking-out-the-repository)
   1. [Setting up symlinks](#setting-up-symlinks)
1. [Mappings and Commands](#mappings-and-commands)
   1. [init.vim](#initvim)
   1. [ftplugin/chef.vim](#ftpluginchefvim)
   1. [ftplugin/vim.vim](#ftpluginvimvim)
1. [Plugins](#plugins)
   1. [Third Party Plugins](#third-party-plugins)
   1. [Custom Plugins](#custom-plugins)
      1. [pluginman](#pluginman)
      1. [autodoc](#autodoc)
      1. [focus](#focus)
      1. [gittools](#gittools)
      1. [helper library](#helper-library)
      1. [quickfix](#quickfix)
      1. [scratch](#scratch)
      1. [share](#share)
      1. [statusline](#statusline)
      1. [terminal](#terminal)
      1. [websearch](#websearch)
      1. [textobjects](#textobjects)
   1. [File Type Plugins](#file-type-plugins)
      1. [markdown](#markdown)
      1. [ftplugin/markdown/toc.vim](#ftpluginmarkdowntocvim)
      1. [chef](#chef)
      1. [note](#note)
      1. [go](#go)
      1. [help files (built in)](#help-files-built-in)
1. [Custom Functions / Commands](#custom-functions--commands)
1. [TabbedQuicklist](#tabbedquicklist)
1. [Noteworthy](#noteworthy)
<!--- end of toc -->

# (Neo)Vim config

This repository contains my vim-environment (well NeoVim), note that whilst
most of this should be compatible with vim it's not expected to be. There are
likely issues with some of my custom plugins that have only been tested in
NeoVim (my terminal/repl) plugin for example is a likely candidate.

Feel free to copy/clone although I'd always suggest reading the `init.vim` file
instead and adapt to fit your own work flow as this is a constantly evolving configuration.

## Installation

### Checking out the repository

```bash
git clone https://github.com/terrortylor/vim-environment.git
```

### Setting up symlinks

Neovim follows the [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html), so this repository needs to be located: ~/.config/nvim

I have an ansible project for managing environment/dotfiles although often I'll just want to set this up on a target quickly so a separate repository lends it self to that use-case. My [ansible project can be found here](https://github.com/terrortylor/ansible_dev_machine_setup).

## Mappings and Commands

There are quite a few mappings, these are split across a number of files so I
wrote a tool that uses the comments above a mapping to document these into a
table. They are printed in the order they appear.

### init.vim
<!-- start autodocumentation block init.vim mappings -->
| Mapmode | Mapping | Action | Description |
| ------- | ------- | -------| ----------- |
| nnoremap | gf  | :vertical wincmd f\<CR> | `gf` opens file under cursor in a new vertical split   See this page on notes on autochdir: https://gist.github.com/csswizardry/9a33342dace4786a9fee35c73fa5deeb |
| nnoremap | \<leader>/  | :set hlsearch!\<CR> | toggle highlighting |
| nnoremap | \<leader>rw  | :%s/\<c-r>\<c-w>//\<left> | Search and replace word under cursor within buffer |
| vnoremap | \<leader>rw  | :s/\<c-r>"//\<left> | Search and replace visual selection.   When in visual mode the selection delimiters are added automatically |
| nmap | \<leader>ce  | \<Plug>(QuicklistCreateEditableBuffer) |  |
| nmap | \<leader>cs  | \<Plug>(QuickfixCreateFromBuffer) |  |
| nmap | \<leader>ca  | \<Plug>(QuickfixApplyLineChanges) |  |
| nnoremap | [C  | :colder\<cr> |  |
| nnoremap | ]C  | :cnewer\<cr> |  |
| nnoremap | \<leader>fb  | :FindInBuffer | Custom global search within buffer, displays results in location list   just clears it self |
| vnoremap | \<leader>fb  | y:FindInBuffer \<c-r>" | Custom global search within buffer using selection, displays results in location list |
| vnoremap | \<leader>ftp  | y:Grep \<c-r>" | Custom Grep (tabbed view) for selection within current directory, path can   be added |
| nnoremap | \<leader>ftp  | :Grep | Custom Grep (tabbed view) within current directory, path can   be added |
| vnoremap | \<leader>fp  | y:SimpleGrep \<c-r>" | Custom Grep for selection within current directory with standard quickfix   window, path can be added |
| nnoremap | \<leader>fp  | y:SimpleGrep | Custom Grep within current directory with standard quickfix   window, path can be added |
| nnoremap | \<leader>tt  | :\<C-u>call NerdToggleFind()\<CR> | Toggle NERDTree using custom toggle func |
| nnoremap | \<leader>\<space>  |  :\<C-u>CtrlPBuffer\<CR> | Fuzzy find open buffers |
| nnoremap | \<leader>ff  |  :\<C-u>CtrlPFunky\<CR> | Fuzzy find functions in project |
| nnoremap | \<leader>fm  |  :\<C-u>CtrlPMarks\<CR> | Fuzzy find and jump to marks |
| nnoremap | \<leader>fr  |  :\<C-u>CtrlPRegister\<CR> | Fuzy find and insert contents of register |
| nnoremap | \<leader>fu  |  :\<C-u>CtrlPUltisnips\<CR> | Fuzzy find and start Ultisnips snippet |
| nnoremap | \<leader>ue  | :UltiSnipsEdit\<CR>:set filetype=snippets\<CR> |  |
| inoremap | \<expr>  | \<cr> pumvisible() ? "\\<C-y>" : "\\<C-g>u\\<CR>" | Use '<CR>' for completion select |
| inoremap | \<silent>\<expr>  | \<c-space> coc#refresh() | Use <c-space> to trigger completion. |
| nmap | \<silent> [g  | \<Plug>(coc-diagnostic-prev) | Use `[g` and `]g` to navigate diagnostics |
| nmap | \<silent> ]g  | \<Plug>(coc-diagnostic-next) |  |
| nmap | \<silent> gd  | \<Plug>(coc-definition) | Remap keys for gotos |
| nmap | \<silent> gy  | \<Plug>(coc-type-definition) |  |
| nmap | \<silent> gr  | \<Plug>(coc-references) | conflicts with  built in 'gi'     nmap <silent> gi <Plug>(coc-implementation) |
| nnoremap | \<silent> K  | :call \<SID>show_documentation()\<CR> | Use K to show documentation in preview window |
| nmap | \<leader>rn  | \<Plug>(coc-rename) | Remap for rename current word |
| xmap | if  | \<Plug>(coc-funcobj-i) | Create mappings for function text object, requires document symbols feature of languageserver.     NOTE: these may be overridden in ftplugin files, i.e. vim overrides af |
| xmap | af  | \<Plug>(coc-funcobj-a) |  |
| omap | if  | \<Plug>(coc-funcobj-i) |  |
| omap | af  | \<Plug>(coc-funcobj-a) |  |
| nnoremap | \<silent> \<leader>ld  |  :\<C-u>CocList diagnostics\<cr> | TODO now started to use space as leader review these     Using CocList     Show all diagnostics |
| nnoremap | \<silent> \<leader>le  |  :\<C-u>CocList extensions\<cr> | Manage extensions |
| nnoremap | \<silent> \<leader>lc  |  :\<C-u>CocList commands\<cr> | Show commands |
| nnoremap | \<silent> \<leader>lo  |  :\<C-u>CocList outline\<cr> | Find symbol of current document |
| nnoremap | \<silent> \<leader>ls  |  :\<C-u>CocList -I symbols\<cr> | Search workspace symbols |
| nnoremap | \<silent> \<leader>j  |  :\<C-u>CocNext\<CR> | Do default action for next item. |
| nnoremap | \<silent> \<leader>k  |  :\<C-u>CocPrev\<CR> | Do default action for previous item. |
| nnoremap | \<silent> \<leader>p  |  :\<C-u>CocListResume\<CR> | Resume latest coc list |
| nnoremap | \<leader>h1  | :HighlightLine hlYellow\<cr> |  |
| vnoremap | \<leader>h1  | :'\<,'>HighlightLine hlYellow\<cr> |  |
| nnoremap | \<leader>h2  | :HighlightLine hlDarkBlue\<cr> |  |
| vnoremap | \<leader>h2  | :'\<,'>HighlightLine hlDarkBlue\<cr> |  |
| nnoremap | \<leader>hr  | :RemoveHighlighting\<cr> |  |
| vnoremap | \<leader>hr  | :'\<,'>RemoveHighlighting\<cr> |  |
| nnoremap | \<silent> \<c-h>  | :TmuxNavigateLeft\<cr> |  |
| nnoremap | \<silent> \<c-j>  | :TmuxNavigateDown\<cr> |  |
| nnoremap | \<silent> \<c-k>  | :TmuxNavigateUp\<cr> |  |
| nnoremap | \<silent> \<c-l>  | :TmuxNavigateRight\<cr> |  |
| nnoremap | \<leader>rr  | :\<C-u>TerminalReplFile\<cr> | Run buffer in REPL |
| nnoremap | \<leader>tr  | :\<C-u>TerminalReplFileToggle\<cr> | Toggle REPL Terminal |
| nnoremap | \<leader>lg  | :call helper#float#SingleUseTerminal('lazygit')\<CR> | Open lazy git in throw away popup window   TODO problem about this is it uses <space> to stage/unstage a file which   is leader so either pause, or hit <CR> but that goes into stage view so   haev to hit <ESC>   SEE HERE: https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md   Mapping file needs to be persisted to ansible |
| nnoremap | \<leader>+  | :vertical resize +10\<CR> | See: https://vim.fandom.com/wiki/Resize_splits_more_quickly   Increase/Decrease vertical windows |
| nnoremap | \<leader>-  | :vertical resize -10\<CR> |  |
| nnoremap | [T  |  :tabfirst\<CR>        " moves to first tab | easier tab navigation |
| nnoremap | ]t  |  :tabnext\<CR>         " moves to next tab |  |
| nnoremap | [t  |  :tabprev\<CR>         " moves to previous tab |  |
| nnoremap | ]T  |  :tablast\<CR>         " moves to last tab |  |
| nnoremap | \<leader>1  | 1gt\<CR>        " moves to tab 1 |  |
| nnoremap | \<leader>2  | 2gt\<CR>        " moves to tab 2 |  |
| nnoremap | \<leader>3  | 3gt\<CR>        " moves to tab 3 |  |
| nnoremap | \<leader>4  | 4gt\<CR>        " moves to tab 4 |  |
| nnoremap | \<leader>5  | 5gt\<CR>        " moves to tab 5 |  |
| nnoremap | \<leader>6  | 6gt\<CR>        " moves to tab 6 |  |
| nnoremap | \<leader>7  | 7gt\<CR>        " moves to tab 7 |  |
| nnoremap | \<leader>8  | 8gt\<CR>        " moves to tab 8 |  |
| nnoremap | \<leader>9  | 9gt\<CR>        " moves to tab 9 |  |
| nnoremap | \<leader>tc  | :tabclose\<CR> " closes current tab |  |
| nnoremap | \<leader>tn  | :tabnew\<CR>   " opens a tab |  |
| nnoremap | \<leader>cl  | :call quickfix#window#OpenList()\<CR> | Opens first non empty list, location list is local to window |
| nnoremap | \<leader>cc  | :call quickfix#window#CloseAll()\<CR> | Close all quicklist windows |
| nnoremap | ]c  | :cnext\<CR> | To quickly go through the Quicklist |
| nnoremap | [c  | :cprevious\<CR> |  |
| nnoremap | [b  | :bprevious\<CR> |  |
| nnoremap | ]b  | :bnext\<CR> |  |
| nnoremap | \<leader>bd  | :bdelete\<CR> |  |
| nnoremap | \<leader>a  | \<c-^> | easier switching to alternate/last buffer |
| nnoremap | \<c-y>  | 5\<c-y> | Make <c-e> & <c-y> a bit more useable |
| nnoremap | \<c-e>  | 5\<c-e> |  |
| nnoremap | \<leader>wc  | :close\<CR> |  |
| noremap | \<Leader>Y  | "*y | These apply for all modes |
| noremap | \<Leader>P  | "*p |  |
| noremap | \<Leader>y  | "+y |  |
| noremap | \<Leader>p  | "+p |  |
| nnoremap | cdq  | mp0f"r';.\`p | Replace first pair of double quotes on line with single   return back to cursor location |
| nnoremap | csq  | mp0f'r";.\`p |  |
| nnoremap | \<leader>o  | :call NewLineNoComment(v:true)\<cr> | insert a line above or below, and exit back to normal, this does not   continue a comment block |
| nnoremap | \<leader>O  | :call NewLineNoComment(v:false)\<cr> |  |
| vnoremap | \<  | \<gv |  |
| vnoremap | >  | >gv |  |
| nnoremap | \<leader>=  | Vap= | Format current paragraph |
| nnoremap | \<leader>q  | @q |  |
| inoremap | \<c-e>  | \<esc>A | In insert more move using readline line start/end |
| inoremap | \<c-a>  | \<esc>I |  |
| nnoremap | \<silent>\<leader>ev  | :vsplit $MYVIMRC\<cr> | Open vimrc in vertical split |
| nnoremap | \<leader>zz  | 1z= | Auto selects the first spelling suggestion for current word |
| nnoremap | \<leader>ws  | :w \<bar> source %\<CR> |  |
| nnoremap | \<leader>mm  | \`m | 'm' is my default quick mark, so this is quick jump mark 'm' to save my   pinky :P |
| tnoremap | \<leader>\<Esc>  | \<C-\>\<C-n> |  |
| tnoremap | \<leader>jj  | \<C-\>\<C-n> |  |
| nnoremap | \<leader>tc  | :set ignorecase!\<cr> |  |
| inoremap | jj  | \<ESC>:w\<cr> | exit insert mode and save buffer |
| nnoremap | gp  | \`[v\`] | Select last pasted text |
| xnoremap | \<leader>pro  | :\<c-u>call Prototype()\<CR> | This function copies visual selection   pastes it below and comments out original   leaving cursor in first line on copied selection   It has a dependency on vim-commentary plugin |
| nnoremap | \<silent> \<leader>mp  | :\<C-u>call MakePretty(visualmode())\<CR> |  |
| vnoremap | \<silent> \<leader>mp  | :\<C-u>call MakePretty(visualmode())\<Cr> |  |

<!-- end  autodocumentation block init.vim mappings -->

### ftplugin/chef.vim
<!-- start autodocumentation block ftplugin/chef.vim mappings -->
| Mapmode | Mapping | Action | Description |
| ------- | ------- | -------| ----------- |
| nnoremap | gf  | :wincmd f\<CR> | the nvim ruby ftplugin overrides gf: /usr/share/nvim/runtime/ftplugin/ruby.vim so override it here |

<!-- end  autodocumentation block ftplugin/chef.vim mappings -->

### ftplugin/vim.vim
<!-- start autodocumentation block ftplugin/vim.vim mappings -->
| Mapmode | Mapping | Action | Description |
| ------- | ------- | -------| ----------- |
| onoremap | af  | :\<c-u>execute "normal! ?^function\rv/^endfunction\r$"\<cr> | Highlights function block |
| xnoremap | af  | ?^function\<cr>o/^endfunction\<cr>$ |  |
| xnoremap | \<leader>ev  | yoechom '": ' . " | echo's selection on line bellow |
| nnoremap | gd  | \<c-]> | Add consistency using gd over ctrl-] NOTE this also overrides COC's mapping |

<!-- end  autodocumentation block ftplugin/vim.vim mappings -->

## Plugins

I use a custom basic plugin that's checks out a third party plugin into the
expected native package manager's location.

This can be found in `autoload/pluginman.vim`, see below for more details

### Third Party Plugins

The following is a list of the third party plugins used, key bindings are as
defined in the plugins help unless otherwise stated below:


TODO Add additional column to state if loaded on start or optional
| Plugin | Description | Notes |
| ------ | ----------- | ----- |
| [vim sneak](https://github.com/justinmk/vim-sneak) | A tool for quickly jumping to a location within a buffer | `t` has been remapped to `<leader>s` |
| [ctrlp](https://github.com/ctrlpvim/ctrlp.vim) | A fuzzy finder | Buffer list mapped to `<leader><space>` |
| [ctrlp-funky](https://github.com/tacahiroy/ctrlp-funky) | Populates ctrlp window with buffers functions |
| [nerdtree](https://github.com/scrooloose/nerdtree.git) | A draw file explorer, a bloated replacement to built in netrw | |
| [vim-commentary](https://github.com/tpope/vim-commentary) | Toggle comments on lines and blocks for various langugages | |
| [vim-sandwich](https://github.com/machakann/vim-sandwich.git) | Adds a set of operators and text objects for handling surroundings | This clashed with `vim-sneak` mapping of `s` so remapped `vim-sneak` |
| [tabular](https://github.com/godlygeek/tabular.git) | Used to line up text quickly/easily | |
| [lightline.vim](https://github.com/itchyny/lightline.vim.git) | A status bar plugin | |
| [vim-color-xcode](https://github.com/arzg/vim-colors-xcode) | xcode insprired colour scheme |
| [tender.vim](https://github.com/jacoborus/tender.vim.git) | Colour scheme | |
| [vim-togglesmartsearch](https://github.com/terrortylor/vim-togglesmartsearch.git) | A noddy plugin I made to try out making a plugin | This is utterly not needed... I should delete it really |
| [vim-highlight](https://github.com/terrortylor/vim-highlight.git) | Adds ability to highlight lines in a buffer, not saved on exit |
| [vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator.git) | Used for easy navigation across vim windows and tmux windows | |
| [coc](https://github.com/neoclide/coc.nvim.git) | Used to add LSP, linting and auto-popup completion support | I'm not 100% on weather this should be kept or not |
| [vim-go](https://github.com/fatih/vim-go) | Go plugin that provides many IDE features, it's awesome |
| [ultisnips](https://github.com/SirVer/ultisnips.git) | A snippet engine | Snippets live under `nvim\config\ultisnips` |
| [kotlin-vim](https://github.com/udalov/kotlin-vim.git) | Adds some kotlin syntax support etc | Using this until NeoVim handles this it self |
| [vim-gutentags](https://github.com/ludovicchabant/vim-gutentags) | Manages ctag creation/management in the background |
| [rainbow_parentheses.vim](https://github.com/junegunn/rainbow_parentheses.vim) | Adds rainbow colouring to parentheses |

### Custom Plugins

These are plugins that I have created for whatever reason, they work as is and
can be found in either `plugin|ftplugin|autoload`.

NOTE: I generally like the workflow of a single tab; using other tabs for
breakaway tasks like searching for text across a project or checking the git
diff output of the current buffer. As such many of the plugins below will open
a new tab so it's easy to jump right back in to coding.

#### pluginman

I was using git submodules but I began to want other features like being able
to run commands after installation. I realised that all that was required was
a plugin that checks if a third party plugin exists and if not check it out.
This is built on top of the native package manager.

#### autodoc

I use this to maintain this rediculous README file, tbh this was more just as
an exercise than anything else and it's very efficient! :P

#### focus

I saw a plugin called [goyo](https://github.com/junegunn/goyo.vim.git) which
is used for 'distraction-free writing in vim'. I thought it was fun and
thought I'd give a go at writing something similar.

* Command: Focus - Opens the current buffer in a new tab, with 'distractions'
  at a minimum

#### gittools

This is a collection of git related commands:

* Command GitDiffFile - Opens a new tab that shows the `git diff` output
* Command GitLogTree - Opens a new tab and shows the `git log` output with
  some syntax highlighting added
* Command GitFileHistoryExplore - Opens up a new tab with three windows: the
  `git log` output for the given buffer, the current buffer and the buffer at
  the selected `git log` revision. Uses vim's `gitdiff` functionality to
  compare the two buffers

This is still very much a work in progress.

#### helper library

This aims to collect useful, commonly used or helper functions to be used in
other plugins. This doesn't contain any mappings or commands.

#### quickfix

This is used to 'tame' the quickfix and location list's when used for
searching ultimately that I find to be my preffered workdflow.

The main workflow change allows you to grep for a value which opens the
quickfix in a new tab and adds some additional mappings so that as you
navigate the list the found entry is displayed in another window. This is
useful for exploring unfamiliar code bases quickly with more context than a
command line grep.

#### scratch

This groups some useful functions to create a 'scratch' buffer, as well as
send things to it quckily without having to jump to it and back again.

#### share

I saw reddit that was asking about sending stuff to a paste bin type external
service, and then a gist was linked, although the gist only handled an entire
buffer. So I created a plugin, using the gist's target services, that can be
used to send either a buffer or a selection. Actually quite useful to date!

#### statusline

You've got to do your own statusline right? This is mine, and I like it. It's
fairly basic and the things that most people like such as a coloured 'mode atom' or showing the current git branch I obviously implemented... But actually don't really like so can turn on and off easily (which is useful for pairing).

#### terminal

I'd put off using vim's terminal emulator until I was looking at a new
language and wanted the ability to compile and run the current buffer easily.
I've heard of such tools that make it easy (vim-dispatch for example) but
thought I'd write a simple plugin to toggle a window that runs the given
buffer. This is still very much a work in progress.

#### websearch

A plugin to run a web search for the word under cursor or the currently
selected block of text. Currently this is mapped to `<leader>gs`.

#### textobjects

This creates a few additional text objects, heavily based of a gist although
trimmed as I didn't require them all. Original gist linked in plugin file.

### File Type Plugins

#### markdown

#### ftplugin/markdown/toc.vim

Create a Table of Contents at the top of a markdown file, if one exists it re-creates it.

<!-- start autodocumentation block ftplugin/markdown/toc.vim commands -->
| Command | Config | Description |
| ------- | -------| ----------- |
| CreateTOC | -nargs=0 | TODO if heading has charecters like /. etc then strip them out for links Adds a markdown style TOC to the top of the markdown file |
| RemoveTOC | -nargs=0 | Removes a markdown style TOC from the top of the markdown file |

<!-- end  autodocumentation block ftplugin/markdown/toc.vim commands -->

#### chef

When working with chef repositories set the path so that `gf` can be used to
jump to cookbooks recipe file when `include_recipe` is used.

Covers:

* include_recipe 'firewall' => firewall/recipes/default.rb
* include_recipe 'firewall::windows' => firewall/recipes/windows.rb

NOTE: This is very dependant on my set-up, adjust accordingly.

#### note

This is a custom file type that is basically a wrapper for markdown...

I have a little script that to [open notes from the command line](https://github.com/terrortylor/ansible_dev_machine_setup/blob/master/roles/terminal/files/bin/notes).
This filetype plugin basically is used to create/update the TOC of the
markdown notes when the buffer is written.

<!-- start autodocumentation block ftplugin/note.vim mappings -->
| Mapmode | Mapping | Action | Description |
| ------- | ------- | -------| ----------- |
| nnoremap | \<leader>mt  | :call MarkAsTodo()\<cr> | Mark todo item as todo |
| nnoremap | \<leader>md  | :call MarkTodoDone()\<cr> | Mark todo item as done |

<!-- end  autodocumentation block ftplugin/note.vim mappings -->

#### go

This is mostly just mappings around vim-go which is a fantastic plugin for go
dev, and in particular a quick TDD cycle

<!-- start autodocumentation block ftplugin/go.vim mappings -->
| Mapmode | Mapping | Action | Description |
| ------- | ------- | -------| ----------- |
| nmap | \<leader>gt  | \<Plug>(go-test) | Run all tests |
| nnoremap | \<leader>gft  | :GoTestFunc\<CR> | Run the test currently in |
| nmap | \<leader>gct  | \<Plug>(go-coverage-toggle) | Toggles test coverage on and off |
| nnoremap | \<leader>gb  | :\<C-u>call \<SID>build_go_files()\<CR> |  |
| nmap | \<leader>gr  | \<Plug>(go-rename) | Rename variable/word |
| nmap | \<leader>ge  | \<Plug>(go-run) | Runs the program, note this is synchronous |
| nnoremap | \<leader>ga  | :\<C-u>GoAlternate!\<CR> | Toggle between file and test file |
| nmap | \<Leader>gfi  | \<Plug>(go-info) | Show function signature and return type on status line |

<!-- end  autodocumentation block ftplugin/go.vim mappings -->
<!-- start autodocumentation block ftplugin/go.vim commands -->
| Command | Config | Description |
| ------- | -------| ----------- |
| GoGenerateInterfaceFromStruct | -nargs=? | Hover over a struct name to generate an interface for given struct The interface value is put in normal register If any argument(s) is passed then it also echom's the generated interface |

<!-- end  autodocumentation block ftplugin/go.vim commands -->

#### help files (built in)

This is a single mapping as I preffer to use `gd` over `<c-]>` for jump to
definition.

<!-- start autodocumentation block ftplugin/help.vim mappings -->
| Mapmode | Mapping | Action | Description |
| ------- | ------- | -------| ----------- |
| nnoremap | gd  | \<c-]> | Add consistency using gd over ctrl-] |

<!-- end  autodocumentation block ftplugin/help.vim mappings -->

## Custom Functions / Commands

So anything else that's note worthy:

 * SynGroup() - Used to print highlight group information based on current
   cursor position

TODO does this still exist?
## TabbedQuicklist
Opens a new tab with the quicklist open and first item selected.


## Noteworthy
Most of these are fairly standard when coming across other peoples `.vimrc`
files on the line; but worth taking a minute to take a look just in case...
* Arrow keys have been disabled in normal mode
* The `<leader>` key is mapped to ` ` (space)
* I prefer spaces to tabs, with an indentation of 2
* On saving a buffer trailing whitespace is removed
* Hybrid line numbering is used, current line shows current line number; lines above and below show movements from current. `<leader>rln` toggles this to normal line numbering
* Buffers are autosaved, when switched between them
* Use of the mouse is disabled
