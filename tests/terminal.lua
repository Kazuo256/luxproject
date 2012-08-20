
local _print = print
local color = require "lux.externals.ansicolors"

local checks = { head = 1, tail = 1 }

local function expect(...)
  checks[checks.tail] = { ... }
  checks.tail = checks.tail + 1
end

function print (...)
  local args = checks[checks.head]
  checks.head = checks.head + 1
  for i,v in ipairs{...} do
    assert(v == args[i], "print arg #"..i.." did not match")
  end
end

local term = require "lux.terminal"

expect "hey"
term.line "hey"

expect (color.red "hey")
term.line "<red>hey<reset>"

expect (color.bright .. color.green "hey")
term.line "<bright><green>hey<reset>"

