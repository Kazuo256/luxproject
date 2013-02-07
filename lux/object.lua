
--- LUX's object module.
-- This module is used to create objects from prototypes, through the use of
-- the lux.object.new() method. It also defines a reference to a nil object,
-- which may be acquired with lux.object.nilref().
module ("lux.object", package.seeall) do

  --- Local instance of the "nil object".
  local nilref_ = {}

  --- Local instance of the base object.
  local base_object = {}
  
  --- Returns the representation of the nil object.
  -- @return An object reference to the nil object.
  function nilref()
    return nilref_
  end
  
  -- Recursive initialization.
  local function init (obj, super)
    if not super then return end
    init(obj, super:__super())
    if super.__init then
      local init_type = type(super.__init)
      if init_type == "function" then
        super.__init(obj)
      elseif init_type == "table" then
        for k,v in pairs(super.__init) do
          if not rawget(obj, k) then
            obj[k] = clone(v)
          end
        end
      end
    end
  end
  
  --- Creates a new object from a prototype.
  -- If the self object has an <code>__init</code> field as a function, it will
  -- be applied to the new object. If it has an <code>__init</code> field as a
  -- table, its contents will be cloned into the new object.
  -- @param prototype A table containing the object's methods and the default
  --                  values of its attributes.
  function base_object:new (prototype)
    prototype = prototype or {}
    self.__index = rawget(self, "__index") or self
    setmetatable(prototype, self)
    init(prototype, self)
    return prototype;
  end

  --- Creates a new object from a prototype.
  function new (prototype)
    return base_object:new(prototype)
  end

  --- Clones an object.
  -- @return A clone of this object.
  function base_object:clone ()
    if type(self) ~= "table" then return self end
    local cloned = {}
    for k,v in pairs(self) do
      cloned[k] = clone(v)
    end
    local super = base_object.__super(self)
    return super and super.new and super:new(cloned) or cloned
  end

  function clone (obj)
    return base_object.clone(obj)
  end
  
  --- Returns the super class of an object.
  -- @return The super class of an object.
  function base_object:__super ()
    return self ~= lux.object and getmetatable(self) or nil
  end

  --- Makes a class module inherit from a table.
  -- This function is to be used only when declaring modules, like this:
  -- <p><code>
  -- module ("my.module", lux.object.inherit(some_table))
  -- </code></p>
  -- This essentially makes the module inherit everything indexable from the
  -- given table. It also turns the module into an object.
  -- @param super A table from which the module will inherit.
  function inherit (super)
    return function (class)
      class.__index = super
      base_object:new(class)
    end
  end

end

