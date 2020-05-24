" Simple plugin manager, just clone plugin as required
" Was using git submodules but a particular issue wa annoying me and this
" solution negates that
if exists('g:loaded_pluginman_plugin')
  finish
endif
let g:loaded_pluginman_plugin = 1

if !exists('g:pluginman_submodule_path')
  let g:pluginman_submodule_path = 'nvim/plugins/'
endif

if !exists('g:pluginman_plugin_path')
  let g:pluginman_plugin_path = '~/.local/share/nvim/site/pack/plugins/'
endif

function! pluginman#CacheInstalledPlugins() abort
  let g:pluginman_installed_plugins = pluginman#GetInstalledPlugins()

  command! -nargs=+ InstallPlugin :call InstallPlugin(<f-args>)
endfunction

function! pluginman#DeleteCacheInstalledPlugins() abort
  unlet g:pluginman_installed_plugins
endfunction

function! pluginman#InitPluginPath() abort
  call system('mkdir -p ' . g:pluginman_plugin_path . '{start,opt}')
endfunction

function! pluginman#AddPlugin(plugin_url, optional) abort
  let l:plugin_name = s:GetNameFromUrl(a:plugin_url)

  if exists('g:pluginman_installed_plugins')
    let l:installed_plugins = g:pluginman_installed_plugins
  else
    let l:installed_plugins = pluginman#GetInstalledPlugins()
  endif

  if !has_key(l:installed_plugins, l:plugin_name)
    echom 'Installing Plugin: ' . l:plugin_name
    let l:opt_path = a:optional ? 'opt' : 'start'
    let l:plugin_path = g:pluginman_plugin_path . l:opt_path . '/'
    let l:command = 'mkdir -p ' . l:plugin_path . l:plugin_name
    call system(l:command)
    let l:command = 'git -C ' . l:plugin_path . ' clone ' . a:plugin_url
    call system(l:command)
    echom 'Done'

    if exists('g:pluginman_installed_plugins')
      call pluginman#CacheInstalledPlugins()
    endif
  endif
endfunction

function! pluginman#RemovePlugin(plugin) abort
  let l:plugin_name = s:GetNameFromUrl(a:plugin)

  let l:installed_plugins = pluginman#GetInstalledPlugins()
  if has_key(l:installed_plugins, l:plugin_name)
    let l:optional = get(l:installed_plugins, l:plugin_name)
    let l:plugin_path = g:pluginman_plugin_path . l:optional . '/'
    let l:command = 'rm -rf ' . l:plugin_path . l:plugin_name
    call system(l:command)
    echom 'Removed Plugin: ' . l:plugin_name
    " TODO remove from runtimepath and run helptags
    " :heltags ALL
  else
    echom 'Plugin not found'
  endif
endfunction

function! s:GetNameFromUrl(plugin_url) abort
  return split(a:plugin_url, '/')[-1]
endfunction

function! pluginman#GetInstalledPlugins() abort
  let l:installed_plugins = {}
  let l:list_out = split(system('ls ' . g:pluginman_plugin_path . 'start/'))
  for i in l:list_out
    let l:installed_plugins[i] = 'start'
  endfor
  let l:list_out = split(system('ls ' . g:pluginman_plugin_path . 'opt/'))
  for i in l:list_out
    let l:installed_plugins[i] = 'opt'
  endfor
  return l:installed_plugins
endfunction

function! InstallPlugin(...) abort
  if a:0 == 1
    call pluginman#AddPlugin(a:1, v:false)
  else
    call pluginman#AddPlugin(a:1, v:true)
  endif
endfunction

" command! -nargs=+ InstallPlugin :call AddPlugin(<f-args>)

call pluginman#InitPluginPath()
