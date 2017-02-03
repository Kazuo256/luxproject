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

--- LUX's functional programming module.
-- Some functional programming tools lay around here.
local functional = {}

--- Binds a function's first parameter to the given argument.
--
-- @tparam function f
-- function being bound.
--
-- @tparam any arg
-- The bound argument.
--
-- @treturn function
-- A function that, upon being called, does the same as f, but requires only
-- the arguments beyond the first one.
function functional.bindFirst (f, arg)
  return function (...)
    return f(arg, ...)
  end
end

--- Binds a function to the given (left-most) arguments.
-- The arguments must be passed in the apropriate order, according to the
-- function's specification.
--
-- @tparam function f
-- The function being binded.
--
-- @param arg1
-- The first bound argument.
--
-- @param[optchain] ...
-- The remaining bound arguments, in order.
--
-- @treturn function
-- A function that, upon being called, does the same as f, but requires only the
-- remaining right-most arguments that were not binded with it.
function functional.bindLeft (f, arg1, ...)
  if select('#', ...) == 0 then
    return functional.bindFirst(f, arg1)
  else
    return functional.bindLeft(functional.bindFirst(f, arg1), ...)
  end
end

--- Creates a <code>n</code>-curried function based on <code>f</code>.
--
-- @usage
-- local result = std.curry(print,2)
-- result (arg1) (arg2) (arg3, arg4, ...)
--
-- @tparam function f The function being curried.
--
-- @tparam[opt=1] integer n How much the function should be curried.
--
-- @treturn function An <code>n</code>-curried version of <code>f</code>.
function functional.curry (f, n)
  n = n or 1
  return function (...)
    local first, second = ...
    if n >= 1 and not second then
      if first then
        return functional.chain(bindLeft(f, first), n-1)
      else
        return functional.chain(f, n)
      end
    else
      return f(...)
    end
  end
end

local function doReverse (r, a, ...)
  if not a and select('#', ...) == 0 then
    return r()
  end
  local function aux ()
    return a, r()
  end
  return doReverse(aux, ...)
end

--- Reverses the order of the arguments.
-- @param ... Arbitrary arguments.
-- @return The arguments in reversed order.
function functional.reverse (...)
  return doReverse(function () end, ...)
end

--- Map function. Might overflow the stack and is not tail recursive.
--  @tparam function f An unary function
--  @param a First mapped element
--  @param ... Other to-be-mapped elements
--  @return All the results of applying f to the given elements one by one.
function functional.map (f, a, ...)
  if not a and select('#', ...) == 0 then
    return -- empty list of elements
  else
    return f(a), map(f, ...)
  end
end

--- Expand a value into a value list: value, value, ...
--  @tparam integer n The number of times to expand.
--  @param value The expanded value
--  @param ... For internal use inly.
--  @return A list of copies of value.
function functional.expand (n, value, ...)
  if n <= 0 then return ... end
  return functional.expand(n-1, value, value, ...)
end

return functional
