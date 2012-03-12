
require "nova.common"
require "nova.object"

local protoclass = {}
do

  protoclass.published = false

  protoclass.prepublish_metods = {}

  protoclass.postpublish_methods = {}

  function protoclass.prepublish_methods:__newindex(key, value)
    
  end

  function protoclass.postpublish_methods:__call (...)
    return nova.object(self:make_prototype(...))
  end

  function protoclass.postpublish_methods:make_prototype (...)
    return self.protoclass
  end

  function

end

nova.class = nova.object(protoclass)

nova.class:publish()

--- LuaNova's class module.
module("nova.class")
do

end

