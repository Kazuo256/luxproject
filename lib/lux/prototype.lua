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

--- A prototype-based implementation for object oriented programming.
--  It returns the root prototype object, with which you can create new objects
--  using @{prototype:new}. Objects created this way automatically inherit
--  fields and methods from their parent, and may override them. It is not
--  possible to inherit from multiple objects.
--  @prototype lux.prototype
local prototype = {}

-- Recursive initialization.
local function init (obj, super)
  if not super then return end
  if super.__init then
    if type(super.__init) == "table" then
      for k,v in pairs(super.__init) do
        if not rawget(obj, k) then
          rawset(obj, k, prototype.clone(v))
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
--  If the self object has a `__construct` field as a function, it
--  will be applied to the new object. If it has an `__init` field as
--  a table, its contents will be cloned into the new object.
--  @param object A table containing the object's fields.
--  @usage
--    object = prototype:new { x = 42, text = "cheese" }
function prototype:new (object)
  object = object or {}
  self.__index = rawget(self, "__index") or self
  setmetatable(object, self)
  init(object, self)
  return object;
end

--- Returns the parent of an object.
--  Note that this may get confusing if you use prototypes as classes, because
--  `obj:__super()` will most likely return the object's class, not
--  its class' parent class. In this case, it is better and more explicit to use
--  `Class:__super()` directly.
--  @return The object's parent.
function prototype:__super ()
  return getmetatable(self)
end

--- Binds a method call.
--  This is just an auxiliary method. Specially useful when you need to provide
--  a callback function as a method from a specific object.
--  @param method_name The name of the method being bound.
--  @return A function binding the given method to the object.
--  @usage
--  local object = prototype:new { x = 42 }
--
--  function object:get()
--    return x
--  end
--
--  local get1 = object:new{}:__bind 'get'
--  local get2 = object:new{ x = 1337 }:__bind 'get'
--
--  -- Will print "42 1337"
--  print(get1(), get2())
function prototype:__bind (method_name)
  return function (...)
    return self[method_name](self, ...)
  end
end

--- Clones the object.
--  Not to be confused with @{prototype:new}. This recursevely clones an object
--  and its fields. __It may go into an infinite loop if there is a cyclic
--  reference inside the object__. This function may also be used to
--  clone arbitrary Lua tables.
--  @return A clone of this object.
function prototype:clone ()
  if type(self) ~= "table" or self == prototype then return self end
  local cloned = {}
  for k,v in pairs(self) do
    cloned[k] = prototype.clone(v)
  end
  local super = prototype.__super(self)
  return super and super.new and super:new(cloned) or cloned
end

return prototype
