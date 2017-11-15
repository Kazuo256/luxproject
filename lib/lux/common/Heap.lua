--[[
--
-- Copyright (c) 2017 USPGameDev
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

require 'lux.portable'

local Heap = require 'lux.class' :new{}

local function _cmp(a, b)
  return a[2] < b[2]
end

local function _maintain_up(array, i)
  local parent = math.floor(i/2)

  if parent > 0 and _cmp(array[i], array[parent]) then
    local swap = array[i]
    array[i] = array[parent]
    array[parent] = swap
    return _maintain_up(array, parent)
  end
end

local function _maintain_down(array, i, limit)
  local left = i*2
  local right = left+1
  local higher = false

  if left <= limit and _cmp(array[left], array[i]) then
    higher = left
  else
    higher = i
  end

  if right <= limit and _cmp(array[right], array[i]) then
    higher = right
  end

  if higher ~= i then
    local swap = array[i]
    array[i] = array[higher]
    array[higher] = swap
    return _maintain_down(array, higher, limit)
  end
end

function Heap:instance(_obj)

  local _items  = {}
  local _size   = 0

  function _obj.clear()
    for i=_size,1,-1 do
      _items[i] = nil
    end
    _size = 0
  end

  function _obj.pop()
    local item = _items[1]
    _items[1] = _items[_size]
    _items[_size] = nil
    _size = _size - 1
    _maintain_down(_items, 1, _size)
    return table.unpack(item)
  end

  function _obj.push(e, rank)
    rank = rank or 0
    _size = _size + 1
    _items[_size] = {e, rank}
    _maintain_up(_items, _size)
  end

  function _obj.isEmpty()
    return _size <= 0
  end

end

return Heap

