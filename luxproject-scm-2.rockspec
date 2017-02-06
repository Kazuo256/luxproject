package = "luxproject"
version = "scm-1"
source = {
  url = "https://github.com/kazuo256/luxproject/"
}
description = {
  summary = "A LuaRocks and LÖVE compatible general-purpose Lua distribution",
  detailed = [[
The Lua Utility eXtension Project is a general purpose Lua distribution
developed with both [LuaRocks](https://luarocks.org/) and
[LÖVE](https://love2d.org/) compatibility in mind.

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
]],
  homepage = "http://kazuo256.github.io/luxproject/",
  license = "MIT/X11"
}
dependencies = { "lua >= 5.1, < 5.4" }
build = {
  type = "builtin",
  modules = {
    ["lux.bundler"] = "lib/lux/bundler.lua",
    ["lux.class"] = "lib/lux/class.lua",
    ["lux.info"] = "lib/lux/info.lua",
    ["lux.macro"] = "lib/lux/macro.lua",
    ["lux.macro.takeover"] = "lib/lux/macro/takeover.lua",
    ["lux.pack"] = "lib/lux/pack.lua",
    ["lux.path"] = "lib/lux/path.lua",
    ["lux.portable"] = "lib/lux/portable.lua",
    ["lux.prototype"] = "lib/lux/prototype.lua",
    ["lux.common.Queue"] = "lib/lux/common/Queue.lua",
    ["lux.term.PrettyPrinter"] = "lib/lux/term/PrettyPrinter.lua",
    ["lux.term.ansicolors"] = "lib/lux/term/ansicolors.lua",
    ["lux.term.color"] = "lib/lux/term/color.lua",
    ["lux.test"] = "lib/lux/test.lua",
  },
  copy_directories = { "doc" },
  install = {
    bin = {
      lux = "bin/lux.lua"
    }
  }
}
