
require 'lux.list'

local list = lux.list

-- list:push_back

l = list:new{}
l:push_back(1,2,3)
assert(l.head[1] == 1)
assert(l.head[2][1] == 2)
assert(l.head[2][2][1] == 3)

-- list:push_front

l = list:new{}
l:push_front(1,2,3)
assert(l.head[1] == 3)
assert(l.head[2][1] == 2)
assert(l.head[2][2][1] == 1)

-- constructor

l = list:new{1,2,3}
assert(l.head[1] == 1)
assert(l.head[2][1] == 2)
assert(l.head[2][2][1] == 3)

-- list:empty

l = list:new{}
assert(l:empty())
l:push_front(1)
assert(not l:empty())

-- list:size()

l = list:new{}
assert(l:size() == 0)
l:push_front(1)
assert(l:size() == 1)
l:push_back(2,3)
assert(l:size() == 3)

-- list:front and list:back

l = list:new{1,2,3}
assert(l:front() == 1)
assert(l:back() == 3)

