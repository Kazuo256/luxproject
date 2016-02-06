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

--- This script takes over Lua's require mechanism and enforces that all lua
--  loaded scripts be pre-processed by LUX's macro engine.
--  @module lux.macro.takeover

local port  = require 'lux.portable'
local path  = require 'lux.path'
local macro = require 'lux.macro'

local lua_loader

if port.minVersion(5,2) then
  lua_loader = package.searchers[2]
else
  lua_loader = package.loaders[2]
end

local function notFoundMsg(mod, checks)
  msg = ""
  for _,file in ipairs(checks) do
    msg = msg .. string.format("\n\tno file '%s'", file)
  end
  return msg
end

local function searchAndPreprocess (mod)
  local filename,checks = path.search(mod)
  if not filename then
    return nil, notFoundMsg(mod, checks)
  end
  local file = io.open(filename, 'r')
  local code = macro.process(file:read(port.minVersion(5,3) and 'a' or '*a'),
                             { port = port })
  return load(code, mod)
end

if port.minVersion(5,2) then
  package.searchers[2] = searchAndPreprocess
else
  package.loaders[2] = searchAndPreprocess
end

