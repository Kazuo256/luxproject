
package.path = package.path..";./lib/?.lua"

local prototype = require "lux.prototype"

local function show (t, name)
  print("Dumping "..tostring(t).." ("..name..")")
  for k,v in pairs(table) do
    print(k,v)
  end
end

local function dump (name)
  show(_G[name], name)
end

A = prototype:new { x = 20 }
dump "A"

A2 = A:clone()
dump "A2"

B = A:new { y = 10 }
B.__init = { z = 99 }
dump "B"

B2 = B:clone()
dump "B2"

B.__init.another = A:new { x = 44 }
B3 = B:clone()
dump "B3"

C = B:new {}
dump "C"

