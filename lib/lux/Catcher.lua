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

--- Interface for catching everything that is inserted in an object.
--  @classmod Catcher
local Catcher = require 'lux.Object' :new {}

Catcher.__init = {}

--- Makes key-value pairs inserted on a Catcher be handled by the
--  <code>onCatch()</code> callback.
--  @param key    The key used in the insertion
--  @param value  The value inserted
function Catcher:__newindex(key, value)
  self:onCatch(key, value)
end

--- A callback that is called when an insertion is caught.
--  It must be implemented when extending this prototype.
--  @param key    The key used in the insertion
--  @param value  The value inserted
function Catcher:onCatch(key, value)
  error "Undefined callback 'onCatch'"
end

return Catcher

