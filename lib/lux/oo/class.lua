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

--- LUX's class-based object-oriented feature.
--  This module provides a feature for defining classes. It is very different
--  from the prototype-based version. It is faster, but uses more memory.
--  @module oo.class

--- Stuff happens here
--  @table
local class = {}

local scope_meta = {}
local no_op = function () end

local function makeConstructor (definition)
  return function (the_class, ...)
    local self = setmetatable({ __class = the_class }, scope_meta)
    assert(require 'lux.portable' .loadWithEnv(definition, self)) (self)
    setmetatable(self, nil);
    -- Call constructor if available
    (self[the_class.name] or no_op) (self, ...)
    return setmetatable(self, { __index = _G })
  end
end

local function onDefinition (classes, name, definition)
  assert(not classes[name], "Redefinition of class '"..name.."'")
  local new_class = {
    name = name
  }
  setmetatable(new_class, { __call = makeConstructor(definition) })
  rawset(classes, name, new_class)
end

function scope_meta:__newindex (key, value)
  if type(value) == 'function' then
    rawset(self, key, function(_, ...) return value(...) end)
  end
end

return setmetatable(class, { __newindex = onDefinition })

