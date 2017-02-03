--[[
--
-- Copyright (c) 2013-2017 Wilson Kazuo Mizutani
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to
-- deal in the Software without restriction, including without limitation the
-- rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
-- sell copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE
--
--]]

--- LUX's list class.
--  This is a linked list implementation in Lua.
--  @prototype lux.datastruct.List
local List = require 'lux.prototype' :new {
  head  = nil,
  tail  = nil,
  n     = 0
}

require 'lux.portable' -- for table.unpack

--- The list's constructor may take a sequence of values to initialize the list
--  with.
function List:__construct ()
  self:pushBack(table.unpack(self))
end

--- Tells if the list is empty.
--  @return True if and only if the list is empty.
function List:empty ()
  return self.n <= 0
end

--- Tells the size of the list.
--  @return The number of elements in the list.
function List:size ()
  return self.n
end

--- Pushes elements at the end of the list.
--  @param value First pushed element.
--  @param  ... Other elements to be pushed.
--  @return The list itself.
function List:pushBack (value, ...)
  if not value then return self end
  local new_node = { value, nil, self.tail }
  if self:empty() then
    self.head = new_node
  else
    self.tail[2] = new_node
  end
  self.tail = new_node
  self.n = self.n+1
  return self:pushBack(...)
end

--- Pushes elements at the begining of the list.
--  @param  ... Elements to be pushed.
--  @return The list itself
function List:pushFront (...)
  local new_front = List:new{...}
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
function List:front ()
  return self.head and self.head[1]
end

--- Gives the last element of the list.
--  @return The last element of the list.
function List:back ()
  return self.tail and self.tail[1]
end

--- Pops elements from the end of the list.
--  @param  n Number of elements to pop.
--  @param  ... For internal use.
--  @return The popped elemnts.
function List:popBack (n, ...)
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
  return self:popBack(n-1, popped[1], ...)
end

--- Pops elements from the the begining of the list.
--  @param  n Number of elements to pop.
--  @param  t For internal use.
--  @return The popped elements.
function List:popFront (n, t)
  n = n or 1
  t = t or {}
  if n <= 0 or self:empty() then return table.unpack(t) end
  local popped = self.head
  if self.head[2] then
    self.head[2][3] = nil
  else
    self.tail = nil
  end
  self.head = popped[2]
  self.n = self.n-1
  table.insert(t, popped[1])
  return self:popFront(n-1, t)
end

--- Iterate through the list.
--  The iteration variable is an accessor function:
--  <p><code>l = list:new{...}</code>
--  <p><code>for v in l:each() do print(v()) end</code></p>
--  @return Iterator function.
function List:each ()
  local node = self.head
  return function ()
    if not node then return end
    local value = node[1]
    node = node[2]
    return function () return value end
  end
end

return List
