
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

end

