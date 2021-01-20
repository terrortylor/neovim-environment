-- luacheck: globals Plugin
Plugin = {
  url = "",
  name = nil,
  base_path = "",
  install_path = nil,
  package = "plugins",
  loaded = "start",
  branch = "master",
  installed = false,
  docs = false,
  has_error = false
}

local github_url = 'https://github.com/'

function Plugin:new(base_path, opts)
   local o = {}
   o.base_path = base_path
   for k,v in pairs(opts) do
     o[k] = v
   end
   setmetatable(o, self)
   self.__index = self
   return o
end

function Plugin:get_name()
  if not self.name then
    self.name = self.url:match('/([%w_%-%.]+)$')
  end
  return self.name
end

function Plugin:get_install_path()
  if not self.install_path then
    self.install_path = string.format('%s/site/pack/%s/%s/%s',
    self.base_path,
    self.package,
    self.loaded,
    self:get_name())
  end
  return self.install_path
end

function Plugin:get_docs_path()
  return self:get_install_path() .. "/doc"
end

-- TODO add tests to all below
function Plugin:to_string()
  local ternary = function(cond, T, F)
    if cond then return T else return F end
  end

  local state = ternary(self.has_error, "Error: ", ternary(self.installed, "Installed", "Missing"))
  local docs = ternary(self.docs, "Yes", "No")
  local loaded = self.loaded:gsub("^%l", string.upper)

  return string.format("\tState: %s\tDocs: %s\tLoaded: %s\tPackage: %s\tBranch: %s", state, docs, loaded, self.package, self.branch)
end

-- overkill, but consistent
-- all properties via accesor
function Plugin:get_branch()
  return self.branch
end

-- TODO tidy up
function Plugin:get_url()
  if self.url:match('^http') or self.url:match('^www') then
    return self.url
  else
    self.url = github_url .. self.url .. '.git'
    return self.url
  end
end

function Plugin:set_installed(bool)
  self.installed = bool
end

function Plugin:set_install_error(bool)
  self.has_error = bool
end

function Plugin:set_docs(bool)
  self.docs = bool
end
