
local color     = require "lux.externals.ansicolors"
local tostring  = tostring
local gsub      = string.gsub
local io        = io

--- LUX's terminal utility module.
--
-- <p>
-- The terminal output functions take strings with formatted colors as
-- arguments. That means sush string may have a color tag. There are three types
-- of color tags: attributes, foreground and background colors. Tags must be
-- given between <code> < </code>and<code> ></code>. Once used, a tag remains
-- active in the terminal, until some other tag overwrites it. Note that the
-- color tag remains active even after the program has finished.
-- </p>
--
-- <p>Atribute tags:</p>
-- <ul>
--  <li><code>reset</code></li>
--  <li><code>clear</code></li>
--  <li><code>bright</code></li>
--  <li><code>dim</code></li>
--  <li><code>underscore</code></li>
--  <li><code>blink</code></li>
--  <li><code>reverse</code></li>
--  <li><code>hidden</code></li>
-- </ul>
--
-- <p>Foreground color tags:</p>
-- <ul>
--  <li><code>black</code></li>
--  <li><code>red</code></li>
--  <li><code>green</code></li>
--  <li><code>yellow</code></li>
--  <li><code>blue</code></li>
--  <li><code>magenta</code></li>
--  <li><code>cyan</code></li>
--  <li><code>white</code></li>
--  </ul>
--
-- <p>Background color tags:</p>
-- <ul>
--  <li><code>onblack</code></li>
--  <li><code>onred</code></li>
--  <li><code>ongreen</code></li>
--  <li><code>onyellow</code></li>
--  <li><code>onblue</code></li>
--  <li><code>onmagenta</code></li>
--  <li><code>oncyan</code></li>
--  <li><code>onwhite</code></li>
--  </ul>
--
module "lux.terminal" do

  local function format_color (str)
    return gsub(
      str,
      "<(%a+)>",
      function (tag)
        local colorcode = color[tag]
        return colorcode and tostring(colorcode) or "<"..tag..">"
      end
    )
  end

  --- Print a line with formatted colors.
  -- @param text A string possibly containing color tags.
  function line (text)
    write(text.."\n")
  end

  --- Writes to the standard output with formatted colors.
  -- @param text A string possibly containing color tags.
  function write (text)
    -- used to throw out extra returned values
    local output = format_color(text)
    io.write(output)
  end

end

