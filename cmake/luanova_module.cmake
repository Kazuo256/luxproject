################################################################################
## LuaNova Project by Kazuo 256
## File: cmake/luanova_module.cmake
## Description:
##    Responsible for adding LuaNova's modules as targets to be built.
################################################################################

## Needs LuaDoc to automatically generate the modules' documentation.
find_program (LUADOC luadoc)

set (GENERATE_DOC NOT LUADOC STREQUAL LUADOC-NOTFOUND)

if (${GENERATE_DOC})
  message ("-- Using LuaDoc: ${LUADOC}")
else (${GENERATE_DOC})
  message ("-- !!WARNING!! LuaDoc not found, no documentation will be "
           "generated.")
endif (${GENERATE_DOC})

set (DOC_DIR doc)

function (luanova_add_modules modules)
  if (${GENERATE_DOC})
    set (outputs ${DOC_DIR}/index.html)
    foreach (module ${modules})
      string (REGEX REPLACE "^src/(.*).lua$" "${DOC_DIR}/modules/\\1.html"
              docmodule ${module})
      message ("-- Doc target: ${docmodule}")
      set (outputs ${outputs} docmodule)
    endforeach (module)
    #add_custom_command
  endif (${GENERATE_DOC})
endfunction (luanova_add_modules)

