
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
  local function init (obj, super)
    if not super then return end
    init(obj, super:__super())
    if super.__init then
      local init_type = type(super.__init)
      if init_type == "function" then
        super.__init(obj)
      elseif init_type == "table" then
        for k,v in pairs(super.__init) do
          obj[k] = clone(v)
        end
      end
    end
  end
  
  --- Method. Creates a new object from a prototype.
  -- @param prototype A table containing the object's methods and the default
  --                  values of its attributes.
  function nova.object:new (prototype)
    prototype = prototype or {}
    self.__index = rawget(self, "__index") or self
    setmetatable(prototype, self)
    init(prototype, self)
    return prototype;
  end

  --- Clones an object.
  -- @return A clone of this object.
  function nova.object:clone ()
    if type(self) ~= "table" then return self end
    print "cloning..."
    table.foreach(self, print)
    local cloned = {}
    for k,v in pairs(self) do
      cloned[k] = clone(v)
    end
    local super = __super(self)
    return super and super.new and super:new(cloned) or cloned
  end
  
  --- Method. Returns the super class of an object.
  -- @return The super class of an object.
  function nova.object:__super ()
    return self ~= nova.object and getmetatable(self) or nil
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

