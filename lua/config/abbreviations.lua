local api = vim.api

local abbs = {
  insert = {
    teh = "the",
    adn = "and"
  }
}

for k, v in pairs(abbs.insert) do
 api.nvim_command(string.format("iabbrev %s %s", k, v))
end
