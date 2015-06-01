
package.path = package.path .. ";./lib/?.lua"

local class = require 'lux.oo.class2'

Example = class:new{}

function Example:instance (attr1, attr2)
  
  local x, y = 42, 1337

  function self:getXY()
    return x, y
  end

  function self:foo ()
    print("foo", attr1, attr2)
    x, y = x+y, x*y
  end

end

function Example:fromArray (array)
  return Example(unpack(array))
end

obj = Example('asd', 'dsa')
obj2 = Example:fromArray({true, false})

obj:foo()
obj2:foo()

local NotExample = class:new{}

function NotExample:instance ()
  
  Example:extend(self, {}, function () end)

  function self:__call ()
    print "called obj"
  end

end

obj3 = NotExample()
obj3:foo()
obj3()
