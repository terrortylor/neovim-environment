runtime syntax/groovy.vim

syn keyword jenkinsfileSection pipeline agent stages stage steps

syn keyword jenkinsfileDirective environment options parameters triggers stage tools input when libraries

syn keyword jenkinsfileOption contained buildDiscarder disableConcurrentBuilds overrideIndexTriggers skipDefaultCheckout nextgroup=jenkinsfileOptionParams
syn keyword jenkinsfileOption contained skipStagesAfterUnstable checkoutToSubdirectory timeout retry timestamps nextgroup=jenkinsfileOptionParams
syn region  jenkinsfileOptionParams contained start='(' end=')' transparent contains=@groovyTop
syn match   jenkinsfileOptionO /[a-zA-Z]\+([^)]*)/ contains=jenkinsfileOption,jenkinsfileOptionParams transparent containedin=groovyParenT1

syn keyword jenkinsfileCoreStep checkout
syn keyword jenkinsfileCoreStep docker skipwhite nextgroup=jenkinsFileDockerConfigBlock
syn keyword jenkinsfileCoreStep node
syn keyword jenkinsfileCoreStep scm
syn keyword jenkinsfileCoreStep stage
syn keyword jenkinsfileCoreStep parallel
syn keyword jenkinsfileCoreStep steps
syn keyword jenkinsfileCoreStep step
syn keyword jenkinsfileCoreStep tool
syn keyword jenkinsfileCoreStep post
syn keyword jenkinsfileCoreStep always
syn keyword jenkinsfileCoreStep changed
syn keyword jenkinsfileCoreStep failure
syn keyword jenkinsfileCoreStep success
syn keyword jenkinsfileCoreStep unstable
syn keyword jenkinsfileCoreStep aborted

syn region  jenkinsFileDockerConfigBlock contained start='{' end='}' contains=groovyString,jenkinsfileDockerKeyword transparent
syn keyword jenkinsFileDockerKeyword contained image args dockerfile additionalBuildArgs

syn keyword jenkinsfilePipelineStep scm zip sh checkout

hi link jenkinsfileSection           Statement
hi link jenkinsfileDirective         jenkinsfileSection
hi link jenkinsfileOption            Function
hi link jenkinsfileCoreStep          Function
hi link jenkinsfilePipelineStep      Include
hi link jenkinsfileBuiltInVariable   Identifier
hi link jenkinsFileDockerKeyword     jenkinsfilePipelineStep

let b:current_syntax = 'Jenkinsfile'
