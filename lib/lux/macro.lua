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
--  @module lux.module
local macro = {}

local port        = require 'lux.portable'
local functional  = require 'lux.functional'

local evil_regex = "(.-)%$([=!])(.-)([=!]?[%$\n])"

local function directiveIterator (str)
  local yield = coroutine.yield
  for input, mod, directive, tail in str:gmatch(evil_regex) do
    assert(tail == "\n" or tail == mod.."$",
           "\nstart/close mismatch: ("..mod..","..tail..")")
    yield(input, mod, directive, #input + 1 + #mod + #directive + #tail)
  end
end

local function iterateDirectives (str)
  return coroutine.wrap(functional.bindLeft(directiveIterator, str))
end

local function handleDirective (mod, code)
  if mod == '=' then
    return "output = output .. " .. code .. "\n"
  elseif mod == '!' then
    return code.."\n"
  end
  return ''
end

function macro.process (str, env)
  env = env or {}
  local code = "local output = ''\n"
  local count = 1
  for input, mod, directive, step in iterateDirectives(str) do
    code = code .. "output = output .. " .. "[[\n" .. input .. "]]\n"
    code = code .. handleDirective(mod, directive)
    count = count + step
  end
  code = code .. "output = output .. " .. "[[\n" .. str:sub(count) .. "]]\n"
  code = code .. "return output\n"
  return assert(load(code, "macro_code", 'bt', env)) ()
end

return macro

