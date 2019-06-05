# Vim and NeoVim
This repository is for both my vim and neovim config files.

Most of the configuration is in the `shared.vim` file that is sources by both vim and neovim. Key mappings are detailed below.

As neovim follows the [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html) and I've had some compatability issues when loading the same plugins in vim and neovim; I maintain two plugin directories. Although using git submodules so it's not to cumbersome.

# Vim
See the directory vim and the file .vimrc.
NOTE: that shared.vim is sourced in .vimrc to load Configuration shared with neovim.
FYI, I've checked in my spelling file! And I can't spell very well at all!

## Plugins
Using the vim native package manager as of vim 8... so you need vim >=8
Submodules are used, to add a new plugin:
```
git submodule add <URL TO PLUGIN> vim/pack/plugins/start/<NAME>
```
so when checking out ensure you use `--recursive`
```
git clone --recursive https://github.com/terrortylor/vim-environment.git
```

If pulling from another machine run the following to ensure all submodules are initialised:
```
git submodule update --recursive --init
```
* [vim sneak](https://github.com/justinmk/vim-sneak)
* [tabline](https://github.com/mkitt/tabline.vim)
* [ctrlp](https://github.com/ctrlpvim/ctrlp.vim) Note that `:CtrlPClearAllCaches` is very useful to know

# Vim
See the directory vim and the file .vimrc.
NOTE: that shared.vim is sourced in .vimrc to load Configuration shared with neovim.
FYI, I've checked in my spelling file! And I can't spell very well at all!

## Plugins
Using the vim native package manager as of vim 8... so you need vim >=8
Submodules are used, to add a new plugin:
```
git submodule add <URL TO PLUGIN> nvim/plugins/start/<NAME>
```
so when checking out ensure you use `--recursive`
```
git clone --recursive https://github.com/terrortylor/vim-environment.git
```

If pulling from another machine run the following to ensure all submodules are initialised:
```
git submodule update --recursive --init
```
* [vim sneak](https://github.com/justinmk/vim-sneak)

# Key Mappings
Checkout the `shared.vim` file, most of is is commented.

* `<leader><space>` Turn off search highlights
* `<leader>rln` Toggle relative line numbering on and off, leaving normal line numbering on
* `<leader>+` Increase windows width vertically
* `<leader>-` Decrease windows width vertically
* `jj` has been mapped in `insert` mode to `<ESC` to save some hand movements
* Window resizing
  * `<leader>+` increase vertically by 10 columns
  * `<leader>-` decrease vertically by 10 columns

## Noteworthy
Most of these are fairly standard when coming across other peoples `.vimrc` files on the line; but worth taking a minute to take a look just in case...
* Arrow keys have been disabled to try to prevent bad habits...
* The `<leader>` key is mapped to `\`
* I prefer spaces to tabs, with an indentation of 2
* On saving a buffer trailing whitespace is removed
* Hybrid line numbering is used, current line shows current line number; lines above and below show movements from current. `<leader>rln` toggles this to normal line numbering
* Buffers are autosaved, when switched between them
* Use of the mouse is disabled
