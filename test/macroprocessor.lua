
package.path = package.path..";./lib/?.lua"

local Processor = require 'lux.macro.Processor'
local stream    = require 'lux.stream'

local input = stream.File:new {
  path = "./test/input.in.lua"
}
local output = stream.File:new {
  path = "./test/input.lua",
  mode = "w"
}

local proc = Processor:new {}

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

