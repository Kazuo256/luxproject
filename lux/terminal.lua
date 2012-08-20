
local color = require "lux.externals.ansicolors"
local io = io
local print = print
local tostring = tostring
local gsub = string.gsub

--- LUX's terminal utility module.
module "lux.terminal" do

  local function format_color (str)
    return gsub(
      str,
      "<([:%a]+)>",
      function (tag)
        local colorcode = color[tag]
        return colorcode and tostring(colorcode) or "<"..tag..">"
      end
    )
  end

  function line (text)
    local output = format_color(text)
    print(output)
  end

end

