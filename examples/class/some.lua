
package.path = package.path .. ";./lib/?.lua"

local class = require 'lux.class'

Example = class:new{}

function Example:instance (obj, attr1, attr2)
  
  local x, y = 42, 1337

  function obj:getXY()
    return x, y
  end

  function obj:foo ()
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

NotExample:inherit(Example)

function NotExample:instance (obj)
  
  self:super(obj, {}, function () end)

  function obj:__call ()
    print "called obj"
  end

end

obj3 = NotExample()
obj3:foo()
obj3()
