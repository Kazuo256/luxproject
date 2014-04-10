
require 'lux.functional'

local lambda = lux.functional

function before ()
  -- nothing for now
end

function test_reverse_1 ()
  local a = lambda.reverse(1)
  assert(a == 1)
end

function test_reverse_2 ()
  local a, b = lambda.reverse(1,2)
  assert(a == 2)
  assert(b == 1)
end

function test_reverse_3 ()
  local a, b, c = lambda.reverse(1,2,3)
  assert(a == 3)
  assert(b == 2)
  assert(c == 1)
end

function test_reverse_7 ()
  local a, b, c, d, e, f, g = lambda.reverse(1,2,3,4,5,6,7)
  assert(a == 7)
  assert(b == 6)
  assert(c == 5)
  assert(d == 4)
  assert(e == 3)
  assert(f == 2)
  assert(g == 1)
end

function test_reverse_7_with_nils ()
  local a, b, c, d, e, f, g = lambda.reverse(1,2,nil,4,nil,6,7)
  assert(a == 7)
  assert(b == 6)
  assert(c == nil)
  assert(d == 4)
  assert(e == nil)
  assert(f == 2)
  assert(g == 1)
end

function test_expand_zero_times_hello ()
  local a1 = lambda.expand(0, 'hello')
  assert(a1 == nil)
end

function test_expand_3_times_hello ()
  local a1, a2, a3, a4 = lambda.expand(3, 'hello')
  assert(a1 == 'hello')
  assert(a2 == 'hello')
  assert(a3 == 'hello')
  assert(a4 == nil)
end

