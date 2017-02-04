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

--- A module that provides a macro processor
--  @module lux.macro
local macro = {}

local port = require 'lux.portable'

local stmt_regex = "^%s"
local expr_regex = "(.-)%s(%%b())()"

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
function macro.process (str, env, stmt_token, expr_token)
  env = env or {}
  stmt_token = stmt_token or '@'
  expr_token = expr_token or '$'
  local chunks = {}
  table.insert(chunks, "local tostring = ...")
  table.insert(chunks, "local output = ''")
  table.insert(chunks,
               "local function out (str) output = output .. tostring(str) end")
  for line in str:gmatch "([^\n]*\n?)()" do
    if line:find(stmt_regex:format(stmt_token)) then
      table.insert(chunks, line:sub(2))
    else
      local last = 1
      for text, expr, index in line:gmatch(expr_regex:format(expr_token)) do
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
  local chunk
  if port.minVersion(5,2) then
    chunk = assert(load(code, 'macro', 't', env))
  else
    chunk = assert(loadstring(code, 'macro'))
    setfenv(chunk, env)
  end
  local check, result = pcall(chunk, tostring)
  if not check then
    return error(result .. " in macro code:\n" .. code)
  else
    return result
  end
end

return macro
