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

local Object        = require 'lux.Object'
local Specification = require 'lux.macro.Specification'

--- This class process files using a macro specification.
-- @classmod macro.Processor
local Processor = Object:new {}

Processor.__init = {
  spec = Specification:new {}
}

local generator_env = {}

function generator_env.mq (str)
  return "[[" .. str .. "]]"
end

local function makeDirectiveEnvironment (outstream, env)
  env = env or Object.clone(generator_env)
  env.output = outstream
  return setmetatable(env, { __index = getfenv(0) })
end

function Processor:handleDirective (mod, code)
  if mod == '=' then
    return [[output:send(]] .. code .. ")\n"
  elseif mod == ':' then
    return code.."\n"
  elseif mod == '|' then
    return "output:send('[[' .. " .. code .. " .. ']]')\n"
  end
  return ''
end

function Processor:process (instream, outstream, env)
  local code = [[assert(output)]].."\n"
  local count = 1
  local str = instream:receive "*a"
  for input, mod, directive, step in self.spec:iterateDirectives(str) do
    code = code .. [[output:send ]] .. "[[\n" .. input .. "]]\n"
    code = code .. self:handleDirective(mod, directive)
    count = count + step
  end
  code = code .. [[output:send ]] .. "[[\n" .. str:sub(count) .. "]]\n"
  setfenv(assert(loadstring(code)), makeDirectiveEnvironment(outstream, env)) ()
end

return Processor

