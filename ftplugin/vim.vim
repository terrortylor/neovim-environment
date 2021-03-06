" Folds top level functions
" including functions that are commented out
function! FoldVimFunctions(line)
	let func_start = '\v^(")=(\s)?fun(ction)='
	let func_end = '\v^(")=(\s)?endfun(ction)='
	let str = getline(a:line)

	if str =~ func_start
		return '>1'
	elseif str =~ func_end
		return '<1'
	else
		if a:line > 1
			let prev_line = getline(a:line - 1)
			if prev_line =~ func_end
				return 0
			endif
		endif
		return foldlevel(a:line - 1)
	endif
endfunction
