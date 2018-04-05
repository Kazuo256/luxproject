
local common = require 'lux.common'

local t = {1, 2, 3}

local function foo()
  t[1] = t[2] + t[3]
  t[2] = t[1] + t[3]
  t[3] = t[1] + t[2]
  return table.unpack(t)
end

local original_print = print
local expected

function test_init()
  _G.print = function(...)
    return assert(table.concat({...}, "\t") == expected)
  end

  expected = "PRINTF: [1, 2, 3]"
  common.printf("PRINTF: [%d, %d, %d]", t[1], t[2], t[3])

  expected = "IDENTITY PRINT:"
  common.printf("%s", "IDENTITY PRINT:")

  expected = "5	8	13"
  local a, b, c = common.identityp(foo())

  expected = "PRINTF: [5, 8, 13]"
  common.printf("PRINTF: [%d, %d, %d]", a, b, c)

  _G.print = original_print
end

