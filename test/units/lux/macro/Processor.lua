
require 'lux.macro.Processor'

local proc
local fixtures = {
  {
    name = "no_macro",
    input = [[
asdasdasd
asdasdasd
asdasdasd
]],
    output = [[
asdasdasd
asdasdasd
asdasdasd
]]
  },
  {
    name = "single_direct",
    input = [[stuff $=5+4=$]],
    output = [[stuff 9]]
  },
  {
    name = "single_direct_nomacro",
    input = [[stuff $=5+4=]],
    output = [[stuff $=5+4=]]
  },
  {
    name = "single_for",
    input = [[
$: for i=1,3 do
foo
$: end
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
$: for i=1,3 do
$: for j=1,2 do :$bar $: end :$
$: end
]],
    output = [[
bar bar 
bar bar 
bar bar 
]]
  },
  {
    name = "single_progressive_for",
    input = [[
$: for i=1,5 do
$: for j=1,i do :$*$: end :$
$: end
]],
    output = [[
*
**
***
****
*****
]]
  }
}

function before ()
  proc = lux.macro.Processor:new {}
end

for _,fixture in ipairs(fixtures) do
  getfenv()["test_"..fixture.name] = function ()
    local check, result = pcall(
      function ()
        return proc:processString(fixture.input)
      end
    )
    if fixture.fails then
      assert(not check, "("..result..")")
    else
      assert(result == fixture.output, "("..result..")")
    end
  end
end

