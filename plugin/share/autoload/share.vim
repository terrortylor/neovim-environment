function! SendToPasteService(...) range
	if a:0 == 0
		let l:service = get(g:shareServices, g:shareDefaultService)
	else
		if !has_key(g:shareServices, 	a:1)
			echo 'error: service not found: ' . a:1
			return
		endif
		let l:service = get(g:shareServices, a:1)
	endif
	let l:lines = shellescape(join(getline(a:firstline, a:lastline), "\n"))
	let l:url = system('echo '. l:lines . ' | curl -s -F ' . l:service . ' | tr -d "\n"')
	let @" = l:url
	echom 'Set to clipboard: ' . @"
endfunction
