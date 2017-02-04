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
  file:close()                             
  return load(code, mod)
end

if port.minVersion(5,2) then
  package.searchers[2] = searchAndPreprocess
else
  package.loaders[2] = searchAndPreprocess
end
