if exists("b:current_syntax")
    finish
endif

syntax match pluginmanStatusTitle "^Plugin Summary:$"
syntax keyword pluginmanStatusKeys State: Docs: Loaded: Package: Branch:
syntax keyword pluginmanStatusValuePos Installed Yes Start
syntax keyword pluginmanStatusValueMeh Opt
syntax keyword pluginmanStatusValueNeg Missing No

highlight link pluginmanStatusTitle Title
highlight link pluginmanStatusKeys Type
highlight link pluginmanStatusValuePos Constant
highlight link pluginmanStatusValueMeh String
highlight link pluginmanStatusValueNeg Todo

let b:current_syntax = "pluginstatus"
