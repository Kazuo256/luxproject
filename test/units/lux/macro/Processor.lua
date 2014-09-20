
local Processor = require 'lux.macro.Processor'

local proc, instream, outstream
local fixtures = {
  {
    name = "no_macro",
    input = [[
asdasdasd
asdasdasd
asdasdasd
]],
    output = [[
asdasdasd
asdasdasd
asdasdasd
]]
  },
  {
    name = "single_direct",
    input = [[stuff $=5+4=$]],
    output = [[stuff 9]]
  },
  {
    name = "single_direct_nomacro",
    input = [[stuff $=5+4=]],
    output = [[stuff $=5+4=]]
  },
  {
    name = "single_for",
    input = [[
$: for i=1,3 do
foo
$: end
]],
    output = [[
foo
foo
foo
]]
  },
  {
    name = "single_nested_for",
    input = [[
$: for i=1,3 do
$: for j=1,2 do :$bar $: end :$
$: end
]],
    output = [[
bar bar 
bar bar 
bar bar 
]]
  },
  {
    name = "single_progressive_for",
    input = [[
$: for i=1,5 do
$: for j=1,i do :$*$: end :$
$: end
]],
    output = [[
*
**
***
****
*****
]]
  },
  {
    name = "single_stringdump",
    input = [[
x = $|"a".."b"|$
]],
    output =
"x = [[ab]]\n"
  },
  {
    name = "single_stringquote",
    input = [[
x = $=mq("a".."b")=$
]],
    output =
"x = [[ab]]\n"
  }
}

function before ()
  proc = Processor:new {}
  instream = {}
  function instream:receive (quantity)
    assert(quantity == "*a")
    return self.input
  end
  outstream = {
    stored = ""
  }
  function outstream:send (data)
    self.stored = self.stored .. data
  end
  function outstream:check (output)
    return self.stored == output
  end
end

local function make_error_text (errmsg, result)
  return tostring(errmsg) .. " ("..outstream.stored..")"
end

for _,fixture in ipairs(fixtures) do
  getfenv()["test_"..fixture.name] = function ()
    instream.input = fixture.input
    local check, errmsg = pcall(
      function ()
        return proc:process(instream, outstream)
      end
    )
    if fixture.fails then
      assert(not check, make_error_text(errmsg, outstream.stored))
    else
      assert(check and outstream:check(fixture.output), make_error_text(errmsg, outstream.stored))
    end
  end
end

