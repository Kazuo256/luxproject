--[[
--
-- Copyright (c) 2013 Wilson Kazuo Mizutani
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

require 'lux.Object'

local obj

function before ()
  obj = lux.Object:new {
    x = 20
  }
end

function test_new_with_attribute ()
  local the_obj = lux.Object:new {
    y = 30
  }
  assert(the_obj.y == 30)
end

function test_default_attribute ()
  local child = obj:new{}
  assert(child.x == 20)
end

function test_init_set ()
  obj.__init = {
    y = { 10 }
  }
  local child = obj:new{}
  assert(child.y[1] == 10)
end

function test_init_replace ()
  obj.__init = {
    y = { 10 }
  }
  local child = obj:new{ y = { "huh!?" } }
  assert(child.y[1] == "huh!?")
end

function test_init_override ()
  obj.__init = {
    y = { 10 }
  }
  local child = obj:new{}
  child.__init = {
    y = { 30 }
  }
  local grandchild = child:new{}
  assert(grandchild.y[1] == 30)
end

function test_construct_set ()
  obj.__construct = function (self)
    self.y = { 10 }
  end
  local child = obj:new{}
  assert(child.y[1] == 10)
end

function test_construct_replace ()
  obj.__construct = function (self)
    self.y = { 10 }
  end
  local child = obj:new{ y = { 30 } }
  assert(child.y[1] == 10)
end

function test_construct_override ()
  obj.__construct = function (self)
    self.y = { 10 }
  end
  local child = obj:new{}
  child.__construct = function (self)
    self.y = { 30 }
  end
  local grandchild = child:new{}
  assert(grandchild.y[1] == 30)
end

function test_clone ()
  local clone = obj:clone()
  assert(clone.x == obj.x)
  obj.x = 5
  assert(clone.x ~= obj.x)
  assert(clone.x == 20)
end
