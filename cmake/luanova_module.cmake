################################################################################
## LuaNova Project by Kazuo 256
## File: cmake/luanova_module.cmake
## Description:
##    Responsible for adding LuaNova's modules as targets to be built.
################################################################################

## Needs LuaDoc to automatically generate the modules' documentation.
find_program (LUADOC luadoc)

if (LUADOC STREQUAL LUADOC-NOTFOUND)
  message ("-- !!WARNING!! LuaDoc not found, no documentation will be "
           "generated.")
else (LUADOC STREQUAL LUADOC-NOTFOUND)
  message ("-- Using LuaDoc: ${LUADOC}")
endif (LUADOC STREQUAL LUADOC-NOTFOUND)

function (luanova_add_modules modules)
  #add_custom_command
endfunction (luanova_add_modules)

