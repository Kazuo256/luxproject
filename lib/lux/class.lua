--[[
--
-- Copyright (c) 2013-2015 Wilson Kazuo Mizutani
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

--- A class-based implementation object oriented programming.
--  Ironically, this is actually a prototype, which means it inherits from
--  @{lux.prototype}, but otherwise provides its own mechanism for OOP.
--
--  Be sure to check @{instance}, @{inherit} and @{super} usages.
--  @prototype lux.class
local class = require 'lux.prototype' :new {}

--- Defines how an instance of the class should be constructed.
--  @param obj The to-be-constructed object
--  @param ... Any arguments required by the construction
--  @usage
--  local MyClass = require 'lux.class' :new{}
--  function MyClass:instance (obj)
--    local a_number = 42
--    function obj:show ()
--      print(a_number)
--    end
--  end
function class:instance (obj, ...)
  -- Does nothing
end

--- Makes this class inherit from another.
--  @param another_class The being inherited from
function class:inherit (another_class)
  assert(not self.__parent, "Multiple inheritance not allowed!")
  assert(another_class:__super() == class, "Must inherit a class!")
  self.__parent = another_class
end

--- The class constructor.
--  @param ... The constructor parameters as specified in @{instance}
function class:__call (...)
  local obj = {
    __class = self,
    __extended = not self.__parent
  }
  self:instance(obj, ...)
  assert(obj.__extended, "Missing call to parent constructor!")
  return setmetatable(obj, obj)
end

--- Calls the parent class' constructor.
--  @param obj The object being constructed by the child class
--  @param ... The parent class' constructor parameters
function class:super (obj, ...)
  assert(not obj.__extended, "Already called parent constructor!")
  self.__parent:instance(obj, ...)
  obj.__extended = true
end

return class
