#!/bin/bash

ver="_$(echo $1 | sed s/[.]/_/)"
rocktree="$(pwd)/.rocktree"
config_file="$rocktree/config.lua"

echo "Rocktree: $rocktree"
echo "Config file: $config_file"

export LUA_PATH$ver="$rocktree/share/lua/$1/?.lua;$rocktree/share/lua/$1/?/init.lua"

export LUA_CPATH$ver="$rocktree/lib/lua/$1/?.so"

export LUAROCKS_CONFIG$ver=$config_file

export PATH="$(pwd)/.rocktree/bin:$PATH"

mkdir -p $rocktree

if [ ! -f $config_file ]; then
  echo "rocks_trees = { { name='user', root='$rocktree' } }" > $config_file
fi

echo "Lua rocktree set up"

