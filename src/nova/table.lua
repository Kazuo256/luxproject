
require "nova.object"

--- LuaNova's table class module.
-- A table object is just like any table, with the addition that it has
-- methods all corresponding to all the functions from the standard
-- <code>table</code> module.
module ("nova.table", nova.object.inherit(table))

