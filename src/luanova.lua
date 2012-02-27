--- Main LuaNova file.
-- File version: 0.0.0

--- The LuaNova module.
-- @field version The version of this LuaNova module.
luanova = {}

luanova.version = "0.0.0"


--- Prints all key-value pairs of the given table to the standard output.
-- @param t The table whose field are to be listed.
function luanova.ls(t)
  for k,v in pairs(t) do
    print(k,v)
  end
end


