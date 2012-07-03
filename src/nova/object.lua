
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
  -- @param prototype A table containing the object's methods and the default
  --                  values of its attributes.
  function meta:new (proto)
    proto = proto or {}
    self.__index = rawget(self, "__index") or self
    setmetatable(proto, self)
    return proto;
  end

  local table_mttab = { __index = table }

  function meta.table ()
    local t = {}
    setmetatable(t, table_mttab)
    return t
  end

end

