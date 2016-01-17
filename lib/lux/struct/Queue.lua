--[[
--
-- Copyright (c) 2013-2016 Wilson Kazuo Mizutani
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

local function nothing()
  return nothing
end

--- Constructors
--  @section constructors

--- Default constructor.
--  @function Queue
--  @tparam integer max The queue max capacity
function Queue:instance (obj, max)

  assert(max > 1)

  local queue = {}
  local head, tail = 1, 1
  local size = 0

  for i=1,max do
    queue[i] = nothing
  end

  --- Methods
  --  @section methods

  --- Tells whether the queue is empty.
  --  @treturn boolean True if the queue is empty, false otherwise
  function obj:isEmpty ()
    return size <= 0
  end

  --- Tells whether the queue is full.
  function obj:isFull ()
    return size >= max
  end

  --- Pushes a value into the queue.
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

  --- Pops a value from the queue.
  function obj:pop (n)
    if n and n <= 0 then
      return
    else
      assert(not self:isEmpty())
      local value = queue[head]
      queue[head] = nothing
      head = (head%max) + 1
      size = size - 1
      return value, self:pop(n and (n-1) or 0)
    end
  end

  --- Pops all values from the queue.
  function obj:popAll ()
    return self:pop(size)
  end

  local function iterate ()
    while not obj:isEmpty() do
      coroutine.yield(obj:pop())
    end
  end

  --- Iterates through the queue popping everything.
  function obj:popEach ()
    return coroutine.wrap(iterate)
  end

end

--- Constructors
--  @section constructors

--- Construct from sequence
--  @tparam sequence seq A sequence containing the new queue's content
function Queue:fromSequence(seq)
  local queue = Queue(#seq)
  queue:push(table.unpack(seq))
  return queue
end

return Queue
