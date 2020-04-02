# Table of contents

1. [Installation](#installation)
   1. [Checking out the repository](#checking-out-the-repository)
   1. [Setting up symlinks](#setting-up-symlinks)
1. [Mappings](#mappings)
   1. [init.vim](#init.vim)
   1. [ftplugin/chef.vim](#ftplugin/chef.vim)
   1. [ftplugin/vim.vim](#ftplugin/vim.vim)
1. [Plugins](#plugins)
   1. [Third Party Plugins](#third-party-plugins)
   1. [Custom Plugins](#custom-plugins)
      1. [gittools](#gittools)
      1. [websearch](#websearch)
      1. [focus](#focus)
      1. [terminal](#terminal)
   1. [File Type Plugins](#file-type-plugins)
      1. [markdown](#markdown)
      1. [ftplugin/markdown/toc.vim](#ftplugin/markdown/toc.vim)
      1. [ftplugin/markdown/vim_doc_generator.vim](#ftplugin/markdown/vim_doc_generator.vim)
      1. [chef](#chef)
      1. [note](#note)
1. [Custom Functions / Commands](#custom-functions-/-commands)
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

When checking out this project be sure to use the `--recursive` flag
```bash
git clone --recursive https://github.com/terrortylor/vim-environment.git
```

### Setting up symlinks

Neovim follows the [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html), so two directories need to be symlinked:

* nvim/config needs to be pointed at by ~/.config/nvim
* nvim/plugins needs to be pointed at by ~/.local/share/nvim/site/pack/plugins

I have an ansible project for managing environment/dotfiles although often I'll just want to set this up on a target quickly so a separate repository lends it self to that use case. My [ansible project can be found here](https://github.com/terrortylor/ansible_dev_machine_setup).

## Mappings

There are quite a few mappings, these are split across a number of files so I
wrote a tool that uses the comments above a mapping to document these into a
table. They are printed in the order they appear.

### init.vim
<!-- start autodocumentation block init.vim mappings -->
| Mapmode | Mapping | Action | Description |
| ------- | ------- | -------| ----------- |
| nnoremap | \<leader>s  | :set spell!\<CR> | Toggle spell checking |
| nnoremap | gf  | :vertical wincmd f\<CR> | `gf` opens file under cursor in a new vertical split See this page on notes on autochdir: https://gist.github.com/csswizardry/9a33342dace4786a9fee35c73fa5deeb |
| nnoremap | \<leader>rln  | :set relativenumber!\<CR> | toggle relative number |
| nnoremap | \<leader>r  | :%s/\<c-r>\<c-w>//\<left> | Search and replace word under cursor |
| nnoremap | \<leader>/  | :noh\<CR> | turns of highlighting |
| noremap | \<Leader>y  | "*y | Map primary (*) clipboard |
| noremap | \<Leader>p  | "*p |  |
| noremap | \<Leader>Y  | "+y | Map clipboard (+) |
| noremap | \<Leader>P  | "+p |  |
| nnoremap | \<space>f  | :\<C-u>call NerdToggleFind()\<CR> |  |
| nnoremap | \<space>\<space>  |  :\<C-u>CtrlPBuffer\<CR> | Current Buffers |
| nnoremap | \<leader>E  | :Texplore\<CR> | Open new tab in explorer |
| nnoremap | \<leader>ue  | :UltiSnipsEdit\<CR> |  |
| nnoremap | \<leader>ur  | :call UltiSnips#RefreshSnippets()\<CR> |  |
| inoremap | \<silent>\<expr>  | \<TAB> | Use tab for trigger completion with characters ahead and navigate.   Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin. |
| inoremap | \<expr>\<S-TAB>  | pumvisible() ? "\\<C-p>" : "\\<C-h>" |  |
| inoremap | \<silent>\<expr>  | \<c-space> coc#refresh() | Use <c-space> to trigger completion. |
| inoremap | \<expr>  | \<cr> pumvisible() ? "\\<C-y>" : "\\<C-g>u\\<CR>" | Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.   Coc only does snippet and additional edit on confirm. |
| nmap | \<silent> [g  | \<Plug>(coc-diagnostic-prev) | Use `[g` and `]g` to navigate diagnostics |
| nmap | \<silent> ]g  | \<Plug>(coc-diagnostic-next) |  |
| nmap | \<silent> gd  | \<Plug>(coc-definition) | Remap keys for gotos |
| nmap | \<silent> gy  | \<Plug>(coc-type-definition) |  |
| nmap | \<silent> gr  | \<Plug>(coc-references) | conflicts with  built in 'gi'   nmap <silent> gi <Plug>(coc-implementation) |
| nnoremap | \<silent> K  | :call \<SID>show_documentation()\<CR> | Use K to show documentation in preview window |
| nmap | \<leader>rn  | \<Plug>(coc-rename) | Remap for rename current word |
| xmap | \<leader>a  |  \<Plug>(coc-codeaction-selected) | Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph |
| nmap | \<leader>a  |  \<Plug>(coc-codeaction-selected) |  |
| nmap | \<leader>ac  |  \<Plug>(coc-codeaction) | Remap for do codeAction of current line |
| nmap | \<leader>qf  |  \<Plug>(coc-fix-current) | Fix autofix problem of current line |
| xmap | if  | \<Plug>(coc-funcobj-i) | Create mappings for function text object, requires document symbols feature of languageserver. |
| xmap | af  | \<Plug>(coc-funcobj-a) |  |
| omap | if  | \<Plug>(coc-funcobj-i) |  |
| omap | af  | \<Plug>(coc-funcobj-a) |  |
| nnoremap | \<silent> \<space>a  |  :\<C-u>CocList diagnostics\<cr> | Using CocList   Show all diagnostics |
| nnoremap | \<silent> \<space>e  |  :\<C-u>CocList extensions\<cr> | Manage extensions |
| nnoremap | \<silent> \<space>c  |  :\<C-u>CocList commands\<cr> | Show commands |
| nnoremap | \<silent> \<space>o  |  :\<C-u>CocList outline\<cr> | Find symbol of current document |
| nnoremap | \<silent> \<space>s  |  :\<C-u>CocList -I symbols\<cr> | Search workspace symbols |
| nnoremap | \<silent> \<space>j  |  :\<C-u>CocNext\<CR> | Do default action for next item. |
| nnoremap | \<silent> \<space>k  |  :\<C-u>CocPrev\<CR> | Do default action for previous item. |
| nnoremap | \<silent> \<space>p  |  :\<C-u>CocListResume\<CR> | Resume latest coc list |
| nnoremap | \<leader>h1  | :HighlightLine hlYellow\<cr> |  |
| vnoremap | \<leader>h1  | :'\<,'>HighlightLine hlYellow\<cr> |  |
| nnoremap | \<leader>h2  | :HighlightLine hlDarkBlue\<cr> |  |
| vnoremap | \<leader>h2  | :'\<,'>HighlightLine hlDarkBlue\<cr> |  |
| nnoremap | \<leader>rh  | :RemoveHighlighting\<cr> |  |
| vnoremap | \<leader>rh  | :'\<,'>RemoveHighlighting\<cr> |  |
| nnoremap | \<silent> \<c-h>  | :TmuxNavigateLeft\<cr> |  |
| nnoremap | \<silent> \<c-j>  | :TmuxNavigateDown\<cr> |  |
| nnoremap | \<silent> \<c-k>  | :TmuxNavigateUp\<cr> |  |
| nnoremap | \<silent> \<c-l>  | :TmuxNavigateRight\<cr> |  |
| nnoremap | \<leader>rr  | :\<C-u>TerminalReplFile\<cr> |  |
| nnoremap | \<leader>rt  | :\<C-u>TerminalReplFileToggle\<cr> |  |
| nnoremap | \<leader>+  | :vertical resize +10\<CR> | See: https://vim.fandom.com/wiki/Resize_splits_more_quickly Increase/Decrease vertical windows |
| nnoremap | \<leader>-  | :vertical resize -10\<CR> |  |
| nnoremap | [T  |  :tabfirst\<CR>    " moves to first tab | easier tab navigation |
| nnoremap | ]t  |  :tabnext\<CR>     " moves to next tab |  |
| nnoremap | [t  |  :tabprev\<CR>     " moves to previous tab |  |
| nnoremap | ]T  |  :tablast\<CR>     " moves to last tab |  |
| nnoremap | \<leader>1  | 1gt\<CR>    " moves to tab 1 |  |
| nnoremap | \<leader>2  | 2gt\<CR>    " moves to tab 2 |  |
| nnoremap | \<leader>3  | 3gt\<CR>    " moves to tab 3 |  |
| nnoremap | \<leader>4  | 4gt\<CR>    " moves to tab 4 |  |
| nnoremap | \<leader>5  | 5gt\<CR>    " moves to tab 5 |  |
| nnoremap | \<leader>6  | 6gt\<CR>    " moves to tab 6 |  |
| nnoremap | \<leader>7  | 7gt\<CR>    " moves to tab 7 |  |
| nnoremap | \<leader>8  | 8gt\<CR>    " moves to tab 8 |  |
| nnoremap | \<leader>9  | 9gt\<CR>    " moves to tab 9 |  |
| nnoremap | tn  |  :tabnew\<CR> | opens new tab |
| nnoremap | tc  |  :tabclose\<CR> | closes tab |
| nnoremap | \<leader>cl  | :copen\<CR>   " Open Quicklist | TODO set these up so that they close what ever locaton / quickfix window is open... if more than one just close first one found |
| nnoremap | \<leader>cc  | :cclose\<CR>  " Close quicklist |  |
| nnoremap | ]c  | :cn\<CR> | To quickly go through the Quicklist |
| nnoremap | [c  | :cp\<CR> |  |
| nnoremap | \<leader>ls  | :ls\<CR>:b\<Space> | Easier navigation with file buffer list open buffers |
| nnoremap | [b  | :bprevious\<CR> |  |
| nnoremap | ]b  | :bnext\<CR> |  |
| nnoremap | \<leader>bd  | :bdelete\<CR> |  |
| nnoremap | \<leader>wc  | :close\<CR> |  |
| noremap | \<Leader>Y  | "*y | These apply for all modes |
| noremap | \<Leader>P  | "*p |  |
| noremap | \<Leader>y  | "+y |  |
| noremap | \<Leader>p  | "+p |  |
| nnoremap | cdq  | mp0f"r';.\`p | Replace first pair of double quotes on line with single return back to cursor location |
| nnoremap | csq  | mp0f'r";.\`p |  |
| vnoremap | \<leader>s"  | :\<esc>\`\<i"\<esc>\`>la"\<esc> | Wrap visual selection in double quotes |
| vnoremap | \<leader>s'  | :\<esc>\`\<i'\<esc>\`>la'\<esc> | Wrap visual selection in single quotes |
| inoremap | jj  | \<ESC>:w\<cr> | exit insert mode and save buffer |
| nnoremap | \<leader>o  | o\<ESC>k | insert a line above or below, and exit back to normal TODO if this is run from a comment line then it adds a comment prefix which I don't want |
| nnoremap | \<leader>O  | O\<ESC>j |  |
| vnoremap | \<  | \<gv | Reselect previous selection (gv) in visual mode after indenting left or right |
| vnoremap | >  | >gv |  |
| nnoremap | gp  | \`[v\`] | Select last pasted text |
| nnoremap | \<leader>=  | Vap= | Format current paragraph |
| nnoremap | \<up>  | \<nop> | Disable arrow keys |
| nnoremap | \<down>  | \<nop> |  |
| nnoremap | \<left>  | \<nop> |  |
| nnoremap | \<right>  | \<nop> |  |
| inoremap | \<c-e>  | \<esc>A | In insert more move using readline line start/end |
| inoremap | \<c-a>  | \<esc>I |  |
| nnoremap | \<silent>\<leader>ev  | :vsplit $MYVIMRC\<cr> | Open vimrc in vertical split |
| nnoremap | \<silent>\<leader>sv  | :w\<cr>:source $MYVIMRC\<cr>:echo "vimrc sourced mother licker"\<cr> | Source shared vim config |
| xnoremap | \<leader>pro  | :\<c-u>call Prototype()\<CR> | This function copies visual selection pastes it below and comments out original leaving cursor in first line on copied selection It has a dependency on vim-commentary plugin |
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
| nnoremap | \<leader>vf  | ?function\<cr>v/endfunction\<cr>$ | Highlights function block TODO turn this into a object so can then do multiple levels |
| xnoremap | \<leader>ev  | yoechom '": ' . " | echo's selection on line bellow |
| nnoremap | \<leader>lf  | :call LocationListFromPattern('^\(\s*\)\=function!\=.*(.*)\( abort\)\=$')\<cr> | Populates a location list with the functions in the current file |

<!-- end  autodocumentation block ftplugin/vim.vim mappings -->

## Plugins

Currently I use the native package manager, and git submodules hence cloning
with the `-recursive` flag.

To add a new plugin use the following command:
```bash
git submodule add <URL TO PLUGIN> nvim/plugins/start/<NAME>
```

If pulling from another machine run the following to ensure all submodules are initialised:
```bash
git submodule update --recursive --init
```

NOTE: [This stackoverflow](https://stackoverflow.com/questions/20929336/git-submodule-add-a-git-directory-is-found-locally-issue) was useful when I got submodule issues adding and removing plugins this way.

### Third Party Plugins

The following is a list of the third party plugins used, key bindings are as
defined in the plugins help unless otherwise stated below:


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
| [tender.vim](https://github.com/jacoborus/tender.vim.git) | Colour scheme | |
| [vim-togglesmartsearch](https://github.com/terrortylor/vim-togglesmartsearch.git) | A noddy plugin I made to try out making a plugin | This is utterly not needed... I should delete it really |
| [vim-highlight](https://github.com/terrortylor/vim-highlight.git) | Adds ability to highlight lines in a buffer, not saved on exit |
| [vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator.git) | Used for easy navigation across vim windows and tmux windows | |
| [coc](https://github.com/neoclide/coc.nvim.git) | Used to add LSP, linting and auto-popup completion support | I'm not 100% on weather this should be kept or not |
| [ultisnips](https://github.com/SirVer/ultisnips.git) | A snippet engine | Snippets live under `nvim\config\ultisnips` |
| [kotlin-vim](https://github.com/udalov/kotlin-vim.git) | Adds some kotlin syntax support etc | Using this until NeoVim handles this it self |
| [vim-gutentags](https://github.com/ludovicchabant/vim-gutentags) | Manages ctag creation/management in the background |

### Custom Plugins

These are plugins that I have created for whatever reason, they work as is and
can be found under `nvim/config/plugin`.

NOTE: I generally like the workflow of a single tab; using other tabs for
breakaway tasks like searching for text across a project or checking the git
diff output of the current buffer. As such many of the plugins below will open
a new tab so it's easy to jump right back in to coding.

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

#### websearch

A plugin to run a web search for the word under cursor or the currently
selected block of text. Currently this is mapped to `<leader>gs`.

#### focus

I saw a plugin called [goyo](https://github.com/junegunn/goyo.vim.git) which
is used for 'distraction-free writing in vim'. I thought it was fun and
thought I'd give a go at writing something similar.

* Command: Focus - Opens the current buffer in a new tab, with 'distractions'
  at a minimum

#### terminal

I'd put off using vim's terminal emulator until I was looking at a new
language and wanted the ability to compile and run the current buffer easily.
I've heard of such tools that make it easy (vim-dispatch for example) but
thought I'd write a simple plugin to toggle a window that runs the given
buffer. This is still very much a work in progress.

### File Type Plugins

#### markdown

#### ftplugin/markdown/toc.vim

Create a Table of Contents at the top of a markdown file, if one exists it re-creates it.

<!-- start autodocumentation block ftplugin/markdown/toc.vim commands -->
| Command | Config | Description |
| ------- | -------| ----------- |
| CreateTOC | -nargs=0 | Adds a markdown style TOC to the top of the markdown file |
| RemoveTOC | -nargs=0 | Removes a markdown style TOC from the top of the markdown file |

<!-- end  autodocumentation block ftplugin/markdown/toc.vim commands -->

#### ftplugin/markdown/vim_doc_generator.vim

This is used to autogenerate mapping and command documentation, as used in
this README.md file.

<!-- start autodocumentation block ftplugin/markdown/vim_doc_generator.vim commands -->
| Command | Config | Description |
| ------- | -------| ----------- |
| GenerateVimMappingDocumentationTable | -nargs=0 | Searches for 'documentation' tags and populates them accordingly, based on mapping/command definitions and comments |
| GenerateVimMappingDocumentationTags | -nargs=0 | Generates 'documentation' tags for files in a number of locations |

<!-- end  autodocumentation block ftplugin/markdown/vim_doc_generator.vim commands -->

#### chef

When working with chef repositories set the path so that `gf` can be used to
jump to cookbooks recipe file when `include_recipe` is used.

Covers:

* include_recipe 'firewall' => firewall/recipes/default.rb
* include_recipe 'firewall::windows' => firewall/recipes/windows.rb

NOTE: This is very dependant on my set-up, adjust accordingly.

#### note

I have a little script that to [open notes from the command line](https://github.com/terrortylor/ansible_dev_machine_setup/blob/master/roles/terminal/files/bin/notes).
This filetype plugin basically is used to create/update the TOC of the
markdown notes when the buffer is written.

TODO Finish custom functions and key mappings, for key mappings let's create a
function to find mappings and then search for comment

## Custom Functions / Commands

So anything else that's note worthy:
<!-- start autodocumentation block init.vim commands -->
| Command | Config | Description |
| ------- | -------| ----------- |
| GGrep | -nargs=1 | Create command for global search in projct |
| TabbedQuicklistViewer |  | Opens a new tab with quickfix list open, selecting first item |
| Scratch |  | Opens a scratch buffer, if one exists already open that |
| PasteToScratch |  | Puts the contents on the scratch_paste_register into the scratch buffer |
| OpenFTPluginFile | -nargs=0 | Wrap OpenFTPluginFile function in a command which opens the ftplugin file for given file |

<!-- end  autodocumentation block init.vim commands -->

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
