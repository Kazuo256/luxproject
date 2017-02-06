--[[
--
-- Copyright (c) 2013-2017 Wilson Kazuo Mizutani
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to
-- deal in the Software without restriction, including without limitation the
-- rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
-- sell copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE
--
--]]

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
#   for j=1,2 do out 'bar;' end
#   out '\n'
# end
]],
    output = [[
bar;bar;
bar;bar;
bar;bar;
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
