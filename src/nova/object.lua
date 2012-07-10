
--- LuaNova's object module.
-- This module is used to create objects from prototypes, through the use of
-- the nova.object:new() method. It also defines a reference to a nil object,
-- which may be acquired with nova.object.nilref().
module ("nova.object", package.seeall) do
  --- Local instance of the "nil object".
  local nilref_ = {}
  
  --- Returns the representation of the nil object.
  -- @return An object reference to the nil object.
  function nilref()
    return nilref_
  end
  
  --- Method. Creates a new object from a prototype.
  -- @param prototype A table containing the object's methods and the default
  --                  values of its attributes.
  function nova.object:new (prototype)
    prototype = prototype or {}
    self.__index = rawget(self, "__index") or self
    setmetatable(prototype, self)
    if prototype.__init then prototype:__init() end
    return prototype;
  end

  --- Metatable for table objects.
  local table_mttab = { __index = table }

  --- Creates a new table object.
  -- A table object is just like any table, with the addition that it has
  -- methods all corresponding to all the functions from the standard
  -- <code>table</code> module.
  -- @return A new table object.
  function table ()
    local t = {}
    setmetatable(t, table_mttab)
    return t
  end

end

