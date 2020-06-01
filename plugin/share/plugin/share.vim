if exists('g:loaded_share_plugin')
  finish
endif
let g:loaded_share_plugin = 1

if !exists('g:shareDefaultService')
	let g:shareDefaultService = 'vpaste'
endif

if !exists('g:shareServices')
	let g:shareServices = {
  \  'vpaste': '"text=<-" http://vpaste.net',
  \  'sprunge': '"sprunge=<-" http://sprunge.us',
  \  'clbin': '"clbin=<-" https://clbin.com',
  \  'ixio': '"f:1=<-" ix.io',
  \}
endif

command! -range=% -nargs=? SendToPasteService :<line1>,<line2>call SendToPasteService(<f-args>)
