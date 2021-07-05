local testModule

local mock = require('luassert.mock')
local stub = require('luassert.stub')
local tu = require('util.test_utils')

local interface = tu.multiline_to_table([[go
type Doer interface {                                             
  Action(string, string, int) (string, error)                                      
  Unaction(string) error
  Sausage(customStruct, string, []string)
}     
]])

local struct = tu.multiline_to_table([[go
type myStruct struct {
  name string
  animal string
  age int
}
]])

describe('generator.filetype.go', function()

  before_each(function()
    testModule = require('generator.filetypes.go')
    -- api = mock(vim.api, true)
  end)

--   after_each(function()
--     mock.revert(api)
--   end)

  describe("get_func_arguments", function()
    local test_table = {
      ["Action(string, string, int) (string, error)"] = "s string, s2 string, i int",
      ["Dog(animal, cheese, int) error"] = "a animal, c cheese, i int"
    }
    for input,output in pairs(test_table) do
      it("should return correct arguments for: " .. input, function()
        local result = testModule.get_func_arguments(input)
        assert.equals(output, result)
      end)
    end
  end)

  describe("get_struct_name", function()
    it("should return the struct name", function()
      local expected = "myStruct"
      local result = testModule.get_struct_name(struct)
      assert.equals(expected, result)
    end)
  end)

  describe("generate_implementation", function()
    it("should generate implementation of interface on struct", function()
      local expected = tu.multiline_to_table([[
      func (m *myStruct) Action(s string, s2 string, i int) (string, error) {
        fmt.Println("not implemented")
      }

      func (m *myStruct) Unaction(s string) error {
        fmt.Println("not implemented")
      }

      func (m *myStruct) Sausage(c customStruct, s string) {
        fmt.Println("not implemented")
      }
      ]])
      
      local result = testModule.generate_implementation(interface, struct)
      assert.same(expected, result)
    end)
  end)

  describe("generate_constructor", function()
    it("should do nothing if struct not passed in", function()
      local result = testModule.generate_constructor({})
      assert.is.Nil(result)
    end)

    it("should generate constructor for struct", function()
      local expected = tu.multiline_to_table([[
func NewMyStruct(name string, animal string, age int) {
    return &myStruct{name: name, animal: animal, age: age}
}
]])
      local result = testModule.generate_constructor(struct)
      assert.same(expected, result)
    end)
  end)

  describe("action_chooser", function()
    it("should return nil if no match found", function()
      local result = testModule.action_chooser(nil)
      assert.is.Nil(result)
    end)

    it("should return nil if definition is too small", function()
      local result = testModule.action_chooser({"goats"})
      assert.is.Nil(result)
    end)

    it(" should return 'interface' if definition is interface", function()
      local result = testModule.action_chooser(interface)
      assert.equals("interface", result)
    end)

    it(" should return 'interface' if definition is interface", function()
      local result = testModule.action_chooser(interface)
      assert.equals("interface", result)
    end)
  end)
end)
