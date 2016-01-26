
local macro = require 'lux.macro'
local port  = require 'lux.portable'

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
    input = [[stuff $(5+4)]],
    output = [[stuff 9]]
  },
  {
    name = "single_direct_nomacro",
    input = [[stuff $(5+4]],
    output = [[stuff $(5+4]]
  },
  {
    name = "single_for",
    input = [[
# for i=1,3 do
foo
# end
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
# for i=1,3 do
#   for j=1,2 do out 'bar ' end
#   out '\n'
# end
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
# for i=1,5 do
# for j=1,i do out '*' end
# out '\n'
# end
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
end

local function make_error_text (errmsg, result)
  return tostring(errmsg) .. " ("..tostring(result)..")\n"..debug.traceback()
end

for _,fixture in ipairs(fixtures) do
  _ENV["test_"..fixture.name] = function ()
    local result
    local check, errmsg = pcall(
      function ()
        result = macro.process(fixture.input, {})
      end
    )
    if fixture.fails then
      assert(not check, make_error_text(errmsg, result))
    else
      assert(check, make_error_text(errmsg, result))
      assert(result == fixture.output,
             make_error_text("Unexpected result", result))
    end
  end
end

