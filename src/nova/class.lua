
require "nova.object"

local meta = { __index = getfenv() }

do
  --- LuaNova's class module.
  module("nova.class", function (t) setmetatable(t, meta) end)
  
  function meta:__call (...)
    local t = ...
    return nova.object(t)
  end
  
end

