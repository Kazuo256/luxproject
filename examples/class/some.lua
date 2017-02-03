
package.path = package.path .. ";./lib/?.lua"

local print = print

local class = require 'lux.class'

Example = class:new{}

function Example:instance (_ENV, attr1, attr2)

  local x, y = 42, 1337

  function getXY()
    return x, y
  end

  function foo ()
    print("foo", attr1, attr2)
    x, y = x+y, x*y
  end

end

function Example:fromArray (array)
  return Example(table.unpack(array))
end

obj = Example('asd', 'dsa')
obj2 = Example:fromArray({true, false})

obj.foo()
obj2.foo()

local NotExample = class:new{}

NotExample:inherit(Example)

function NotExample:instance (_ENV)

  self:super(_ENV, {}, function () end)

  function __operator:call ()
    print "called obj"
  end

end

obj3 = NotExample()
obj3.foo()
obj3()
