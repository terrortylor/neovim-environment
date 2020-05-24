if ( exists('g:extension_collection') && g:extension_collection )
	\ || v:version < 700 || &cp
	finish
endif
let g:extension_collection = 1

" Define new commands
command! CtrlPMarks call ctrlp#init(ctrlp#marks#id())
command! CtrlPRegister call ctrlp#init(ctrlp#register#id())
command! CtrlPUltisnips call ctrlp#init(ctrlp#ultisnips#id())
