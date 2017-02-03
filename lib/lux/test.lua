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

--- LUX's testing module.
--  @module lux.test
local test = {}

local term = require 'lux.term.color'
local port = require 'lux.portable'

--- Runs an unit test.
function test.unit (unit_name)
  local tests = {}
  local test_mttab = { __newindex = tests, __index = _G }
  local unit_script = "test/units/"..string.gsub(unit_name, "%.", "/")..".lua"
  local script, err = loadfile(unit_script, 'bt', setmetatable({}, test_mttab))
  if not script then
    print(err)
  end
  script()
  local before = tests.before or function () end
  for key,case in pairs(tests) do
    local name = string.match(key, "^test_([%w_]+)$")
    if type(case) == 'function' and name then
      before()
      local check, err = pcall(case)
      if check then
        term.write("<bright><green>[Success]<clear> ")
      else
        term.write("<bright><red>[Failure]<clear> ")
      end
      term.write("<bright>"..unit_name.."/"..name.."<clear>\n")
      if err then
        term.line(err)
      end
    end
  end
end

return test
