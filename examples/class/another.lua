
package.path = package.path .. ";./lib/?.lua"

local class = require 'lux.oo.class'

function class:Another()
  local x, y = 0, 0
  function Another (the_x, the_y)
    x, y = the_x, the_y
  end
  function move (dx, dy)
    x = self:getX(33)+dx
    y = y+dy
    print('moved!', x, y)
  end
  function getX(tmp)
    return tmp or x
  end
end

p = class.Another(2,2)

p:move(1, -1)


