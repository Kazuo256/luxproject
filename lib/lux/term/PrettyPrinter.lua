
local port  = require 'lux.portable'
local color = require 'lux.term.ansicolors'

local PrettyPrinter = require 'lux.class' :new {}

local out       = io.output()
local tostring  = tostring

function PrettyPrinter:instance(_ENV, tags)
  
  if port.isVersion(5,1) then
    setfenv(1, _ENV)
  end

  tags = tags or {}

  local function log_print (color_tag, id, ...)
    out:write(
      tostring(color.bright),
      tostring(color[color_tag]),
      "[" .. id .. "]",
      tostring(color.clear),
      " ", ...
    )
    out:write '\n'
  end

  function report (...)
    return log_print('white', tags.report or 'report', ...)
  end

  function failure (...)
    return log_print('red', tags.failure or 'failure', ...)
  end

  function success (...)
    return log_print('green', tags.success or 'success', ...)
  end

end

return PrettyPrinter

