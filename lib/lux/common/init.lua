
local common = require 'lux.pack' 'lux.common'

function common.printf(s, ...)
  return print(string.format(s, ...))
end

function common.identityp(...)
  print(...)
  return ...
end

return common

