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

--- LUX's object module.
-- This module is used to create objects using prototypes, through
-- the lux.Object:new() method.
module ("lux", package.seeall)

--- Local instance of the base object.
Object = {}

-- Recursive initialization.
local function init (obj, super)
  if not super then return end
  if super.__init then
    if type(super.__init) == "table" then
      for k,v in pairs(super.__init) do
        if not rawget(obj, k) then
          obj[k] = Object.clone(v)
        end
      end
    end
  end
  init(obj, super:__super())
  if super.__construct then
    if type(super.__construct) == "function" then
      super.__construct(obj)
    end
  end
end

--- Creates a new object from a prototype.
--  If the self object has an <code>__construct</code> field as a function, it
--  will be applied to the new object. If it has an <code>__init</code> field as
--  a table, its contents will be cloned into the new object.
--  @param prototype
--    A table containing the object's methods and the default values of its
--    attributes.
function Object:new (prototype)
  prototype = prototype or {}
  self.__index = rawget(self, "__index") or self
  setmetatable(prototype, self)
  init(prototype, self)
  return prototype;
end

--- Returns the super class of an object.
--  @return The super class of an object.
function Object:__super ()
  return getmetatable(self)
end

--- Binds a method call.
--  @param method_name
--    The name of the method to be bound.
--  @return A function binding a call to the given method.
function Object:__bind (method_name)
  return function (...)
    return self[method_name](self, ...)
  end
end

--- Clones the object.
--  @return A clone of this object.
function Object:clone ()
  if type(self) ~= "table" then return self end
  local cloned = {}
  for k,v in pairs(self) do
    cloned[k] = Object.clone(v)
  end
  local super = Object.__super(self)
  return super and super.new and super:new(cloned) or cloned
end

return Object

