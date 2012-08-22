
local color     = require "lux.externals.ansicolors"
local tostring  = tostring
local gsub      = string.gsub
local io        = io

--- LUX's terminal utility module.
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

  function line (text)
    write(text.."\n")
  end

  function write (text)
    -- used to throw out extra returned values
    local output = format_color(text)
    io.write(output)
  end

end

