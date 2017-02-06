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

local Queue = require 'lux.common.Queue'

local equality_fail_msg = [[equality test failed:
  Expected: %s
  Got: %s]]

local function assert_eq(got, expected, context)
  context = context and ("\n  " .. context) or ""
  assert(got == expected, equality_fail_msg:format(expected, got) .. context)
end

local iterator_test_cases = {
  {
    max = 5,
    input = {
      { "push", 1, 2, 3, 4 }
    },
    output = { 1, 2, 3, 4 }
  },
  {
    max = 4,
    input = {
      { "push", 1, 2, 3, 4 }
    },
    output = { 1, 2, 3, 4 }
  },
  {
    max = 3,
    input = {
      { "push", 1, 2, 3 },
      { "pop", 2 },
      { "push", 4 },
    },
    output = {3, 4}
  },
  {
    max = 3,
    input = {
      { "push", 1, 2, 3 },
      { "pop", 2 },
      { "push", 4, 5 },
    },
    output = {3, 4, 5}
  }
}

function test_each ()
  for i,case in ipairs(iterator_test_cases) do
    local q = Queue(case.max)
    for _,cmd in ipairs(case.input) do
      q[cmd[1]](table.unpack(cmd, 2))
    end
    local n = 0
    for value in q.each() do
      n = n + 1
      assert(n <= q.getSize(), "iterator went past the end")
      assert_eq(value, case.output[n], "Test case " .. tostring(i))
    end
    assert(n == q.getSize(), "iterator stopped early")
  end
end
