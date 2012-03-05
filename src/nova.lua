--- Main LuaNova module.
-- @autor Kazuo256
module("nova", package.seeall)

--- Contains information about LuaNova nova's module.
-- @field version The version of this LuaNova module.
info = {
  version = "0.0.0"
}


--- Prints all key-value pairs of the given table to the standard output.
-- @param t The table whose field are to be listed.
function ls(t)
  for k,v in pairs(t) do
    print(k,v)
  end
end


