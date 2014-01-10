
require 'lux.macro.Processor'

local proc
local fixtures = {
  {
    name = "single_direct_code",
    input = [[stuff $= 5+4$]],
    output = [[stuff 9]]
  },
  {
    name = "single_for",
    input = [[
$for i=1,3 do$
foo
$end$
]],
    output = [[
foo
foo
foo
]]
  },
  {
    name = "single_nested_for",
    input = [[
$for i=1,3 do$
$  for j=1,2 do$bar $end$

$end$
]],
    output = [[
bar bar 
bar bar 
bar bar 
]]
  }
}

function before ()
  proc = lux.macro.Processor:new {}
end

for _,fixture in ipairs(fixtures) do
  getfenv()["test_"..fixture.name] = function ()
    local result = proc:processString(fixture.input)
    assert(result == fixture.output, "result:\n"..result)
  end
end

