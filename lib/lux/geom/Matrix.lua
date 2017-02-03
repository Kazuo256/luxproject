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

local Vector = require 'lux.geom.Vector'

Matrix = require 'lux.prototype' :new {
  __type = "Matrix",
  -- Matrix columns.
  [1] = nil,
  [2] = nil,
  [3] = nil,
  [4] = nil
}

function Matrix:__construct ()
  for i = 1,4 do
    if self[i] then
      self[i] = Vector:new(self[i])
    else
      self[i] = Vector.axis(i)
    end
  end
end

function Matrix:__tostring ()
  return  "("..tostring(self[1]).."\n"..
          " "..tostring(self[2]).."\n"..
          " "..tostring(self[3]).."\n"..
          " "..tostring(self[4])..")"
end

function Matrix:transpose ()
  return Matrix:new {
    { self[1][1], self[2][1], self[3][1], self[4][1] },
    { self[1][2], self[2][2], self[3][2], self[4][2] },
    { self[1][3], self[2][3], self[3][3], self[4][3] },
    { self[1][4], self[2][4], self[3][4], self[4][4] },
  }
end

local function multiplyByScalar (a, m)
  return Matrix:new {
    a*m[1],
    a*m[2],
    a*m[3],
    a*m[4]
  }
end

function Matrix.__mul (lhs, rhs)
  if type(lhs) == "number" then
    return multiplyByScalar(lhs,rhs)
  elseif type(rhs) == "number" then
    return multiplyByScalar(rhs, lhs)
  elseif rhs.__type == "Vector" then
    return lhs[1]*rhs[1] + lhs[2]*rhs[2] + lhs[3]*rhs[3] + lhs[4]*rhs[4]
  elseif lhs.__type == "Vector" then
    return Vector:new {lhs*rhs[1], lhs*rhs[2], lhs*rhs[3], lhs*rhs[4]}
  else -- assume both are matrices
    return Matrix:new {
      lhs*rhs[1],
      lhs*rhs[2],
      lhs*rhs[3],
      lhs*rhs[4]
    }
  end
end

return Matrix
