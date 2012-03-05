
local object_meta = package.seeall {}

--- LuaNova's object module.
module("nova.object", function (t) setmetatable(t, object_meta) end)

--- Creates a new object.
-- 
function object_meta:__call (attributes, methods)
  local new_obj = {}
  -- TODO add attributes and methods
  return new_obj
end

