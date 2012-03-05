
local class_meta = { __index = getfenv() }

--- LuaNova's Object Oriented API module.
module("nova.class", function (t) setmetatable(t, class_meta) end)

function class_meta:__call (...)
  return {}
end



