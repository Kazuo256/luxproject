
package.path = package.path..";./lib/?.lua"

require 'lux.macro.Processor'
require 'lux.stream'

local input = lux.stream.File:new {
  path = "./test/input.in.lua"
}
local output = lux.stream.File:new {
  path = "./test/input.lua",
  mode = "w"
}

local proc = lux.macro.Processor:new {}

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

proc:process(input, output)

