
package.path = package.path .. ";./lib/?.lua"

local class = require 'lux.class'
--local InputCallback = require 'etc.input.Callback'

function class.FlyingCake()
  
  -- module 'org.kool'

  -- extends(class.Serializable)
  
  -- __feature 'accepts' (InputCallback)

  members = {
    name = "",
    x = 0,
    y = 0
  }

  function method:FlyingCake(name, position_provider)
    self.name = name
    self.x, self.y = position_provider:provide()
  end

  function method:getName ()
    return self.name
  end

  --[[

  static = {
    count = 0
  }

  __attr 'move' {}
  function method.setPos(x,y)
    self.x = x
    self.y = y
  end

  --]]

end

