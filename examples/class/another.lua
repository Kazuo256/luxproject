
package.path = package.path .. ";./lib/?.lua"

local example = require 'lux.oo.class' :package 'example'

function example:Another(the_x, the_y)
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

print(example.Another)
p = example.Another(2,2)

p:move(1, -1)

p:clone() 'test'

function example:Master()

  example.Another:inherit(self, 42, 42)

  local z = self:getX() + 10

  print("HAHA")

  function self:show ()
    print "hey"
    self("child", z)
  end

end

q = example.Master()

q:move(4, 4)
q:show()


