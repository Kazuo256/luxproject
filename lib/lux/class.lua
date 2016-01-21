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

--- A class-based implementation object oriented programming.
--  Ironically, this is actually a prototype, which means it inherits from
--  @{lux.prototype}, but otherwise provides its own mechanism for OOP.
--  Be sure to check @{instance}, @{inherit} and @{super} usages.
--  @usage
--  local MyClass = require 'lux.class' :new{}
--  @prototype lux.class
local class = require 'lux.prototype' :new {}

--- Defines how an instance of the class should be constructed.
--  This function is supposed to only be overriden, not called from the user's
--  side. By populating the <code>obj</code> parameter provided in this
--  factory-like strategy method is what creates class instances in this OOP
--  feature. 
--  @tparam object obj The to-be-constructed object
--  @param ... Arguments required by the construction
--  @usage
--  local MyClass = require 'lux.class' :new{}
--  function MyClass:instance (obj, x)
--    local a_number = 42
--    function obj:show ()
--      print(a_number + x)
--    end
--  end
function class:instance (obj, ...)
  -- Does nothing
end

--- Makes this class inherit from another.
--  This guarantess that instances from the former are also instances from the
--  latter. The semantics differs from that of inheritance through prototyping!
--  Also, it is necessary to call @{super} inside the current class'
--  @{instance} definition method since there is no way of guessing how the
--  parent class' constructor should be called.
--  @tparam class another_class The class being inherited from
--  @usage
--  local class = require 'lux.class'
--  local ParentClass = class:new{}
--  local ChildClass = class:new{}
--  ChildClass:inherit(ParentClass)
--  @see class:super
function class:inherit (another_class)
  assert(not self.__parent, "Multiple inheritance not allowed!")
  assert(another_class:__super() == class, "Must inherit a class!")
  self.__parent = another_class
end

--- The class constructor.
--  This is how someone actually instantiates objects from this class system.
--  After having created a new class and defined its @{instance} method, calling
--  the class itself behaves as expected by calling the constructor that will
--  use the @{instance} method to create the object.
--  @param ... The constructor parameters as specified in the @{instance}
--  @treturn object A new instance from the current class.
--  definition
function class:__call (...)
  local obj = {
    __class = self,
    __extended = not self.__parent
  }
  self:instance(obj, ...)
  assert(obj.__extended, "Missing call to parent constructor!")
  return setmetatable(obj, obj)
end

class.__init = {
  __call = class.__call
}

--- Calls the parent class' constructor.
--  Should only be called inside this class' @{instance} definition method when
--  it inherits from another class.
--  @tparam object obj The object being constructed by the child class
--  @param ... The parent class' constructor parameters
--  @usage
--  -- After ChildClass inherited ParentClass
--  function ChildClass:instance (obj, x, y)
--    self:super(obj, x + y) -- parent's constructor parameters
--    -- Finish instancing
--  end
--  @see class:inherit
function class:super (obj, ...)
  assert(not obj.__extended, "Already called parent constructor!")
  self.__parent:instance(obj, ...)
  obj.__extended = true
end

return class
