
require "nova.common"

local meta = { __index = getfenv() }

--- LuaNova's object module.
-- This module is used to create objects from prototypes, through the use of
-- the nova.object() metamethod. It also defines a reference to a nil object,
-- which may be acquired with nova.object.nilref().
module("nova.object", nova.common.metabinder(meta))
--function (t) setmetatable(t, meta) end)
do
  --- Local instance of the "nil object".
  local nilref_ = {}
  
  --- Returns the representation of the nil object.
  -- @return An object reference to the nil object.
  function nilref()
    return nilref_
  end
  
  --- Creates a new object from a prototype.
  -- @param prototype A table containing the objects methods and metamethods,
  --                  along with the default values of its attributes.
  function meta:__call (prototype)
    local new_obj = {}
    prototype.__index = prototype.__index or prototype
    setmetatable(new_obj, prototype)
    return new_obj
  end

end

