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

--- This module allows for portable programming in Lua.
-- It currently support versions 5.1 through 5.3.
local portable = {}

local lambda = require 'lux.functional'

local lua_major, lua_minor = (function (a,b)
  return tonumber(a), tonumber(b)
end) (_VERSION:match "(%d+)%.(%d+)")

assert(lua_major >= 5 and lua_minor >= 1) -- for sanity

local env_stack = {}
local push = table.insert
local pop = table.remove

function portable.isVersion(major, minor)
  return major == lua_major and minor == lua_minor
end

function portable.minVersion(major, minor)
  return major <= lua_major and minor <= lua_minor
end

if lua_minor <= 1 then
  table.unpack = unpack
  table.pack = function (...) return { n = select('#', ...), ... } end
  local old_load = load
  load = function (chunk, name, mode, env)
    --FIXME do not ignore mode parameter!
    local func
    if type(chunk) == 'string' then
      func = loadstring(chunk, name)
    else
      func = old_load(chunk, name)
    end
    setfenv(func, env)
    return func
  end
  local old_loadfile = loadfile
  loadfile = function (file, mode, env)
    --FIXME do not ignore mode parameter!
    local func = old_loadfile(file)
    setfenv(func, env)
    return func
  end
end

return portable
