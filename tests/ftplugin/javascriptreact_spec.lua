local utils = require('util.test_utils')

describe("javascriptreact", function()
  it("Should jump to next pattern matching in direction", function()
    local input = [[
render() {
  const { value } = this.state;
  return (
   <p>{value}</p>
   <p>{new_state_value}</p>
  );
}
]]

    local expected = [[
render() {
  const { new_state_value, value } = this.state;
  return (
   <p>{value}</p>
   <p>{new_state_value}</p>
  );
}
]]

    utils.load_lines(input)
    vim.api.nvim_buf_set_option(0 ,'filetype', 'javascriptreact')

    -- put cursor on new_state_value
    vim.api.nvim_win_set_cursor(0, {5,10})
    utils.send_keys("<leader>was")

    local actual = utils.buf_as_multiline()
    assert.are.same(expected, actual)
  end)
end)


