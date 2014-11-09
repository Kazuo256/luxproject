
package.path = package.path .. ";./lib/?.lua"

local class = require 'lux.oo.class'

function class:Another()
  local x, y = 0, 0
  function Another (the_x, the_y)
    x, y = the_x, the_y
    print("new", x, y)
  end
  function move (dx, dy)
    x = self:getX(33)+dx
    y = y+dy
    print('moved!', x, y)
  end
  function getX(tmp)
    return tmp or x
  end
  function __meta:__call (...)
    print("call", x, y, ...)
  end
  function clone ()
    return Another(x, y)
  end
end

p = class.Another(2,2)

p:move(1, -1)

p:clone() 'test'

function class.Another.inheritAs:Master()

  local z

  function Master()
    super(42, 42)
    z = getX() + 10
  end

  function show ()
    print "hey"
    self("child", z)
  end

end

q = class.Master()

q:move(4, 4)
q:show()


