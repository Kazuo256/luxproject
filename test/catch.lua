
package.path = package.path..";./lib/?.lua"

local catch = require 'lux.std' .catch

local function rand ()
  return (math.random() > .5) and 1
end

function with_catch ()
  for x in catch(rand()) do
    x = x + x
  end
end

function without_catch ()
  local x = rand()
  if x then
    x = x + x
  end
end

function profile (method, seed)
  math.randomseed(seed)
  local start = os.clock()
  for i=1,10000000 do
    method()
  end
  return os.clock() - start
end

local seed = ... or os.time()
local t1 = profile(with_catch, seed)
local t2 = profile(without_catch, seed)

print("With catch:", t1)
print("No catch:", t2)
