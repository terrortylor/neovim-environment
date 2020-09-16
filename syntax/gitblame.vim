syntax match blameLine "^.*$" contains=blameDate,blameCommitID
syntax match blameDate "\d\{4}-\d\d-\d\d \d\d:\d\d:\d\d"
syntax match blameCommitID "\S\{8}$"

highlight default link blameLine Comment
highlight default link blameDate Number
highlight default link blameCommitID String
