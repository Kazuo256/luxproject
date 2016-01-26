--[[
--
-- Copyright (c) 2013-2016 Wilson Kazuo Mizutani
--
-- This software is provided 'as-is', without any express or implied
-- warranty. In no event will the authors be held liable for any damages
-- arising from the use of this software.
--
-- Permission is granted to anyone to use this software for any purpose,
-- including commercial applications, and to alter it and redistribute it
-- freely, subject to the following restrictions:
--
--    1. The origin of this software must not be misrepresented; you must not
--       claim that you wrote the original software. If you use this software
--       in a product, an acknowledgment in the product documentation would be
--       appreciated but is not required.
--
--    2. Altered source versions must be plainly marked as such, and must not be
--       misrepresented as being the original software.
--
--    3. This notice may not be removed or altered from any source
--       distribution.
--
--]]

--- A module that provides a macro processor
--  @module lux.macro
local macro = {}

local port = require 'lux.portable'

--- Processes the given string expanding the macros. There are two kinds of
--  expanded macros:
--
--  1. Lines starting with `#`: the whole line is inserted in the generator code
--  2. Expressions wrapped in `$(...)`: the expression is inserted into that
--     part of the string
--
--  The implementation is based on
--  [this article](http://lua-users.org/wiki/SimpleLuaPreprocessor).
--
--  @tparam string str
--  String to be processed.
--
--  @tparam table env
--  The Lua environment used to process the string.
--
--  @treturn string
--  The expanded string
--
--  @usage
--  local macro = require 'lux.macro'
--  local expanded = macro.process("the answer is $(6*x)", { x = 7 })
--  assert(expanded == "the answer is 42")
function macro.process (str, env)
  assert(port.minVersion(5, 3), "This function requires Lua 5.3 or later")
  local chunks = {}
  env = env or {}
  table.insert(chunks, "local tostring = ...")
  table.insert(chunks, "local output = ''")
  table.insert(chunks,
               "local function out (str) output = output .. tostring(str) end")
  for line in str:gmatch "([^\n]*\n?)()" do
    if line:find "^#" then
      table.insert(chunks, line:sub(2))
    else
      local last = 1
      for text, expr, index in line:gmatch "(.-)$(%b())()" do
        last = index
        if text ~= "" then
          table.insert(chunks, string.format("out %q", text))
        end
        table.insert(chunks, string.format("out%s", expr))
      end
      table.insert(chunks, string.format("out %q", line:sub(last)))
    end
  end
  table.insert(chunks, "return output\n")
  local code = table.concat(chunks, '\n')
  local check, result = pcall(assert(load(code, 'macro', 't', env)), tostring)
  if not check then
    return error(result .. " in macro code:\n" .. code)
  else
    return result
  end
end

return macro

