
--- LUX's functional programming module.
-- Some functional programming tools lay around here.
module ("lux.functional", package.seeall) do

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
      return f(unpack(args), ...)
    end
  end

  --- Creates a <code>n</code>-chained function based on <code>f</code>.
  -- <p>
  --  Chained functions receive their arguments in consecutive calls. For
  --  instance, if <code>f</code> was the usual <code>print</code> and
  --  <code>n</code> was 1, you would use the resulting function like this:
  -- </p>
  -- <p><code>
  -- local result = chain(print,1)
  -- </code></p>
  -- <p><code>
  -- result (arg1) (arg2, arg3, ...)
  -- </code></p>
  -- <p>
  --  Using <code>n</code> was 2, then the call would be:
  -- </p>
  -- <p><code>
  -- result (arg1) (arg2) (arg3, arg4, ...)
  -- </code></p>
  -- <p>
  --  And so on.
  -- </p>
  -- @param f The function being chained.
  -- @param n The size of the chain.
  -- @return An <code>n</code>-chained function version of <code>f</code>.
  function chain (f, n)
    n = n or 1
    return function (...)
      local first, second = ...
      if n >= 1 and not second then
        if first then
          return chain(bindleft(f, first), n-1)
        else
          return chain(f, n)
        end
      else
        return f(...)
      end
    end
  end

end

