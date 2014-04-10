
package.path = package.path..";./lib/?.lua"

local Object = require "lux.Object"

local function show (t, name)
  print("Dumping "..tostring(t).." ("..name..")")
  table.foreach(t, print)
end

local function dump (name)
  show(_G[name], name)
end

A = Object.new { x = 20 }
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

