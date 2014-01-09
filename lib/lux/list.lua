--[[
--
-- Copyright (c) 2013-2014 Wilson Kazuo Mizutani
--
-- This software is provided 'as-is', without any express or implied
-- warranty. In no event will the authors be held liable for any damages
-- arising from the use of this software.
--
-- Permission is granted to anyone to use this software for any purpose,
-- including commercial applications, and to alter it and redistribute it
-- freely, subject to the following restrictions:
--
--    1. The origin of this software must not be misrepresented; you must not
--       claim that you wrote the original software. If you use this software
--       in a product, an acknowledgment in the product documentation would be
--       appreciated but is not required.
--
--    2. Altered source versions must be plainly marked as such, and must not be
--       misrepresented as being the original software.
--
--    3. This notice may not be removed or altered from any source
--       distribution.
--
--]]

--- LUX's list class.
--  This is a linked list implementation in Lua.
module ('lux', package.seeall)

local object = require 'lux.object'

list = object.new {
  head  = nil,
  tail  = nil,
  n     = 0
}

--- The list's constructor may take a sequence of values to initialize the list
--  with.
function list:__construct ()
  self:push_back(unpack(self))
end

--- Tells if the list is empty.
--  @return True if and only if the list is empty.
function list:empty ()
  return self.n <= 0
end

--- Tells the size of the list.
--  @return The number of elements in the list.
function list:size ()
  return self.n
end

--- Pushes elements at the end of the list.
--  @param  ... Elements to be pushed.
--  @return The list itself.
function list:push_back (value, ...)
  if not value then return self end
  local new_node = { value, nil, self.tail }
  if self:empty() then
    self.head = new_node
  else
    self.tail[2] = new_node
  end
  self.tail = new_node
  self.n = self.n+1
  return self:push_back(...)
end

--- Pushes elements at the begining of the list.
--  @param  ... Elements to be pushed.
--  @return The list itself
function list:push_front (...)
  local new_front = list:new{...}
  if not new_front:empty() then
    new_front.tail[2] = self.head
    if self:empty() then
      self.tail = new_front.tail
    else
      self.head[3] = new_front.tail
    end
    self.head = new_front.head
  end
  self.n = self.n+new_front.n
  return self
end

--- Gives the first element of the list.
--  @return The first element of the list.
function list:front ()
  return self.head and self.head[1]
end

--- Gives the last element of the list.
--  @return The last element of the list.
function list:back ()
  return self.tail and self.tail[1]
end

--- Pops elements from the end of the list.
--  @param  n Number of elements to pop.
--  @param  ... For internal use.
--  @return The popped elemnts.
function list:pop_back (n, ...)
  n = n or 1
  if n <= 0 or self:empty() then return ... end
  local popped = self.tail
  if self.tail[3] then
    self.tail[3][2] = nil
  else
    self.head = nil
  end
  self.tail = popped[3]
  self.n = self.n-1
  return self:pop_back(n-1, popped[1], ...)
end

--- Pops elements from the the begining of the list.
--  @param  n Number of elements to pop.
--  @param  t For internal use.
--  @return The popped elements.
function list:pop_front (n, t)
  n = n or 1
  t = t or {}
  if n <= 0 or self:empty() then return unpack(t) end
  local popped = self.head
  if self.head[2] then
    self.head[2][3] = nil
  else
    self.tail = nil
  end
  self.head = popped[2]
  self.n = self.n-1
  table.insert(t, popped[1])
  return self:pop_front(n-1, t)
end

--- Iterate through the list.
--  The iteration variable is an accessor function:
--  <p><code>l = list:new{...}</code>
--  <p><code>for v in l:each() do print(v()) end</code></p>
--  @return Iterator function.
function list:each ()
  local node = self.head
  return function ()
    if not node then return end
    local value = node[1]
    node = node[2]
    return function () return value end
  end
end

