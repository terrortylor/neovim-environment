local abbs = {
  i = {
    teh = "the",
    adn = "and",
  },
}

for mode, abbrevs in pairs(abbs) do
  for k, v in pairs(abbrevs) do
    vim.cmd(string.format("%sabbrev %s %s", mode, k, v))
  end
end
