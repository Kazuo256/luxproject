
Lua Utility eXtension Project
=============================

This document is still a stub.

1. Description:

  Lua Utility eXtension (LUX) is a project whose objective is to make some extension
  facilities to the programming language Lua. It is written in Lua 5.1.X,
  which means you may use it in your own project without having to worry
  (much) about which Lua distribution you are using - it may very well be your
  own distribution - as long as it is derived from Lua 5.1 or later.

  The extensions this project intends to provide for now are:
  - Some all-purpose functionalities that are commonly needed.
  - A simple Object Oriented system.
  - A Functional utility module.
  - An Unit Test module.
  - A Mock module.
  - A Macro feature module.

  New extensions may appear on the future, as I learn more and think up new
  ideas ;).

2. Usage notes:

  1. Importing LUX
    The Lua module itself is named as "lux", so import it with
    ```lua
    require "lux.object"
    ```
    for instance.

