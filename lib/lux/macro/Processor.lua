--[[
--
-- Copyright (c) 2013-2014 Wilson Kazuo Mizutani
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

--- This class process files using a macro configuration.
module ('lux.macro', package.seeall)

require 'lux.object'
require 'lux.functional'
require 'lux.macro.Configuration'

Processor = lux.object.new {}

Processor.__init = {
  config = Configuration:new{}
}

local function makeDirectiveEnvironment ()
  return setmetatable({}, { __index = getfenv(0) })
end

function Processor:handleDirective (mod, code)
  if mod == '=' then
    return [[output = output .. (]] .. code .. ")\n"
  elseif mod == ':' then
    return code.."\n"
  end
  return ''
end

function Processor:processString (str)
  local env = makeDirectiveEnvironment()
  local code = [[local output = ""]].."\n"
  local count = 1
  for input, mod, directive, tail in str:gmatch("(.-)"..self.config.directive) do
    assert(tail == "\n" or tail == mod.."$")
    code = code .. [[output = output .. ]] .. "[[\n" .. input .. "]]\n"
    code = code .. self:handleDirective(mod, directive)
    count = count + #input + 1 + #mod + #directive + #tail
  end
  code = code .. [[output = output .. ]] .. "[[\n" .. str:sub(count) .. "]]\n"
  code = code .. [[return output]] .. "\n"
  return assert(loadstring(code)) ()
end

