
require "nova.object"

local protoclass = {}
do
  protoclass.__index = getfenv()
  function protoclass:__call (...)
    -- TODO
  end
end

nova.class = nova.object(protoclass)

do
  --- LuaNova's class module.
  module("nova.class")
  
  
end

