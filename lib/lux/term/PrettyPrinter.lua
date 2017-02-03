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

local port  = require 'lux.portable'
local color = require 'lux.term.ansicolors'

local PrettyPrinter = require 'lux.class' :new {}

local out       = io.output()
local tostring  = tostring

function PrettyPrinter:instance(_ENV, tags)

  if port.isVersion(5,1) then
    setfenv(1, _ENV)
  end

  tags = tags or {}

  local function log_print (color_tag, id, ...)
    out:write(
      tostring(color.bright),
      tostring(color[color_tag]),
      "[" .. id .. "]",
      tostring(color.clear),
      " ", ...
    )
    out:write '\n'
  end

  function report (...)
    return log_print('white', tags.report or 'report', ...)
  end

  function failure (...)
    return log_print('red', tags.failure or 'failure', ...)
  end

  function success (...)
    return log_print('green', tags.success or 'success', ...)
  end

end

return PrettyPrinter
