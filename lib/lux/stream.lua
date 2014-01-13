--[[
--
-- Copyright (c) 2013-2014 Wilson Kazuo Mizutani
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

--- This module holds classes that represent streams of data.
module ('lux.stream', package.seeall)

require 'lux.object'

StreamBase = lux.object.new {}

function StreamBase:send (data)
  -- Abstract method.
end

function StreamBase:receive (quantity)
  -- Abstract method
  return nil
end

--------------------------------------------------------------------------------

String = StreamBase:new {
  buffer = ""
}

function String:send (data)
  self.buffer = self.buffer .. data
end

function String:receive (quantity)
  if quantity == '*a' then
    local buffer = self.buffer
    self.buffer = nil
    return self.buffer
  else
    error("not implemented, sorry.")
  end
end

--------------------------------------------------------------------------------

File = StreamBase:new {
  loader = io.open,
  path = "",
  mode = "r"
}

function File:__construct ()
  self.file = self.loader(self.path, self.mode)
end

function File:send (data)
  self.file:write(data)
end

function File:receive (quantity)
  return self.file:read(quantity)
end

