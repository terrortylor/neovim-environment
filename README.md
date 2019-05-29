# Vim Environment
I repository for my ~/.vim directory and ~/.vimrc file.
FYI, I've checked in my spelling file! And I can't spell very well at all!

# Plugins
Using the vim native package manager as of vim 8... so you need vim >=8
Submodules are used, to add a new plugin:
```
git submodule add <URL TO PLUGIN> vim/pack/plugins/start/<NAME>
```
so when checking out ensure you use `--recursive`
```
git clone --recursive https://github.com/terrortylor/vim-environment.git
```

# Key Mappings
Checkout the `vimrc` file, most of is is commented.

* `<leader><space>` Turn off search highlights
* `<leader>rln` Toggle relative line numbering on and off, leaving normal line numbering on
* `<leader>+` Increase windows width vertically
* `<leader>-` Decrease windows width vertically
* `jj` has been mapped in `insert` mode to `<ESC` to save some hand movements

## Noteworthy
Most of these are fairly standard when coming across other peoples `.vimrc` files on the line; but worth taking a minute to take a look just in case...
* Arrow keys have been disabled to try to prevent bad habits...
* The `<leader>` key is mapped to `\`
