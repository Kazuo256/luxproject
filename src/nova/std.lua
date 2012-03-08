
--- LuaNova's standard module.
module("nova.std", package.seeall)
do
  --- Prints all key-value pairs of the given table to the standard output.
  -- @param t The table whose field are to be listed.
  function ls(t)
    for k,v in pairs(t) do
      print(k,v)
    end
  end
  
  --- Converts an array to an argument list.
  -- Here, an array means the n first elements of a table, indexed from 1 to n.
  -- The argument list works exactly like the "..." expression.
  -- @param t The table from where the argument list will be extracted.
  -- @param i Used for internal tail recursion. No need to worry about it.
  --          Defaults to nil, and that is ok.
  -- @return An argument list that works just like a "..." expression.
  function toargs(t, i)
    if not i then return toargs(t, 1) end
    if t[i] then return t[i], toargs(t, i+1) end
  end
  
  --- Binds a function to the given arguments.
  -- The arguments must be passed in the apropriate order, according to the
  -- function's specification.
  -- @param f The function being binded.
  -- @param ... The binded arguments, in order.
  -- @return A function that, upon being called, does the same as f, but
  --         requires only the remaining right-most arguments that were not
  --         binded with it.
  function bind(f, ...)
    local args = { ... }
    return function (...)
      return f(toargs(args), ...)
    end
  end
  
  --- Binds the setmetatable function to the given metatable argument.
  function bindmetatable(metatable)
    return bind(function(meta,t) setmetatable(t,meta) end, metatable)
  end
  
end

