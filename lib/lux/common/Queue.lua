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

--- An array-based queue.
--  @classmod lux.struct.Queue
local Queue = require 'lux.class' :new{}

local function nothing()
  return nothing
end

local assert    = assert
local select    = select
local coroutine = coroutine

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

  --- Tells how many elements are in the queue.
  --  @treturn number The amount of elements in the queue
  function obj.getSize ()
    return size
  end

  --- Tells whether the queue is empty.
  --  @treturn boolean True if the queue is empty, false otherwise
  function obj.isEmpty ()
    return size <= 0
  end

  --- Tells whether the queue is full.
  function obj.isFull ()
    return size >= max
  end

  --- Pushes a value into the queue.
  function obj.push (item, ...)
    if not item and select('#', ...) == 0 then
      return
    elseif item then
      assert(not obj.isFull(), "queue is full, cannot push any more values")
      queue[tail] = item
      tail = (tail%max) + 1
      size = size + 1
      return obj.push(...)
    end
  end

  --- Gets the next element of the queue without popping it.
  --  @return The next element in the queue
  function obj.next()
    return queue[head]
  end

  --- Pops a value from the queue.
  function obj.pop (n)
    if n and n <= 0 then
      return
    else
      assert(not obj.isEmpty(), "queue is empty, there are no values to pop")
      local value = queue[head]
      queue[head] = nothing
      head = (head%max) + 1
      size = size - 1
      return value, obj.pop(n and (n-1) or 0)
    end
  end

  --- Pops all values from the queue.
  function obj.popAll ()
    return obj.pop(size)
  end

  local function iterator (state)
    local diff = state.diff
    if diff < size then
      state.diff = diff + 1
      local index = head + diff
      return queue[index <= max and index or index - max]
    end
  end

  --- Iterates through the queue popping everything.
  function obj.each ()
    return iterator, {diff = 0}
  end

  local function pop_iterator ()
    return not obj.isEmpty() and obj.pop(1) or nil
  end

  function obj.popEach ()
    return pop_iterator
  end

end

--- Constructors
--  @section constructors

--- Construct from sequence
--  @tparam sequence seq A sequence containing the new queue's content
function Queue:fromSequence(seq)
  local queue = Queue(#seq)
  queue.push(table.unpack(seq))
  return queue
end

return Queue
