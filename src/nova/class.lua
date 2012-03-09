
require "nova.common"
require "nova.object"

local protoclass = {}
do

  protoclass.__index = _G

  function protoclass:__call (...)
    local newclass = nova.object(protoclass)
    return newclass
  end

  protoclass.methods

end

nova.class = nova.object(protoclass)

--- LuaNova's class module.
module("nova.class")
do

end

