################################################################################
## LuaNova Project by Kazuo 256
## File: CMakeLists.txt
## Description:
##    For now, this CMakeLists file configures the documentation's automatic
##  generation. It is still incomplete and unusable.
################################################################################

## Requires CMake at least version 2.8.
cmake_minimum_required (VERSION 2.8)

## Offers the luanova_add_modules function.
include (cmake/luanova_module.cmake)

luanova_add_modules (src/nova.lua)

