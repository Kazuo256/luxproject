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

--- A module-packing feature for more comfortable `require`-ing
local packs = {}
local pack_meta = {}

function pack_meta:__index (name)
  local result = rawget(self, name)
  if not result then
    local maybe = require(self.__name.."."..name)
    result = rawget(self, name) or maybe
    rawset(pack, result)
  end
  return result
end

return function (name)
  local pack = packs[name]
  if not pack then
    pack = setmetatable({ __name = name }, pack_meta)
    packs[name] = pack
  end
  return pack
end
