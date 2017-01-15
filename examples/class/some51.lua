
package.path = package.path .. ";./lib/?.lua"

require 'lux.portable'

local print = print
local setfenv = setfenv

local class = require 'lux.class'

Example = class:new{}

function Example:instance (obj, attr1, attr2)

  setfenv(1, obj)

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

function NotExample:instance (obj)

  setfenv(1, obj)

  self:super(obj, {}, function () end)

  function __operator:call ()
    print "called obj"
  end

end

obj3 = NotExample()
obj3.foo()
obj3()
