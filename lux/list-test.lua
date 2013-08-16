
require 'lux.list'

local list = lux.list
local l

function before ()
  l = list:new{}
end

function test_push_back ()
  l:push_back(1,2,3)
  assert(l.head[1] == 1)
  assert(l.head[2][1] == 2)
  assert(l.head[2][2][1] == 3)
  assert(l.tail[1] == 3)
  assert(l.tail[3][1] == 2)
  assert(l.tail[3][3][1] == 1)
end

function test_push_front ()
  l:push_front(1,2,3)
  assert(l.head[1] == 1)
  assert(l.head[2][1] == 2)
  assert(l.head[2][2][1] == 3)
  assert(l.tail[1] == 3)
  assert(l.tail[3][1] == 2)
  assert(l.tail[3][3][1] == 1)
end

function test_constructor ()
  l = list:new{1,2,3}
  assert(l.head[1] == 1)
  assert(l.head[2][1] == 2)
  assert(l.head[2][2][1] == 3)
end

function test_empty ()
  assert(l:empty())
  l:push_front(1)
  assert(not l:empty())
end

function test_size ()
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
end

function test_front_and_back ()
  l = list:new{1,2,3}
  assert(l:front() == 1)
  assert(l:back() == 3)
end

function test_pop_back ()
  l = list:new{1,2,3}
  assert(l:pop_back(1) == 3)
  local a,b = l:pop_back(2)
  assert(a == 1 and b == 2, tostring(a)..","..tostring(b))
end

function test_pop_front ()
  l = list:new{1,2,3}
  assert(l:pop_front(1) == 1)
  local a,b = l:pop_front(2)
  assert(a == 2 and b == 3, tostring(a)..","..tostring(b))
end

function test_each ()
  l = list:new{1,2,nil,4}
  local i = 1
  local t = {1,2,nil,4}
  for v in l:each() do
    assert(v() == t[i])
    i = i+1
  end
end

