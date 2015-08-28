--[[
--
-- Copyright (c) 2013-2015 Wilson Kazuo Mizutani
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

--- An array-based queue.
--  @classmod lux.struct.Queue
local Queue = require 'lux.class' :new{}

function Queue:instance (obj, max)

  assert(max > 1)

  local queue = {}
  local head, tail = 1, 1
  local size = 0

  for i=1,max do
    queue[i] = false
  end

  function obj:isEmpty ()
    return size <= 0
  end

  function obj:isFull ()
    return size >= max
  end

  function obj:push (item, ...)
    if not item and select('#', ...) == 0 then
      return
    elseif item then
      assert(not self:isFull(), "Queue full: "..size.."/"..max)
      queue[tail] = item
      tail = (tail%max) + 1
      size = size + 1
    end
    return self:push(...)
  end

  function obj:pop (n)
    if n and n <= 0 then
      return
    else
      assert(not self:isEmpty())
      local value = queue[head]
      queue[head] = false
      head = (head%max) + 1
      size = size - 1
      return value, self:pop(n and (n-1) or 0)
    end
  end

  function obj:popAll ()
    return self:pop(size)
  end

  local function iterate ()
    while not obj:isEmpty() do
      coroutine.yield(obj:pop())
    end
  end

  function obj:popEach ()
    return coroutine.wrap(iterate)
  end

end

return Queue
