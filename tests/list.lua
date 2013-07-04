
require 'lux.list'

local list = lux.list

--[[ list:push_back ]]--

l = list:new{}
l:push_back(1,2,3)
assert(l.head[1] == 1)
assert(l.head[2][1] == 2)
assert(l.head[2][2][1] == 3)
assert(l.tail[1] == 3)
assert(l.tail[3][1] == 2)
assert(l.tail[3][3][1] == 1)

--[[ list:push_front ]]--

l = list:new{}
l:push_front(1,2,3)
assert(l.head[1] == 1)
assert(l.head[2][1] == 2)
assert(l.head[2][2][1] == 3)
assert(l.tail[1] == 3)
assert(l.tail[3][1] == 2)
assert(l.tail[3][3][1] == 1)

--[[ constructor ]]--

l = list:new{1,2,3}
assert(l.head[1] == 1)
assert(l.head[2][1] == 2)
assert(l.head[2][2][1] == 3)

--[[ list:empty ]]--

l = list:new{}
assert(l:empty())
l:push_front(1)
assert(not l:empty())

--[[ list:size() ]]--

l = list:new{}
assert(l:size() == 0)
l:push_front(1)
assert(l:size() == 1)
l:push_back(2,3)
assert(l:size() == 3)
-- just to be sure
assert(l.head[1] == 1)
assert(l.head[2][1] == 2)
assert(l.head[2][2][1] == 3)
assert(l.tail[1] == 3)
assert(l.tail[3][1] == 2)
assert(l.tail[3][3][1] == 1)

--[[ list:front and list:back ]]--

l = list:new{1,2,3}
assert(l:front() == 1)
assert(l:back() == 3)

--[[ list:pop_back ]]--

l = list:new{1,2,3}
assert(l:pop_back(1) == 3)
a,b = l:pop_back(2)
assert(a == 1 and b == 2)

