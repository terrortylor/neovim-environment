local M = {}

function M.trim_whitespace(s)
  return s:match("^%s*(.-)%s*$")
end

function M.escape(x)
  return (x:gsub('%%', '%%%%')
    :gsub('%^', '%%^')
    :gsub('%$', '%%$')
    :gsub('%(', '%%(')
    :gsub('%)', '%%)')
    :gsub('%.', '%%.')
    :gsub('%[', '%%[')
    :gsub('%]', '%%]')
    :gsub('%*', '%%*')
    :gsub('%+', '%%+')
    :gsub('%-', '%%-')
    :gsub('%?', '%%?'))
end

return M
