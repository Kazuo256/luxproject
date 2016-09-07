--[[
--
-- Copyright (c) 2013-2016 Wilson Kazuo Mizutani
--
-- This software is provided 'as-is', without any express or implied
-- warranty. In no event will the authors be held liable for any damages
-- arising from the use of this software.
--
-- Permission is granted to anyone to use this software for any purpose,
-- including commercial applications, and to alter it and redistribute it
-- freely, subject to the following restrictions:
--
--    1. The origin of this software must not be misrepresented; you must not
--       claim that you wrote the original software. If you use this software
--       in a product, an acknowledgment in the product documentation would be
--       appreciated but is not required.
--
--    2. Altered source versions must be plainly marked as such, and must not be
--       misrepresented as being the original software.
--
--    3. This notice may not be removed or altered from any source
--       distribution.
--
--]]

--- A module for managing Lua's paths.
--  @module lux.path
local path = {}

local paths
local index

local set_path

local function update_path ()
  set_path(path.get())
end

--- Gets the current path.
--  @treturn string The current path
function path.get ()
  local result = ""
  for _,p in ipairs(paths) do
    result = result .. ";" .. p.path
  end
  return result
end

--- Searches for a lua module in the current path.
--  @tparam string mod The module to be searched
--  @treturn string
--  The path to the Lua file if it is found, or else `nil` plus the the
--  sequence of files it checked.
function path.search (mod)
  local checks = {}
  local modpath = mod:gsub('%.', '/')
  for _,entry in pairs(paths) do
    local filename = entry.path:gsub('%?', modpath)
    local file = io.open(filename, 'r')
    if file then
      file:close()
      return filename
    end
    table.insert(checks, filename)
  end
  return nil, checks
end

--- Clears all registered paths and set path handler
--  @tparam function default_path
--  The default path
--  @tparam function set
--  A function that sets the current path
function path.clear (default_path, set)
  paths = {}
  index = {}
  set_path = set or function (p) package.path = p end
  local id = 1
  for p in default_path:gmatch "([^;]+)" do
    path.add(id, p)
    id = id + 1
  end
  update_path()
end

--- Adds a path.
--  @tparam string id
--  An identifier for the path
--  @tparam string path
--  The path added
--  @see path.remove
function path.add (id, path)
  assert(not index[id], "ID already in use")
  table.insert(paths, { id = id, path = path })
  index[id] = #paths
  update_path()
end

--- Removes the path assigned to the given identifier.
--  @tparam string id
--  The identifier for the to-be-removed path
--  @see path.add
function path.remove (id)
  local i = index[id]
  table.remove(paths, i)
  index[id] = nil
  for j = i,#paths do
    index[paths[j].id] = j
  end
  update_path()
end

path.clear(package.path)

return path
