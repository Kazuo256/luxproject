
--- LuaNova's functional programming module.
-- Some functional programming tools lay around here.
module ("nova.functional", package.seeall) do

  --- Converts an array to an argument list.
  -- Here, an array means the n first elements of a table, indexed from 1 to n.
  -- The argument list works exactly like the "..." expression.
  -- @param t The table from where the argument list will be extracted.
  -- @param i Used for internal recursion. No need to worry about it.
  --          Defaults to nil, and that is ok.
  -- @return An argument list that works just like a "..." expression.
  function toargs (t, i)
    if not i then return toargs(t, 1) end
    if t[i] then return t[i], toargs(t, i+1) end
  end
  
  --- Binds a function to the given (left-most) arguments.
  -- The arguments must be passed in the apropriate order, according to the
  -- function's specification.
  -- @param f The function being binded.
  -- @param ... The bound arguments, in order.
  -- @return A function that, upon being called, does the same as f, but
  --         requires only the remaining right-most arguments that were not
  --         binded with it.
  function bindleft (f, ...)
    local args = { ... }
    return function (...)
      return f(toargs(args), ...)
    end
  end

end

