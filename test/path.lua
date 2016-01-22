
local path = require 'lux.path'

for i=1,10 do
  path.add("foo"..i, "./"..i.."/?.lua")
end

print(package.path)

path.remove("foo3")
print(package.path)

path.remove("foo5")
print(package.path)

path.remove("foo7")
print(package.path)

