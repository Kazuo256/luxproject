--[[
--
-- Copyright (c) 2013 Wilson Kazuo Mizutani
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
function list:__init ()
  for _,v in ipairs(self) do
    self:push_back(v)
  end
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
function list:push_back (value, next_value, ...)
  local new_node = { value, nil }
  if self:empty() then
    self.head = new_node
  else
    self.tail[2] = new_node
  end
  self.tail = new_node
  self.n = self.n+1
  if not next_value then
    return self
  else
    return self:push_back(next_value, ...)
  end
end

--- Pushes elements at the begining of the list.
--  @param  ... Elements to be pushed.
--  @return The list itself
function list:push_front (value, next_value, ...)
  self.head = { value, self.head }
  if not self.tail then
    self.tail = self.head
  end
  self.n = self.n+1
  if not next_value then
    return self
  else
    return self:push_front(next_value, ...)
  end
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

