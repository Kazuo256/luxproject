
local meta = { __index = getfenv() }

do
  --- LuaNova's object module.
  module("nova.object", function (t) setmetatable(t, object_meta) end)
  
  local nilref_ = {}
  
  --- Returns an object reference which represents the nil object.
  function nilref()
    return nilref_
  end
  
  --- Creates a new object from a prototype.
  -- @param prototype A table containing the objects methods and metamethods,
  --                  along with the default values of its attributes.
  function meta:__call (prototype)
    local new_obj = {}
    prototype.__index = prototype
    setmetatable(new_obj, prototype)
    return new_obj
  end

end

