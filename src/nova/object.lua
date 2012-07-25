
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
  
  -- Recursive initialization.
  local function init (obj)
    if obj then
      init(obj.__super)
      obj:__init()
    end
  end
  
  --- Method. Creates a new object from a prototype.
  -- @param prototype A table containing the object's methods and the default
  --                  values of its attributes.
  function nova.object:new (prototype)
    prototype = prototype or {}
    self.__index = rawget(self, "__index") or self
    setmetatable(prototype, self)
    prototype.__super = self
    init(prototype)
    return prototype;
  end

  --- Makes a class module inherit from a table.
  -- This function is to be used only when declaring modules, like this:
  -- <p><code>
  -- module ("my.module", nova.object.inherit(some_table))
  -- </code></p>
  -- This essentially makes the module inherit everything indexable from the
  -- given table. It also turns the module into an object.
  -- @param super A table from which the module will inherit.
  function inherit (super)
    return function (class)
      class.__index = super
      nova.object:new(class)
    end
  end

end

