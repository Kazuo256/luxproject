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

local prototype = require 'lux.prototype'

local obj

function before ()
  obj = prototype:new {
    x = 20
  }
end

function test_new_with_attribute ()
  local the_obj = prototype:new {
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

function test_bind ()
  local check = 0
  function obj:someMethod ()
    check = check + 1
  end
  local bind = obj:__bind 'someMethod'
  assert(check == 0)
  bind()
  assert(check == 1)
  bind()
  assert(check == 2)
end
