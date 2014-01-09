
require 'lux.macro.Processor'

local proc

function before ()
  proc = lux.macro.Processor:new {}
end

function test_OnlyChunk ()
  local output = proc:processString
    [[stuff$assert(true)$]]
  assert(output == 'stuff')
end

