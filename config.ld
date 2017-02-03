
project = "LUX"

title = "LUX Documentation and Reference"

description = [[
The Lua Utility eXtension Project is a general purpose Lua distribution
developed with both [LuaRocks](https://luarocks.org/) and
[LÖVE](https://love2d.org/) compatibility in mind.
]]

full_description = [[
It bundles rocks on a per-project basis, injecting a local rocktree in the
source tree. This allows LÖVE application developers to distribute their
dependencies together with the application package, while also benefiting from
the LuaRocks ecosystem. However, the LUX distribution is also completely
adequate for developing non-LÖVE applications. Here's a quick rundown of the
main features present in this Lua distribution:

1. Portability with Lua 5.1 through 5.3
2. Rock bundling on a per-project basis
3. Bundle-aware script execution
4. Prototype-based Object Oriented system
5. Class-based Object Oriented system
6. Functional programming library
7. Macro/Template processing
8. Unit test tools
9. Prettified console output
]]

file = "lib"
dir = "doc/html"
pretty = "lxsh"
style = "doc"
template = "doc"
merge = true
manual_url "http://www.lua.org/manual/5.3/manual.html"
examples = "examples"
format = "discount"

new_type("prototype", "Prototypes", true)
new_type("constructor","Constructors",false,"param")
