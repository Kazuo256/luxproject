
package.path = package.path..";./lib/?.lua"

local macro = require 'lux.macro'

local input = io.open("./test/input.in.lua")

local output = io.open("./test/input.lua", "w")

local env = setmetatable({
  functions = {
    foo = {
      args = { "x", "y", "z" },
      result = "x+y+z"
    },
    bar = {
      args = { "a" },
      result = "foo(a,a,a)"
    }
  }
}, { __index = _ENV })

output:write(macro.process(input:read "*a", env))

