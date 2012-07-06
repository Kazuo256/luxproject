
--- LuaNova's common module.
-- Here a collection of general-purpose functions are available.
module ("nova.common", package.seeall) do
  --- Prints all key-value pairs of the given table to the standard output.
  -- @param t The table whose field are to be listed.
  function ls (t)
    table.foreach(t, print)
  end
  
  --- Binds the setmetatable function to the given metatable argument.
  -- @param metatable A metatable to be binded to the setmetatable function.
  -- @return A function that takes a table as argument, and sets its metatable
  --         to the one given here.
  function metabinder (metatable)
    return bind(function(meta,t) setmetatable(t,meta) end, metatable)
  end
  
end

