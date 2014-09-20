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

local Object  = require 'lux.Object'
local Feature = Object:new {}

Feature.__init = {
  context = {},
  helper = Object,
  onDefinition = function () error "Undefined callback 'onDefinition'" end,
  onRequest = function () error "Undefined callback 'onRequest'" end
}

local function onHelpUsage(help)
  return function (_, key)
    local tool = help[key]
    if tool then
      if type(tool) == 'function' then
        return help:__bind(key)
      else
        return tool
      end
    else
      return (help.fallback or {})[key]
    end
  end
end

function Feature:__newindex(name, chunk)
  local env = {}
  local help = self.helper:new{ definition = env }
  setmetatable(env, { __index = onHelpUsage(help) })
  assert(require 'lux.portable' .loadWithEnv(chunk, env)) ()
  self:onDefinition(name, env)
end

function Feature:__index(name)
  return self:onRequest(name)
end

return Feature

