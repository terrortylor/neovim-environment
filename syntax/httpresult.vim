if exists("b:current_syntax")
    finish
endif

syntax match httpresultComment "^#\+"
syntax keyword httpresultTitle GET POST PATCH PUT HEAD DELETE nextgroup=httpresultPath
syntax match httpresultPath ".*$" contained

syntax include @json syntax/json.vim
syntax region jsonBody start="\v^\{" end="\v\}$" contains=@json keepend

hi link httpresultComment Comment
hi link httpresultTitle Type
hi link httpresultPath Title

let b:current_syntax = "httpresult"
