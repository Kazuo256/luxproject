
package.path = package.path .. ";./lib/?.lua"

local class = require 'lux.oo.class'

function class:Another(the_x, the_y)
  local x, y = the_x, the_y
  print "new"
  function self:move (dx, dy)
    x = self:getX(33)+dx
    y = y+dy
    print('moved!', x, y)
  end
  function self:getX(tmp)
    return tmp or x
  end
  function self.__meta:__call (...)
    print("call", x, y, ...)
  end
  function self:clone ()
    return self.__class(x, y)
  end
end

local Another = class:forName 'Another'
print(Another)
p = Another(2,2)

p:move(1, -1)

p:clone() 'test'

function class:Master()

  Another:inherit(self, 42, 42)

  local z = self:getX() + 10

  print("HAHA")

  function self:show ()
    print "hey"
    self("child", z)
  end

end

local Master = class:forName 'Master'

q = Master()

q:move(4, 4)
q:show()


