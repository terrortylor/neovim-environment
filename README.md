# (Neo)Vim config

This repository is used to track my NeoVim configuration, which I now use over
vim(8). Which I did maintain both vim and neovim via a shared configuration
file, I repeatidly found that I wasn't using vim. I've not found a use case
yet where there has been a need to rerevert.

Feel free to copy/clone although I'd always suggest reading the `init.vim` file
instead and adapt to fit your own workflow as this is a constantly evolving configuration.

Neovim follows the [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html), so two directories need to be symlinked:
* nvim/config needs to be pointed at by ~/.config/nvim
* nvim/plugins needs to be pointed at by ~/.local/share/nvim/site/pack/plugins

I have an ansible project for managing environment/dotfiles although often I'll just want to set this up on a target quickly so a seperate repository leands it self to that use case. My [ansible project can be found here](https://github.com/terrortylor/ansible_dev_machine_setup).

# Vim
I no longer bother maintaining vim config etc, although it can be viewed [on this branch](https://github.com/terrortylor/vim-environment/tree/vim_and_nvim_config).

## Plugins
Using the vim native package manager ~~as of vim 8... so you need vim >=8~~ built into NeoVim

Submodules are used, to add a new plugin:
```
git submodule add <URL TO PLUGIN> nvim/plugins/start/<NAME>
```

When checking out this project be sure to use the `--recursive` flag
```
git clone --recursive https://github.com/terrortylor/vim-environment.git
```

If pulling from another machine run the following to ensure all submodules are initialised:
```
git submodule update --recursive --init
```

### Base Plugins
The following is not an exhaustive list by any means of the plugins I use, however these are generally very useful to have at a minumum:

* [vim sneak](https://github.com/justinmk/vim-sneak) - This is a fantastic tool for navigating around a file in three key strokes
* [ctrlp](https://github.com/ctrlpvim/ctrlp.vim) Note that `:CtrlPClearAllCaches` is very useful to know
* [nerdtree](https://github.com/scrooloose/nerdtree.git) - used as repacement to netrw
* [vim-commentary](https://github.com/tpope/vim-commentary) - used for comment toggeling

NOTE: [This stackoverflow](https://stackoverflow.com/questions/20929336/git-submodule-add-a-git-directory-is-found-locally-issue) was useful when I got submodule issues adding and removing plugins this way.

# Custom Functions
## TabbedQuicklist
Opens a new tab with the quicklist open and first item selected.

# Noteworthy Key Mappings
Checkout the `shared.vim` file, most of is is commented.

* `<leader><space>` Turn off search highlights
* `<leader>rln` Toggle relative line numbering on and off, leaving normal line numbering on
* `jj` has been mapped in `insert` mode to `<ESC` to save some hand movements

# Noteworthy
Most of these are fairly standard when coming across other peoples `.vimrc` files on the line; but worth taking a minute to take a look just in case...
* Arrow keys have been disabled to try to prevent bad habits...
* The `<leader>` key is mapped to `\`
* I prefer spaces to tabs, with an indentation of 2
* On saving a buffer trailing whitespace is removed
* Hybrid line numbering is used, current line shows current line number; lines above and below show movements from current. `<leader>rln` toggles this to normal line numbering
* Buffers are autosaved, when switched between them
* Use of the mouse is disabled
