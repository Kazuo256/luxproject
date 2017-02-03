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

local Vector = require 'lux.prototype' :new {
  -- Vector coordinates.
  0,
  0,
  0,
  0,
  -- Internal information.
  __type = "Vector"
}

local point = Vector:new {
  [4] = 1,
  __type = "point"
}

function Vector.axis (i)
  return Vector:new {
    i == 1 and 1 or 0,
    i == 2 and 1 or 0,
    i == 3 and 1 or 0,
    i == 4 and 1 or 0
  }
end

function Vector:__tostring ()
  return "("..self[1]..","..self[2]..","..self[3]..","..self[4]..")"
end

point.__tostring = Vector.__tostring

function Vector:__index (k)
  if k == "x" then return self[1] end
  if k == "y" then return self[2] end
  if k == "z" then return self[3] end
  if k == "w" then return self[4] end
  return getmetatable(self)[k]
end

point.__index = Vector.__index

function Vector:__newindex (k, v)
  if k == "x" then rawset(self, 1, v)
  elseif k == "y" then rawset(self, 2, v)
  elseif k == "z" then rawset(self, 3, v)
  elseif k == "w" then rawset(self, 4, v)
  else rawset(self, k, v) end
end

point.__newindex = Vector.__newindex

function Vector.__add (lhs, rhs)
  return Vector:new {
    lhs[1] + rhs[1],
    lhs[2] + rhs[2],
    lhs[3] + rhs[3],
    lhs[4] + rhs[4]
  }
end

function Vector.__sub (lhs, rhs)
  return Vector:new {
    lhs[1] - rhs[1],
    lhs[2] - rhs[2],
    lhs[3] - rhs[3],
    lhs[4] - rhs[4]
  }
end

point.__sub = Vector.__sub

local function multiplyByScalar (a, v)
  return Vector:new {
    a*v[1],
    a*v[2],
    a*v[3],
    a*v[4]
  }
end

function Vector.__mul (lhs, rhs)
  if type(lhs) == "number" then
    return multiplyByScalar(lhs,rhs)
  elseif type(rhs) == "number" then
    return multiplyByScalar(rhs, lhs)
  else -- assume both are Vector
    return lhs[1]*rhs[1] + lhs[2]*rhs[2] + lhs[3]*rhs[3] + lhs[4]*rhs[4]
  end
end

function Vector.__div (lhs, rhs)
  if type(rhs) == "number" then
    return multiplyByScalar(1.0/rhs, lhs)
  end
  return error "Cannot divide "..type(lhs).." by "..type(rhs).."."
end

function Vector:size ()
  return math.sqrt(
    self[1]*self[1] + self[2]*self[2] + self[3]*self[3] + self[4]*self[4]
  )
end

function Vector:normalized ()
  return self/self:size()
end

function Vector:set (x, y, z, w)
  self[1] = x or 0
  self[2] = y or 0
  self[3] = z or 0
  self[4] = w or 0
end

function Vector:add (v)
  self[1] = self[1] + v[1]
  self[2] = self[2] + v[2]
  self[3] = self[3] + v[3]
  self[4] = self[4] + v[4]
end

function Vector:sub (v)
  self[1] = self[1] - v[1]
  self[2] = self[2] - v[2]
  self[3] = self[3] - v[3]
  self[4] = self[4] - v[4]
end

function Vector:scale (s)
  self[1] = self[1] * s
  self[2] = self[2] * s
  self[3] = self[3] * s
  self[4] = self[4] * s
end

function Vector:map (f, ...)
  return Vector:new {
    f(self[1], ...),
    f(self[2], ...),
    f(self[3], ...),
    f(self[4], ...)
  }
end

function Vector:unpack ()
  return self[1], self[2], self[3], self[4]
end

return Vector
