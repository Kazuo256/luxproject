
local color = require "lux.externals.ansicolors"
local io = io

--- LUX's terminal utility module.
module "lux.terminal" do

  function write (text, colorname)
    local c = color[colorname]
    io.write(c and c(text) or text)
  end

end

