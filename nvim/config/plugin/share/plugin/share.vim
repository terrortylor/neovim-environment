if exists('g:loaded_share_plugin')
  finish
endif
let g:loaded_share_plugin = 1

if !exists('g:shareDefaultService')
	let g:shareDefaultService = 'vpaste'
endif

if !exists('g:shareServices')
	let g:shareServices = {}
	let g:shareServices['vpaste'] = '"text=<-" http://vpaste.net'
	let g:shareServices['sprunge'] = '"sprunge=<-" http://sprunge.us'
	let g:shareServices['clbin'] = '"clbin=<-" https://clbin.com'
	let g:shareServices['ixio'] = '"f:1=<-" ix.io'
endif

" TODO better command name, start with share
command! -range=% -nargs=? SendToPasteService :<line1>,<line2>call SendToPasteService(<f-args>)
