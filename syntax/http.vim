if exists("b:current_syntax")
    finish
endif

syntax match httpUrl "\(https\?:\/\{2}\)\?\(\w\+\(:\w\+\)\?@\)\?\([A-Za-z][-_0-9A-Za-z]*\.\)\{1,}\(\w\{2,}\.\?\)\{1,}\(:[0-9]\{1,5}\)\?\S*"

syntax keyword httpCommentKeyword TODO contained
syntax match httpComment "\v^#.*$" contains=httpCommentKeyword

syntax keyword httpVerbKeyword GET POST PATCH PUT HEAD DELETE nextgroup=httpPath
syntax match httpPath ".*$" contained

syntax match httpParamSection "^.*[=:][^/]" contains=httpParamSeperator
syntax match httpParamSeperator "[:]" contained

syntax match httpVarSection "^\(VAR\|var\)[=:]" nextgroup=httpVarKey skipwhite
syntax match httpVarKey "[^:]\+" contained nextgroup=httpVarSeperator skipwhite
syntax match httpVarSeperator "[=:]" contained

syntax match httpHeaderSection "^\(HEADER\|header\)[=:]" nextgroup=httpHeaderKey skipwhite
syntax match httpHeaderKey "[^:]\+" contained nextgroup=httpHeaderSeperator skipwhite
syntax match httpHeaderSeperator "[=:]" contained

syntax include @json syntax/json.vim
syntax region jsonBody start="\v^\{" end="\v\}$" contains=@json keepend

highlight link httpComment Comment
highlight link httpCommentKeyword Todo

highlight link httpUrl Title

highlight link httpVerbKeyword Type
highlight link httpPath Title

highlight link httpVarSection Type
highlight link httpVarKey Constant
highlight link httpVarSeperator Todo

highlight link httpHeaderSection Type
highlight link httpHeaderKey Constant
highlight link httpHeaderSeperator Todo

highlight link httpParamSection Constant
highlight link httpParamSeperator Todo

highlight link jsonBody SpecialComment

let b:current_syntax = "http"
