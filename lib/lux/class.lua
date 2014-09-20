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

local Catcher = require 'lux.Catcher'
local Object  = require 'lux.Object'

-- First, we define the BaseClass prototype
local BaseClass = Object:new {
  name = "BaseClass",
  constructor = function (...) end
}

-- It supports traditional constructor syntax
function BaseClass:__call (...)
  local new_instance = self.prototype:new{}
  self.constructor (new_instance, ...)
  return new_instance
end

-- Here we start the main feature of this module
local class = require 'lux.Feature' :new {}

-- The feature helper
class.helper = Object:new {
  fallback = _G
}

local function makeCatch(definition, catch)
  return function(_, key, value)
    definition[catch][key] = value
  end
end

function class.helper:__construct()
  self.definition.methods = {}
  self.definition.members = {}
  self.method = Catcher:new { onCatch = makeCatch(self.definition, 'methods') }
  self.member = Catcher:new { onCatch = makeCatch(self.definition, 'members') }
end

-- The feature's callbacks
function class:onDefinition (name, definition)
  local NewClass = BaseClass:new {
    name = name,
    constructor = definition.methods[name],
    prototype = Object:new{}
  }
  NewClass.__init = definition
  NewClass.prototype.__init = definition.members
  for k,v in pairs(definition.methods) do
    if type(v) == 'function' then
      NewClass.prototype[k] = v
    end
  end
  self.context[name] = NewClass
end

function class:onRequest (name)
  return self.context[name]
end

return class

