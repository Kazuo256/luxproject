
package.path = package.path .. ";./lib/?.lua"

local class = require 'lux.oo.class'

function class:Another(the_x, the_y)
  local x, y = the_x, the_y
  print "new"
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

print(class.Another)
p = class:Another(2,2)

p:move(1, -1)

p:clone() 'test'

function class:Master()

  __inherit.Another(self, 42, 42)

  local z = self:getX() + 10

  print("HAHA")

  function show ()
    print "hey"
    self("child", z)
  end

end

q = class:Master()

q:move(4, 4)
q:show()


