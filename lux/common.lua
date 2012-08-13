
--- LUX's common module.
-- Here a collection of general-purpose functions are available.
module ("lux.common", package.seeall) do

  --- Prints all key-value pairs of the given table to the standard output.
  -- @param t The table whose field are to be listed.
  function ls (t)
    table.foreach(t, print)
  end
  
end

