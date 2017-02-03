
package.path = package.path..";./lib/?.lua"

local _write = io.write
local color = require "ansicolors"

local checks = { head = 1, tail = 1 }

local function expect(...)
  checks[checks.tail] = { ... }
  checks.tail = checks.tail + 1
end

function io.write (...)
  local args = checks[checks.head]
  checks.head = checks.head + 1
  for i,v in ipairs{...} do
    assert(v == args[i], "print arg #"..i.." did not match")
  end
end

local term = require "lux.terminal"

expect "hey"
term.write "hey"

expect "hey\n"
term.line "hey"

expect (color.red "hey")
term.write "<red>hey<reset>"

expect (color.bright .. color.green "hey")
term.write "<bright><green>hey<reset>"

io.write = _write
local ok = "<bright><blue>OK<reset>"
term.line ("+-----".."--".."------+")
term.line ("|     ".. ok .."      |")
term.line ("+-----".."--".."------+")

